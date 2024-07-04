// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Calculator{
    uint public storedData;
    // external 合约上可以调用这个函数
    // pure 代表链上不写数据
    function set(uint x) public {
         storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }   

}
