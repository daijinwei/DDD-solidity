// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 数组的创建，push，get，pop，update

// 一个生产环境中的例子
contract Array {
    // 创建动态数组 并且初始化
    uint[] public nums = [1,2,3];

    // 创建固定大小的数组，并且初始化
    uint[3] public numsFixed = [4,5,6];

    // 插入元素
    function insert(uint x)external{
        nums.push(x);
    }

    // 根据索引get元素
    function getNumsByIndex(uint index)external view returns(uint){
        return nums[index];
    }

    // 更新元素
    function updateNumsByIndex(uint index, uint x) external {
        nums[index] = x;
    }


    // 删除置顶索引的元素
    function deleteNumsByIndex(uint index) external {
        delete nums[index];
    }

    // 数组长度
    function getLength() external view returns(uint){
        return  nums.length;
    }

    // 返回数组，不建议，因为返回太多的数组
    function getArray() external view returns(uint[] memory){
        return  nums;
    }
}
