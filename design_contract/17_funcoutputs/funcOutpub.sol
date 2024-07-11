// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 一个生产环境中的例子
contract FunctionOutputs {
    // 返回多个值，元组方式返回
    function returnMultiple()public pure returns (uint, bool){
        return (1, true);
    }

    // 命名式返回
    function returnNamed() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
        _number = 2;
        _bool = false; 
        _array = [uint256(3),2,1];
    }

    // 解构式返回
    function readReturn() public pure returns (uint _x, bool _bool){   
        // 读取部分返回值，解构式赋值
        (_x,  _bool) = returnMultiple();
    }
}
