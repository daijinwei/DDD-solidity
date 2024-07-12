// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 一个生产环境中的例子
contract MyOwner {
    address public owner;
    // 构造函数
    constructor(){
        owner = msg.sender;
    }

    // 定义MyOwner装饰器
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

    // 只有owner 才能修改owner关系
    function transferOwnership(address _newOwner)public onlyOwner{
        require(msg.sender != address(0), "Invalid address");
        owner = _newOwner;
    }

    // 任何人都可以调用的函数
    function getOwnership()external view returns (address) {
        return owner;
    }
}
