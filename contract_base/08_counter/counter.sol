// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter{
    uint public count;
    // external 外部函数，外部函数只能被合约外部的地址调用，而不能被合约内部的其他函数调用。这种限制有助于减少合约的复杂性和提高安全性。
    function inc() external{
        count +=1;
    }
    function dec() external {
        count -=1;
    }
}
