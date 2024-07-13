
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Chat {
    // 声明事件
    event LogMessage(address indexed from, address indexed to, string message);

    // 发送消息函数
    function sendMessage(address to, string calldata message) external {
        emit LogMessage(msg.sender, to, message);
    }
}
