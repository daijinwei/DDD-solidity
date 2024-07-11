// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ErrorHandling {
    uint num = 123;

    error MyError(address caller, uint i);

    function testRequire(uint i) public pure {
        require(i <= 10, "i is greater than 10");
    }

    function testRevert(uint i) public pure {
        if (i > 10) {
            revert("i is greater than 10");


        }
    }

    function testAssert() public view {
        assert(num == 123);
    }

    function testCustome(uint i)public  {
        num += 1;
        if(i > 10){
            revert MyError(msg.sender, i);
        }
    }
}
