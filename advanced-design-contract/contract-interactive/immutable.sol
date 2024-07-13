// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. 编写一个Solidity合约，包含以下要求：
- 定义一个名为`owner`的状态变量，并使用`immutable`关键字。
- 在合约的构造函数中将`owner`初始化为`msg.sender`。
- 编写一个函数`getOwner`，返回`owner`的值。
2. 编译并部署合约。
3. 调用`getOwner`函数，验证合约部署时`owner`的值正确性。


目的：immutable，节省gas
*/

contract ImmutableExample {
    address public immutable  owner;

    constructor() {
        owner = msg.sender;
    }
    // gas: 2284
    // immutable gas: 167
    function getOwner() public view returns (address) {
        return owner;
    }
}
