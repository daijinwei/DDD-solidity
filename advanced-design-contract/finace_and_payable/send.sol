// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编写一个Solidity智能合约，包含以下功能：

1. 能够接收ETH（使用`receive`函数）。
2. 能够使用`transfer`方法发送ETH。
3. 能够使用`send`方法发送ETH并处理失败情况。
4. 能够使用`call`方法发送ETH并处理返回值。
*/

contract SendEth{
    event Log(uint amount, uint gas);

    // 发送时如果没有数据，调用此函数
    receive()external payable{
        emit Log(msg.value, 0);
    }

    function sendByTransfer(address payable _to, uint _amount)public{
        uint256 gasStart = gasleft(); // 获取调用开始时剩余的 gas
        _to.transfer(_amount);
        uint256 gasEnd = gasleft(); // 获取调用结束时剩余的 gas
        uint256 gasUsed = gasStart - gasEnd; // 计算消耗的 gas
        emit Log(_amount, gasUsed);
    }

    // sent 返回bool
    function sendBySend(address payable _to, uint _amount)public returns(bool){
        uint256 gasStart = gasleft(); // 获取调用开始时剩余的 gas
        bool sent = _to.send(_amount);
        uint256 gasEnd = gasleft(); // 获取调用结束时剩余的 gas
        uint256 gasUsed = gasStart - gasEnd; // 计算消耗的 gas
        require(sent, "Send failed");
        emit Log(_amount, gasUsed);
        return sent;
    }


    // call 返回值为2个
    function sendByCall(address payable _to, uint _amount)public returns(bool){
        uint256 gasStart = gasleft(); // 获取调用开始时剩余的 gas
        (bool success, ) = _to.call{value: _amount}("");
        uint256 gasEnd = gasleft(); // 获取调用结束时剩余的 gas
        uint256 gasUsed = gasStart - gasEnd; // 计算消耗的 gas
        require(success, "Send failed");
        emit Log(_amount, gasUsed);
        return success;
    }
}

contract ReceiveEth{
    event Log(uint amount, uint gas);
    // 接收ETH
    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance; // 返回合约当前的以太币余额
    }
}
