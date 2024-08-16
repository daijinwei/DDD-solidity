// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
编写一个简单的Solidity合约，包含以下功能：
1. 定义一个存储槽用于存储字符串：
- 使用`keccak256`哈希函数生成存储槽
- 定义结构体`StringSlot`包含一个字符串字段
2. 编写getter和setter函数：
- `setStringSlot(string memory newValue)`：将字符串存储到指定槽中
- `getStringSlot() public view returns (string memory)`：从指定槽中读取字符串
3. 测试合约：
- 部署合约并调用setter函数存储字符串
- 调用getter函数验证存储的字符串是否正确

*/
contract Counter1{
    uint256 public count;
    function incr() external {
        count++;
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
contract Proxy{
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

    //回退函数: fallback() external payable: 处理未匹配的函数调用或发送以太币时的调用，将调用委托到 implemention。
    fallback() external payable { 
        _delegate(_getImplementation());
    }
    // receive() external payable: 仅用于接收以太币时调用，也将调用委托到 implemention。
    receive() external payable {
        _delegate(_getImplementation());
    }

    // 升级合约的函数
    function upgrade(address _implemention) external{
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

    function admin()external view returns(address){
        return _getAdmin();
    }

    function implementation()external view returns(address){
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
