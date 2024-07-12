// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConstructorExcample {
    address public owner;
    uint public storageData;
    // 构造函数，和c++构造函数用途一样，只在部署合约时时用，初始化一些合约状态变量。
    constructor(uint _x) {
        owner = msg.sender;
        storageData = _x;
    }
    function getData()external view returns(uint){
        return storageData;
    }
}
