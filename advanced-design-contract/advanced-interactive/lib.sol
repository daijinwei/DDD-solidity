// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编程作业
作业描述

编写一个Solidity合约，使用Library实现以下功能：

1. 创建一个名为`MathLib`的Library，包含一个`min`函数，用于返回两个`uint`类型整数中的较小值。
2. 创建一个名为`ArrayUtils`的Library，包含一个`sum`函数，用于计算并返回`uint`类型数组中所有元素的和。
3. 在测试合约中使用这两个Library，验证其功能。

#### 作业要求

1. 创建`MathLib`并实现`min`函数。
2. 创建`ArrayUtils`并实现`sum`函数。
3. 创建测试合约`TestLibraries`，在合约中使用`MathLib.min`函数和`ArrayUtils.sum`函数。
4. 部署并测试合约，确保函数正确执行。
*/

library MathLib{
    function min(uint x, uint y)external pure returns(uint){
        return x > y ? y :x;
    }

}

library ArrayUtils{
    function sum(uint[] memory arr)external pure returns(uint){
        uint s = 0;
        for(uint i=0; i < arr.length; i++){
            s += arr[i];
        }
        return s;
    }
}


contract TestLibraries{
    // 相当于给arr实现了ArrayUtils中的所有方法
    using ArrayUtils for uint[];
    uint[] public arr = [1,2,3];
    function min(uint x, uint y) external pure returns(uint){
        return MathLib.min(x, y);
    }

    function sum() external view returns(uint){
        return arr.sum();
    }
}
