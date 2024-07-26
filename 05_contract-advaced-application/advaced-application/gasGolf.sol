// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
在Solidity中创建一个智能合约，实现一个名为`optimizeGasUsage`的函数，该函数接受一个整数数组。该函数将执行以下操作：

1. 使用上述所有燃气优化技术。
2. 计算数组中所有小于100的偶数的和。
3. 返回计算结果。

#### 提交要求

- 提交完整的Solidity合约代码。
- 包括一段说明，描述每项优化对燃气消耗的具体影响。
*/

contract GasGolf{
    // start----------- 54654
    // calldata 优化
    // loadstat variable to memory
    // shor cicurs
    // loop increment
    // cache array length
    // load array element to memory
    uint public total;

    // arr [1,2,3,4,5]
    function sum(uint[] memory arr)external returns(uint) {
        for(uint i=0; i<arr.length ; i=i+1){
            bool isEven =  arr[i] % 2 == 0;
            bool isLessThan99 = arr[i] < 99;
            if(isEven && isLessThan99) {
                total += arr[i];
            }
        }
        return total;
    }
}


contract GasGolf1{
    // start----------- 54654
    // calldata 优化 --- 54025
    // loadstat variable to memory
    // shor cicurs
    // loop increment
    // cache array length
    // load array element to memory
    uint public total;

    // arr [1,2,3,4,5]
    function sum(uint[] calldata arr)external returns(uint) {
        for(uint i=0; i<arr.length ; i=i+1){
            bool isEven =  arr[i] % 2 == 0;
            bool isLessThan99 = arr[i] < 99;
            if(isEven && isLessThan99) {
                total += arr[i];
            }
        }
        return total;
    }
}


contract GasGolf2{
    // start----------- 54654
    // calldata 优化 --- 54025
    // loadstat variable to memory--- 53663
    // shor cicurs
    // loop increment
    // cache array length
    // load array element to memory
    uint public total;

    // arr [1,2,3,4,5]
    function sum(uint[] calldata arr)external returns(uint) {
        uint _total;
        for(uint i=0; i<arr.length ; i=i+1){
            bool isEven =  arr[i] % 2 == 0;
            bool isLessThan99 = arr[i] < 99;
            if(isEven && isLessThan99) {
                _total += arr[i];
            }
        }
        total = _total;
        return total;
    }
}


contract GasGolf3{
    // start----------- 54654
    // calldata 优化 --- 54025
    // loadstat variable to memory--- 53663
    // shor cicurs--------------------53321
    // loop increment
    // cache array length
    // load array element to memory
    uint public total;

    // arr [1,2,3,4,5]
    function sum(uint[] calldata arr)external returns(uint) {
        uint _total;
        for(uint i=0; i<arr.length ; i=i+1){
            if(arr[i] % 2 == 0 && arr[i] < 99 )  {
                _total += arr[i];
            }
        }
        total = _total;
        return total;
    }
}


contract GasGolf4{
    // start----------- 54654
    // calldata 优化 --- 54025
    // loadstat variable to memory--- 53663
    // shor cicurs--------------------53321
    // loop increment-----------------52896
    // load array element to memory
    // cache array length 
    uint public total;

    // arr [1,2,3,4,5]
    function sum(uint[] calldata arr)external returns(uint) {
        uint _total;
        for(uint i=0; i<arr.length ; ++i){
            if(arr[i] % 2 == 0 && arr[i] < 99 )  {
                _total += arr[i];
            }
        }
        total = _total;
        return total;
    }
}

contract GasGolf5{
    // start----------- 54654
    // calldata 优化 --- 54025
    // loadstat variable to memory--- 53663
    // shor cicurs--------------------53321
    // loop increment-----------------52896
    // load array element to memory---52730
    // cache array length 
    uint public total;

    // arr [1,2,3,4,5]
    function sum(uint[] calldata arr)external returns(uint) {
        uint _total;
        for(uint i=0; i<arr.length ; ++i){
            uint num = arr[i];
            if(num % 2 == 0 && num < 99 )  {
                _total += num;
            }
        }
        total = _total;
        return total;
    }
}
