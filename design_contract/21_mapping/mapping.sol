// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank{
    mapping(address => uint) public balances;

    // 为自己的账户存款
    function deposit(uint x)external{
        balances[msg.sender] = x;
    }

    function withdraw(uint amount) external{
        balances[msg.sender] -= amount;
    }
    // 返回余额度
    function checkBalance()external view returns (uint) {
        return balances[msg.sender];
    }
}
