// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

//181 gas
contract ConstantVar{
    address public constant MY_ADDR = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;  
}

// 2301 gas, 说明常量消耗的gas比变量消耗的gas少
contract Var{
    address public  MY_ADDR = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;  
}
