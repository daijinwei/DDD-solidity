// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
任务：实现一个简单的可升级代理合约，并解决上述错误。

步骤：

1. 编写 `CounterV1` 合约，包含 `count` 状态变量和 `increment` 函数。
2. 编写 `CounterV2` 合约，添加 `decrement` 函数。
3. 编写代理合约 `BuggyProxy`，初始设置为 `CounterV1`。
4. 使用 `delegatecall` 实现函数调用转发。
5. 解决存储布局不一致的问题。
6. 修改回退函数，确保能够返回数据。

1. 确保所有实现合约与代理合约的存储布局一致。
2. 修改回退函数，确保能够返回数据。

*/


contract Counter1{
    address public implemention;
    address public admin;

    uint256 public count;
    function incr() external {
        count++;
    }
}

contract Counter2{
    address public implemention;
    address public admin;

    uint256 public count;
    function incr() external {
        count++;
    }

    function desc() external {
        count--;
    }
}

// 有问题代升级合约函数
contract BuggyProxy{
    address public implemention;
    address public admin;

    // 构造函数
    constructor(){
        admin = msg.sender;
    }

    // _delegate(): 使用 delegatecall 将当前合约的函数调用和数据委托给 implemention 地址的合约。
    // delegatecall 使得调用的合约使用调用者的存储和上下文。
    function _delegate()private {
       (bool ok, ) = implemention.delegatecall(msg.data);
       require(ok, "delegate failed");
    }

    //回退函数: fallback() external payable: 处理未匹配的函数调用或发送以太币时的调用，将调用委托到 implemention。
    fallback() external payable { 
        _delegate();
    }
    // receive() external payable: 仅用于接收以太币时调用，也将调用委托到 implemention。
    receive() external payable {
        _delegate();
    }

    // 升级合约的函数
    function upgrade(address _implemention) external{
        require(admin == msg.sender, "Not authorized");
        implemention = _implemention;
    }
}
