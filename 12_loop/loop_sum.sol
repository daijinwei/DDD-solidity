// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Sum {
    function sum(uint n) external pure returns (uint){
        uint s;

        for(uint i=1; i <= n; i++){
            s += i;
        }
        return s;
    }
}
