// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract1{
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, "Not owner");
        owner = _owner;
    }

}

contract Contract2{
    address public owner = msg.sender;
    uint256 value = msg.value;
    uint256 x;
    uint256 y;

    constructor(uint256 _x, uint256 _y) payable{
        x = _x;
        y = _y;
    }
}

contract Proxy{
    event Deploy(address);

    function deploy(bytes memory _code) 
        external 
        payable 
        returns(address addr){
            // 汇编函数
            assembly{
               addr := create(callvalue(), add(_code, 0x20), mload(_code))
            }
            // 如果部署成功，不是非零地址
            require(addr != address(0), "Deploy failed");
            // 部署成功后，发送事件信息
            emit Deploy(addr);
    }
}


contract Helper{
    function getContract1()external pure returns(bytes memory){
        bytes memory bytecode = type(Contract1).creationCode;
        return bytecode;
    }

    function getContract2(uint256 _x, uint256 _y)external pure returns(bytes memory){
        bytes memory bytecode = type(Contract1).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_x, _y));
    }

    function getCallData(address _owner)external pure returns(bytes memory){
        return abi.encodeWithSignature("setOwner(address)", _owner);
    }
}
