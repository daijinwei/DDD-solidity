// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
编程作业

编写一个Solidity合约，包含以下功能：

1. 实现一个名为 `sumFunc` 的函数，接受六个参数：三个整数 `x, y, z`，一个地址 `a`，一个布尔值 `b` 和一个字符串 `c`。
2. 实现另一个函数 `callWithKeyValue`，该函数使用键值对调用 `sumFunc` 函数，传入任意顺序的参数，并返回一些结果。
*/

contract CallFuncWithKeyValue{
    function name_func(uint x, uint y, uint z, uint a, address addr) private returns(uint){
        
    }

    function callFunc()external returns(uint){
        return name_func(
            {
                x:1,
                y:2,
                z: 3,
                a: 4,
                addr: address(this)
            }
        );
    }
}
