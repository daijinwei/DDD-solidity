// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. 给定message
2. 计算message的hash值, hash(message)
3. 手动去签名 sigin
4. 调用verify函数验签 verify
*/
contract Verifyontract{
    // 验证签名
    function  verify(address signer, string memory message, bytes memory sig) external pure returns(bool){
        // message hash值
        bytes32 hash_message = getHashMessage(message);
        bytes32 signed_hash_message = getSignedHashMessage(hash_message);
        // 签名摘要信息计算
        return recove(signed_hash_message, sig) == signer;
    }

    // 计算message的hash值
    function getHashMessage(string memory message) public pure returns(bytes32){
        return keccak256(abi.encodePacked(message));
    }

    // 计算签名信息
    function getSignedHashMessage(bytes32 hashMessage)public pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hashMessage));
    }

    // ecrecover 是以太坊（Ethereum）智能合约中的一个函数，用于从数字签名中恢复签名者的公钥。
    // 在区块链中，数字签名通常用于验证交易的来源和完整性。
    // ecrecover 函数可以从签名数据中提取出签名者的公钥，进而验证签名的有效性或者获取签名者的地址信息。
    function recove(bytes32 hashMessage, bytes memory sig)public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = split(sig);
        return ecrecover(hashMessage, v, r, s);
    }

    function split(bytes memory sig)internal pure returns(bytes32 r, bytes32 s, uint8 v){
        require(sig.length == 65, "Invalid sig length");
        assembly{
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
