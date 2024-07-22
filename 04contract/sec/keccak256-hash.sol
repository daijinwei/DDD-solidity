// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编程作业

请根据以下要求完成一个Solidity智能合约：

1. 创建一个名为`MyHash`的合约，其中包含以下功能：
- 函数`hashFunction`：接受字符串`text`、整数`num`和地址`addr`作为参数，返回这些参数的Keccak256哈希值。
- 函数`encodeFunction`：接受两个字符串`text0`和`text1`，使用`abi.encode`编码并返回结果。
- 函数`encodePackedFunction`：接受两个字符串`text0`和`text1`，使用`abi.encodePacked`编码并返回结果。
- 函数`collisionFunction`：接受两个字符串`text0`和`text1`，使用`abi.encodePacked`编码并返回Keccak256哈希值。
2. 编译并部署合约，测试以下功能：
- 调用`hashFunction`函数，验证输入参数的哈希值。
- 调用`encodeFunction`和`encodePackedFunction`，对比编码后的结果。
- 调用`collisionFunction`，验证哈希冲突的发生，并通过添加一个额外的整数参数解决冲突。

*/

contract MyHashExample{
    function hashFunction(string  memory text, uint num, address addr) external pure returns(bytes32){
        return keccak256(abi.encodePacked(text, num, addr));
    }

    function encodeFunction(string  memory text1, string  memory text2)external pure returns (bytes memory) {
        return abi.encode(text1, text2);
    }

    function encodePackedFunction(string  memory text1, string  memory text2)external pure returns (bytes memory) {
        return abi.encodePacked(text1, text2);
    }

    function collisionFunction(string  memory text1, string  memory text2)external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text1, text2));
    }
}
