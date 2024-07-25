// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
任务：使用Solidity编写一个合约，实现multicall合约的功能。 要求：

- 创建一个名为 Multicall 的合约。
- 实现一个名为 multicall 的函数，接受合约地址和调用数据作为参数。
- multcall函数应为external view，并返回每个调用的结果。
- 在multicall函数内部，使用静态调用（static call）方式调用每个目标合约的函数，并将结果存储在字节数组中。
- 编写测试用例验证Multicall合约的功能。

提示：
- 可以使用Solidity 0.8版本进行开发。
- 参考文字稿中的实现思路和代码结构。
- 在编写合约时注意合约的安全性和效率。
- 测试用例应包含针对不同场景的测试，例如调用多个合约、调用多个函数等。
*/

contract TestMulticall{
    function fn1() external view returns(uint, uint) {
        return (1, block.timestamp);
    }

    function fn2() external view returns(uint, uint) {
        return (2, block.timestamp);
    }
 
    function getData1()external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.fn1.selector);
    }

    function getData2()external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.fn2.selector);
    }
}


contract Multicall{
    function multicall(address[] memory targets, bytes[] memory data) external view returns(bytes[] memory results) {
        require(targets.length == data.length, "targets lenght is not equal data.length");
        // 动态分配数组
        results = new bytes[](targets.length);
        for(uint i=0; i < targets.length; i++){
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "tx failed");
            results[i] = result;
        }
        return results;
    }
}
