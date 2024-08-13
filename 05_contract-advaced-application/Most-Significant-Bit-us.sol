// SPDX-License-Identifier: MIT

/*

编程作业

任务：编写一个Solidity函数，使用二分查找法找出 `uint256` 类型数字的最高有效位。

要求 ：

定义函数 `findMostSignificantBit(uint256 x) returns (uint8 r)`。
使用二分查找法，按步骤检查 `x` 是否大于或等于 `2^n`（n为128，64，32等），并根据条件判断适当地右移 `x` 并更新 `r`。

测试：

- 输入数值8，验证返回结果是否为3。
- 输入数值9，验证返回结果是否为3。
- 输入数值15，验证返回结果是否为3

*/


pragma solidity ^0.8.7;

contract MaxBit{ 
    function maxBit(uint256 x)external pure returns (uint8 r){
        if (x >= 2**128){
            x>>=128;
            r+=128;
        }
        if (x >= 2**64){
            x>>=64;
            r+=64;
        }
        if (x >= 2**32){
            x>>=32;
            r+=32;
        }
        if (x >= 2**16){
            x>>=16;
            r+=16;
        }
        if (x >= 2**8){
            x>>=8;
            r+=8;
        }
        if (x >= 2**4){
            x>>=4;
            r+=4;
        }
        if (x >= 2**2){
            x>>=2;
            r+=2;
        }
        if (x >= 2**1){
            x>>=1;
            r+=1;
        }
    }

}

