// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayShift{
    // 创建动态数组 并且初始化
    uint[] public nums = [1,2,3];

    // remove
    function remove(uint index) public {
        require(index < nums.length, "out of bond");
        for(uint i = index; i < nums.length -1 ; i++){
            nums[i] = nums[i+1];
        }
        nums.pop();
    }

    function test()external {
        remove(0);
        assert(nums.length == 2);
        remove(0);
        assert(nums.length == 1);
        remove(0);
        assert(nums.length == 0);
    }
}
