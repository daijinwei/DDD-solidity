// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



/*
unchecked 节省gas

1. 创建一个Solidity智能合约，包含两个函数：`add`和`subtract`。
2. 使用`unchecked`块禁用这两个函数的溢出和下溢检查。
3. 部署合约并调用这两个函数，记录Gas费用。
4. 移除`unchecked`块，再次部署合约并调用这两个函数，记录Gas费用。
5. 比较启用和禁用检查时的Gas费用。

*/

contract UncheckedContract{
    /*
    solidity: 会自动进行上溢检查
    */
    function add(uint256 x, uint256 y)external pure returns(uint256){
        // gas: 358
        return x+y;

        // gas: 259
        //unchecked{
        //    return x+y;  
        //}
    }

    function sub(uint256 x, uint256 y)external pure returns(uint256){
        // gas: 380
        return x-y;

        // gas:284
        // unchecked{
        //    return x-y;  
        //}
    }
}
