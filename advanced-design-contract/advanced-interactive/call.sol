// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
根据课程内容，编写一个Solidity合约，实现以下功能：

1. 创建一个名为`TestContract`的合约，包含以下函数：
- `foo(string memory _msg, uint256 _num)`: 接受字符串和uint256类型参数，并更新状态变量`message`和`number`。
- `fallback() external`: 回退函数，记录日志"Fallback was called"。
2. 创建一个名为`Caller`的合约，包含以下函数：
- `callFoo(address _testContract, string memory _msg, uint256 _num)`: 使用call调用`TestContract`合约中的`foo`函数，并传递参数。
- `callNonExistentFunction(address _testContract)`: 使用call调用一个不存在的函数，验证回退函数是否被调用。

编写完成后，部署并测试这两个合约，验证所有功能是否正常工作
*/

contract TestContract{
    event Log(string msg);
    string public message;
    uint256 public number;

    receive() external payable{}
    fallback() external payable {
        emit Log("fallback was called");
    }

    function foo(string memory _msg, uint256 _num)external {
        message = _msg;
        number = _num;
    }
}

contract Caller{
    bytes public data;
    // 利用abi 接口调用函数
    function callFoo(address _testContract, string memory _msg, uint256 _num) external payable{
        (bool success, bytes memory _data) = _testContract.call(abi.encodeWithSignature("foo(string,uint256)", _msg, _num));
        require(success, "call foo failed");
        data = _data;
    }

   function callNonExistentFunction(address _test)external{
        (bool success,) = _test.call(abi.encodeWithSignature("FuncNotExists()"));
        require(success, "FuncNotExists");
    }
}
