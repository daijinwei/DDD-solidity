// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编程作业
• 任务: 创建⼀个简单的Solidity合约，实现WETH功能。
• 要求:
a. 编写⼀个合约，包含初始化构造函数和ERC20代币标准必需的参数。
b. 实现⼀个存款函数，使其能接收ETH并铸造相等数量的ERC20代币。
c. 实现⼀个提款函数，允许⽤⼾销毁他们持有的ERC20代币并提取相应的ETH。
d. 在合约中加⼊适当的事件记录存款和提款操作。
• 附加挑战: 添加⼀个回退函数，以处理合约直接接收ETH的情况，并⾃动触发存款功能。
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address, uint amount);
    event WithDraw(address, uint amount);

    constructor() ERC20 ("Wrapped Ether", "WETH"){}

    function deopsit()external payable{
        // erc20的存钱函数
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withDraw(uint _amount)external payable{
        // erc20的存钱函数
        // 先burn，再发送以太，防止重入
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
        emit WithDraw(msg.sender, msg.value);
    }
}
