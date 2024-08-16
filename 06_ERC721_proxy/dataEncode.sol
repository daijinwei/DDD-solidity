// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IToken {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract DataEncoder {
    IToken public token;

    constructor(address _tokenAddress) {
        token = IToken(_tokenAddress);
    }

    // 1. Using abi.encodeWithSignature
    function encodeWithSignature(address to, uint256 amount) external pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    // 2. Using abi.encodeWithSelector
    function encodeWithSelector(address to, uint256 amount) external pure returns (bytes memory) {
        return abi.encodeWithSelector(IToken.transfer.selector, to, amount);
    }

    // 3. Using abi.encodeCall
    function encodeCall(address to, uint256 amount) external pure returns (bytes memory) {
        return abi.encodeCall(IToken.transfer, (to, amount));
    }
    
    // Method to decode and call the encoded data
    function callEncodedData(bytes memory data) external returns (bool success, bytes memory result) {
        (success, result) = address(token).call(data);
    }
}

