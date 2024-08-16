// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Counter1{
    uint256 public count;
    function incr() external {
        count++;
    }

    function admin()external pure returns(address){
        return address(1);
    }

    function implementation()external pure returns(address){
        return address(2);
    }
}

contract Counter2{
    uint256 public count;
    function incr() external {
        count++;
    }

    function desc() external {
        count--;
    }
}

// 有问题代升级合约函数
contract Proxy3{
    bytes32 public constant IMPLEMENTION_SLOT = bytes32(uint(keccak256("eip1967.proxy.implemetation")) -1 );
    bytes32 public constant ADMIN_SLOT = bytes32(uint(keccak256("eip1967.proxy.admin")) -1 );

    // 构造函数
    constructor(){
        _setAdmin(msg.sender);
    }

    // _delegate(): 使用 delegatecall 将当前合约的函数调用和数据委托给 implemention 地址的合约。
    // delegatecall 使得调用的合约使用调用者的存储和上下文。
    function _delegate(address _implemention)private {
        assembly{
            /*
            alldatacopy 是一种 assembly 指令，用于将调用数据（calldata）从输入复制到内存中。
            在这里，它将整个调用数据从位置 0 复制到内存中的位置 0，大小为 calldatasize()。
            这确保了被代理调用的合约可以正确接收到传递给 _delegate 函数的数据。            
            */
            calldatacopy(0, 0, calldatasize())

            /*
            delegatecall 是一种低级调用方法，它允许在目标合约（即 _implemention）中执行函数，同时使用调用者的存储和上下文。参数解释：
            gas(): 传递给代理调用的剩余 gas。
            _implemention: 被代理调用的合约地址。
            0: delegatecall 的输入数据从内存位置 0 开始。
            calldatasize(): 输入数据的大小。
            0: delegatecall 的输出数据存储在内存的位置 0。
            0: 输出数据的大小。
            结果存储在 result 变量中。            
            */
            let result :=  delegatecall(gas(), _implemention, 0 , calldatasize(), 0,0)

            /*
            复制返回数据从内存中的位置 0 到调用者的内存中。returndatasize() 是返回数据的大小。
            */
            returndatacopy(0, 0, returndatasize())

            /*
            result 是 delegatecall 的返回值。switch 语句根据 result 来决定如何处理返回数据。
                case 0 { revert(0, returndatasize()) }: 如果 delegatecall 失败（result 为 0），则触发 revert，将返回数据中的内容作为 revert 错误信息。
                default { return(0, returndatasize()) }: 如果 delegatecall 成功，返回执行结果数据。
            */
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }

    }

    function _fallback() private {
        _delegate(_getImplementation());
    }

    //回退函数: fallback() external payable: 处理未匹配的函数调用或发送以太币时的调用，将调用委托到 implemention。
    fallback() external payable { 
        _fallback();
    }
    // receive() external payable: 仅用于接收以太币时调用，也将调用委托到 implemention。
    receive() external payable {
        _fallback();
    }

    modifier IfAdmin(){
        if(msg.sender == _getAdmin()){
            _;
        }else{
            _fallback();
        }
    }

    // 升级合约的函数
    function upgrade(address _implemention) external IfAdmin{
        require(_getAdmin() == msg.sender, "Not authorized");
        _setImplementation(_implemention);
    }

    function _getAdmin()private view returns(address){
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }
    function _setAdmin(address _admin)private  {
        require(_admin != address(0), "admin = 0 address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    function _getImplementation()private view returns(address){
        return StorageSlot.getAddressSlot(IMPLEMENTION_SLOT).value;
    }

    function _setImplementation(address _admin)private  {
        require(_admin != address(0), "admin = 0 address");
        StorageSlot.getAddressSlot(IMPLEMENTION_SLOT).value = _admin;
    }

    function changeAdmin(address _admin)external IfAdmin {
        _setAdmin(_admin);
    }

    function admin()external IfAdmin  returns(address){
        return _getAdmin();
    }

    function implementation()external  IfAdmin  returns(address){
        return _getImplementation();
    }
}

contract ProxyAdmin{
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "not authorized");
        _;
    }
    function getProxyAdmin(address proxy) external view returns(address){
        (bool ok, bytes memory res) = proxy.staticcall(
            abi.encodeCall(Proxy3.admin, ())
        );
        require(ok, "call faield");
        return abi.decode(res,(address));
    }

    function getProxyImpelementation(address proxy) external view returns(address){
        (bool ok, bytes memory res) = proxy.staticcall(
            abi.encodeCall(Proxy3.implementation, ())
        );
        require(ok, "call faield");
        return abi.decode(res,(address));     
    }


    function changeProxyAdmin(address payable proxy, address _admin) external onlyOwner{
        Proxy3(proxy).changeAdmin(_admin);
    }

    function upgrade(address payable proxy, address implementation) external onlyOwner{
        Proxy3(proxy).upgrade(implementation);
    }
}


library StorageSlot {
    struct AddressSlot{
        address value;
    }
    function getAddressSlot(bytes32 slot) internal pure returns(AddressSlot storage r){
        assembly{
            r.slot := slot
        }
    }
}

contract TestSlot{
    bytes32 public constant SLOT = keccak256("TEST_SLOT");
    function getSlot() external view returns(address){
        return StorageSlot.getAddressSlot(SLOT).value;
    }

    function writeSlot(address _addr) external{
        StorageSlot.getAddressSlot(SLOT).value = _addr;
    }
}
