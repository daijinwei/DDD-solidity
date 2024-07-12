// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalInfoViewer {
    // 查看全局信息的函数
    function viewGlobalInfo() external view returns (address, uint, uint) {
        // 调用合约者的地址
        address sender = msg.sender;
        // 时间戳
        uint timestamp = block.timestamp;
        // 块的高度
        uint blockNum = block.number;
    return (sender, timestamp, blockNum);
    }
}
