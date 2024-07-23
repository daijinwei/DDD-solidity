// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
多签钱包（Multi-signature wallet）是一种特殊类型的加密货币钱包，它与传统的单签名钱包不同，需要多个私钥中的一部分批准才能执行交易。简单来说，它需要多个用户或者多个设备共同参与签名，以确认并完成一笔交易。
多签钱包的主要优势包括增强的安全性和风险管理能力。通过要求多个私钥的授权，多签钱包可以减少单点故障的风险。即使某个私钥被泄露或者设备失效，也不会导致资产的丢失，因为攻击者仍然需要其他私钥的授权才能执行交易。
多签钱包通常用于需要更高安全性和可信度的场景，例如大额资金管理、企业账户、交易所的冷钱包存储等。它们在加密货币社区中被广泛采用，作为提高安全性和降低风险的一种有效方式。
*/


/*
请根据课程内容，编写一个基本的多签名钱包合约。要求：

1. 定义事件`Deposit`、`Submit`、`Approve`、`Execute`和`Revoke`。
2. 定义状态变量`owners`、`isOwner`、`required`、`transactions`和`approve`。
3. 编写构造函数，初始化所有者数组和所需批准数。
4. 实现`receive`函数接收以太币。
5. 编写`submit`函数提交新交易。
6. 实现`approve`函数批准交易。
7. 编写`execute`函数执行交易。
8. 实现`revoke`函数撤销批准。
*/

contract MultiSigWallet { 
    // 定义事件
    event Deposit(address indexed sender, uint value);
    event Submit(uint indexed transactionId, address indexed sender, address indexed to, uint value, bytes data);
    event Approve(uint indexed transactionId, address indexed sender);
    event Execute(uint indexed transactionId, address indexed sender);
    event Revoke(uint indexed transactionId, address indexed sender);

    // 定义交易结构体
    struct Transaction {
        // 交易的接收地址
        address to;
        // 交易金额
        uint value;
        // 交易中的额外数据
        bytes data;
        // 交易是否执行
        bool executed;
        // 同意执行交易的账户
        //mapping(address => bool) approvals;
        // 同意执行交易的账户数
        uint approvalsCount;
    }

    // 保存交易的数组，存在多笔交易
    Transaction[] public transactions;

    // 所有者地址数组
    address[] public owners;

    // 地址到是否是所有者的映射
    mapping(address => bool) public isOwner;

    // 一笔交易所需的最小批准数
    uint public required;

    // onlyOwner 装饰器
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    // 构造函数
    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "owners required");
        require(_required >0 && _required <= _owners.length, "Invalid required number");

        for(uint i=0; i < _owners.length; i++){
            address owner = _owners[i];
            
            // 检查owner的合法性
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "duplicate owner.");   // 重复的owner
            // owner添加到isOwner中
            isOwner[owner] = true;  
            owners.push(owner);
        }
        // 同意一笔交易的最小账户数
        required = _required;
    }

    // recieve 接收以太，单位为wei
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
     }

    // 提交一笔交易
    function submit(address _to, uint _value, bytes memory _data) public onlyOwner{
        // 交易id
        uint transactionId = transactions.length;
            
        transactions.push(Transaction({
                            to: _to,
                            value: _value,
                            data: _data,
                            executed: false,
                            approvalsCount:0}));
            emit Submit(transactionId, msg.sender, _to, _value, _data);
    }

    // 同意这次交易
    function approve(uint _tranctionId) public onlyOwner {
        // 根据TransactionId 获取交易tranchtion
        Transaction storage transaction = transactions[_tranctionId];
        // 检查交易对象的地址是否存在
        require(transaction.to != address(0), "Transaction does't exists");
        // 检查交易是否已经执行
        require(transaction.executed == false, "Transaction executed");

        transaction.approvalsCount +=1;
        emit Approve(_tranctionId, msg.sender);
    }


    // 执行交易
    function execute(uint _tranctionId) public onlyOwner {
        // 根据TransactionId 获取交易tranchtion
        Transaction storage transaction = transactions[_tranctionId];
        // 检查交易对象的地址是否存在
        require(transaction.to != address(0), "Transaction does't exists");
        // 检查交易是否已经执行
        require(transaction.executed == false, "Transaction executed");
        // 检查是否有足够的人同意这笔交易
        require(transaction.approvalsCount >= required, "Not enough approvals");



        // 执行交易
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction execution failed");      
        // 执行交易后的状态 
        transaction.executed = true;
        emit Execute(_tranctionId, msg.sender);
    }

    // 撤销交易
    function revoke(uint _transactionId) public onlyOwner {
        Transaction storage transaction = transactions[_transactionId];
        require(transaction.to != address(0), "Transaction does not exist");
        require(!transaction.executed, "Transaction already executed");
        //require(transaction.approvals[msg.sender], "Approval not granted");

        //transaction.approvals[msg.sender] = false;
        transaction.approvalsCount--;

        emit Revoke(_transactionId, msg.sender);
    }

    // Fallback function to receive ether， 退回以太
    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
