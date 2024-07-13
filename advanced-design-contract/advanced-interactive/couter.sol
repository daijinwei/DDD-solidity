// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Coutner{
    uint public num;

    function count() external view returns (uint){
        return num;
    }

    function increment() external{
        num = num + 1;
    }
}
