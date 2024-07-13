// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编写一个简单的以太坊智能合约 EtherWallet，要求如下：

1. 合约可以接收以太币。
2. 只有合约所有者可以提取以太币。
3. 合约中有一个函数可以返回当前存储的以太币余额。
*/

contract WthWallet{
    address payable public owner;
    constructor(){
        owner = payable(msg.sender);
    }

    // 接收eth
    receive()external payable{}

    //提取Eth
    function withDraw(uint _amount)external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(_amount);
    }

    // 获取余额度
    function getBalance()external view returns(uint){
        return msg.sender.balance;
    }
}
