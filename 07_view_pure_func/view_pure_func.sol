// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ViewAndPureFunc{
    uint public storedData;
    // view func: 读取链上区块链上的数据, 另外，view不能写，修改状态变量
    function getStoredData() public view returns (uint){
        return storedData + 1;
    }
    // public func: 不读取链上区块链上的数据，以及不读取全局变量,另外，pure不能写，修改状态变量
    function getValue() public pure returns (uint){
        return 1;
    }
}
