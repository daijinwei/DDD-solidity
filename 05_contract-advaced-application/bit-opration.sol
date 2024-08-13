// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
掩码创建：

(1 << n) - 1 用于生成一个掩码。1 << n 计算 2^n，即一个有 n 个 0 的位数，其中最高位是 1。减去 1 会将所有的 n 位设置为 1。
例如，如果 n = 3，则 1 << 3 结果是 1000（二进制），减去 1 得到 111（二进制），即 7（十进制）。
按位与操作：

x & mask 提取 x 的最后 n 位。掩码中的 1 位保留了 x 的相应位，而 0 位则将 x 中对应的位清零。
*/


contract BitManipulation {
    function getLastNBits(uint256 x, uint256 n) public pure returns (uint256) {
        require(n <= 256, "n must be less than or equal to 256"); // n 应小于等于 256
        
        // 创建一个 n 个 1 位的掩码
        uint256 mask = (1 << n) - 1;
        
        // 提取最后 n 位
        return x & mask;
    }
}

