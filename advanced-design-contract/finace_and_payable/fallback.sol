// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编写一个包含Fallback和Receive函数的Solidity合约，并测试其行为。

要求：
1. 定义一个可以接收Ether的合约，包含Fallback和Receive函数。
2. Fallback函数应记录调用者地址、发送的金额和数据。
3. Receive函数应记录调用者地址和发送的金额。
4. 部署合约并测试：
发送带数据的Ether，验证Fallback函数被调用。
发送不带数据的Ether，验证Receive函数被调用。
删除Receive函数，再次发送不带数据的Ether，验证Fallback函数被调用。
*/

contract FallbackExample{
    event Log(string functionCalled, address sender, uint amount, bytes data);

    // msg.sender 调用合约的address, msg.value 接收到的以太
    // fallback 发送时存在数据，直接调用fallback
    fallback()external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    // 发送时如果没有数据，调用此函数
    receive()external payable{
        emit Log("receive", msg.sender, msg.value, "");
    }
}
