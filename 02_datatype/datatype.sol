// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DataType {
    uint public u = 256;
    int public i = 128;
    bool public s = true;


    // bool 值
    bool public _bool = true;
    // bool 运算
    bool public _bool1 = !_bool;    // 非
    bool public _bool2 = _bool && _bool2; //  与运算
    bool public _bool3 = _bool || _bool1; //  或运算
    bool public _bool4 = _bool == _bool2; //  与运算
    bool public _bool5 = _bool != _bool1; //  或运算

    // 整数
    int public _int = 1;
    uint public _uint = 11;
    uint256 public _int256 = 256;
    // 整数运算
    uint256 public _number1 = _int256 + 1;  // 加法
    uint256 public _number2 = 2;     // 指数
    uint256 public _number3 = 1%_number1;   // 余


    // Address
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;   // 地址
    address payable public _address2 = payable(_address);       // 可转账地址
    // 地址类型成员
    uint256 public member = _address.balance;

    // 固定长度的字节数组
    bytes32 public _byte32 = "Min Solidity";
    bytes1 public _byte1 = _byte32[0];

    // Enum 
    enum ActionSet {Buy, Hold, Sell}
    ActionSet action = ActionSet.Buy;

    // enum可以和uint显式的转换
    function enumToUint() external view returns(uint){  
        return uint(action);        // 显示转换
    }
}
