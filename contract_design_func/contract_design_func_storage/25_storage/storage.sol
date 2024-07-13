// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
在 Solidity 中，`storage`、`memory` 和 `calldata` 是用于定义数据存储位置的关键字。它们之间的主要区别如下：

### 1. Storage
- **位置**：合约的永久存储。
- **特点**：存储在区块链上，数据在合约生命周期内持久存在。
- **费用**：读写操作会消耗较高的 Gas，因为它涉及到区块链的持久性存储。
- **用途**：用于定义合约状态变量。

### 2. Memory
- **位置**：合约的临时存储。
- **特点**：数据仅在函数调用期间存在，调用结束后会被销毁。
- **费用**：读写操作消耗的 Gas 较少，适合用于短期数据存储。
- **用途**：用于临时变量、函数参数等。

### 3. Calldata
- **位置**：只读数据存储区域。
- **特点**：数据来自外部调用，不能被修改，存在于函数调用期间。
- **费用**：更低的 Gas 费用，因为数据不需要复制到内存。
- **用途**：通常用于函数参数，尤其是大型数组和结构体，以避免复制开销。

### 总结
- **Storage**：持久、昂贵，适用于状态变量。
- **Memory**：临时、便宜，适用于函数内变量。
- **Calldata**：只读、最便宜，适用于外部函数参数。

选择合适的存储位置可以优化合约的效率和成本。

*/
// Storage memory calldata

contract StorageContract{
    struct MyStruct {
        string text;
        uint[] nums;
    }

    MyStruct public my_struct;
    constructor(string memory _text, uint[] memory _nums){
        my_struct = MyStruct(_text, _nums);
    }

    function updateText(string memory _text)external {
        my_struct.text = _text;
    }

    function readonly(uint[] calldata numbers) external pure returns(uint[]memory ){
        return numbers; 
    }
}
