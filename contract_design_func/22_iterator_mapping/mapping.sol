// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank2{
    mapping(address => uint) public balances;
    mapping(address => bool) public inserted;
    address[] public keys;

    // 添加余额
    function set(address _key, uint _val)public {
        balances[_key] = _val;
        if(!inserted[_key]){
            inserted[_key] = true;
        }
        keys.push(_key);
    }

    // 返回keys数组的长度
    function getSize()public view returns(uint ){
        return keys.length;
    }

    // 根据索引获余额
    function getBalancesByIndex(uint index)external view returns(uint){
        return balances[keys[index]];
    }

    function test() external {
        set(msg.sender, 100);
        assert(inserted[msg.sender] == true);
    }
}
