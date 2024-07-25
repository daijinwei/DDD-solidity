// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. `encodeData` 函数：
- 接收以下参数：`uint x`, `address addr`, `uint[] memory r`, `MyStruct memory myStruct`
- 使用`abi.encode`对这些参数进行编码并返回字节数据
2. `decodeData` 函数：
- 接收一个字节数组参数：`bytes memory data`
- 使用`abi.decode`对字节数据进行解码，返回解码后的各个数据
*/

contract EncodeDecode{
    struct MyStruct {
        string name;
        uint[2] numbers;
    }

    function encode(
            uint x, 
            address addr, 
            uint[] calldata arr, 
            MyStruct calldata mystruct
        )external pure returns(bytes memory){
        return abi.encode(x, addr, arr, mystruct);
    }

    // 
    function decode(bytes calldata datas)external pure returns(uint x, address addr, uint[]memory arr,  MyStruct memory mystruct) {
        (x, addr, arr, mystruct) = abi.decode(datas, (uint, address, uint[], MyStruct));
    }
}
