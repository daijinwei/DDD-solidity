// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. 编写一个Solidity合约，使用Create2部署一个新的合约。
2. 在部署前，预计算新合约的地址。
3. 部署新合约后，比较预计算的地址和实际部署的地址。

提示
1. 使用`create2`和`keccak256`计算哈希值。
2. 使用`emit`关键字输出合约地址。
*/

contract DepoyWithCreate{
    address public owner;
    constructor(address _owner){
        owner = _owner;
    }
}

contract DeployWithFactory{
    event Deploy(address);

    // 部署合约, 部署是，加盐
    function deploy(uint _salt) external {
        // 小括号前加大括号，并使用salt方式部署，就是create2方式部署合约
        DepoyWithCreate _contract = new DepoyWithCreate{
            salt: bytes32(_salt)}(msg.sender);

        // 提交合约的事件，address()获取合约的地址，事件中的日志可以获取合约地址
        emit Deploy(address(_contract));
    }

    // 获取合约的地址
    function getAddress(bytes memory bytecode, uint _salt) external view returns(address){
        // bytes1(0xff)：Solidity 中用于表示 create2 的字节前缀。
        // address(this)：当前合约的地址，作为 create2 的发起者。
        // _salt：一个随机数或者唯一标识符，用于确保不同的合约实例有不同的地址。
        // keccak256(bytecode)：合约的字节码的 Keccak-256 哈希值，作为部署合约的标识。
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));

        // hash 是32字节，32*8=256位
        // 20/32 = 0.625
        // 160/256 = 0.625
        // 取hash的后20 bytes，即合约地址
        return address(uint160(uint256(hash)));
    }

    // 合约的字节码
    function getByteCode(address owner)external pure returns(bytes memory){
        bytes memory bytecode = type(DepoyWithCreate).creationCode;
        return abi.encodePacked(bytecode, abi.encode(owner));
    }
}
