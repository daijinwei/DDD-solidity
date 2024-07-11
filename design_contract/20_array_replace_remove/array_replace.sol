// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayReplace{
    // 创建动态数组 并且初始化
    uint[] public nums;

    // remove
    function removeRepace(uint index) public {
        require(index < nums.length, "out of bond");
        nums[index] =  nums[nums.length -1];
        nums.pop();
    }

    function test()external {
        nums = [1,2,3];
        removeRepace(0);
        assert(nums.length == 2);
        assert(nums[0] == 3);
        assert(nums[1] == 2);
    }
}
