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

/*
测试方法：
先部署GoodProxy，Counter1, Counter2

再复制Counter1的地址到GoodProxy upgrade函数里，再代理合约里调用

再把GoodProxy复制到address里，重新生成counter1 新合约，就可以通过代理操作合约了

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
contract GoodProxy{
    address public implemention;
    address public admin;

    // 构造函数
    constructor(){
        admin = msg.sender;
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
        _delegate(implemention);
    }
    // receive() external payable: 仅用于接收以太币时调用，也将调用委托到 implemention。
    receive() external payable {
        _delegate(implemention);
    }

    // 升级合约的函数
    function upgrade(address _implemention) external{
        require(admin == msg.sender, "Not authorized");
        implemention = _implemention;
    }
}
