// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Calculator{
    // external 合约上可以调用这个函数
    // pure 代表链上不写数据
    function add(uint x, uint y) external pure returns (uint) {
        return x+y;
    }

    function multiply(uint x, uint y) external pure returns (uint) {
        return x *y;
    }   

    function divide(uint x, uint y) external pure returns (uint){
        return x/y;
    }
}
