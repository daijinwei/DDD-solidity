// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
请根据所学内容，编写一个Solidity合约，实现以下功能：

1. 定义一个透明可升级代理合约，包含以下函数：
- 存储实现地址和管理员地址
- 分离管理员和用户接口
- 通过 `ifAdmin` 修饰符控制函数访问权限
2. 定义一个简单的实现合约，包含一个返回地址的函数。
3. 编写测试脚本：
- 部署代理合约和实现合约
- 测试不同地址调用函数的结果（管理员和非管理员）

测试办法：
1.部署proxy2合约，部署Coutner1合约
2.复制counter1的地址升级合约，再更具proxy2合约地址重新生成Counter1合约
3.分别切换两个用户，调用coutner1中的getAdmin函数，看看返回值是否一样
预期：1.admin用户返回的是proxy2中的getAdmin。 其他用户返回的是Counter中的getAdmin
*/



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
contract Proxy2{
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

    function admin()external IfAdmin  returns(address){
        return _getAdmin();
    }

    function implementation()external  IfAdmin  returns(address){
        return _getImplementation();
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
