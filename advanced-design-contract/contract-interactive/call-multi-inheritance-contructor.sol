// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. 声明父合约：
编写一个名为 `S` 的合约，包含一个字符串类型的状态变量 `name` 和一个接收 `name` 参数的构造函数。
编写一个名为 `T` 的合约，包含一个字符串类型的状态变量 `text` 和一个接收 `text` 参数的构造函数。
2. 创建继承合约：
编写一个名为 `U` 的合约，继承 `S` 和 `T`。
在 `U` 的构造函数中调用 `S` 和 `T` 的构造函数，并传递相应的参数。
3. 混合构造函数参数：
编写一个名为 `BB` 的合约，继承 `S` 和 `T`。
静态传递 `S` 的构造函数参数，动态传递 `T` 的构造函数参数。
4. 验证初始化顺序：
编写一个名为 `B0` 的合约，先继承 `S` 再继承 `T`，验证构造函数的调用顺序。
编写一个名为 `B2` 的合约，先继承 `T` 再继承 `S`，验证构造函数的调用顺序。
*/

contract S{
    string public name;
    constructor(string memory _name){
        name = _name;
    }
}

contract T{
    string public text;
    constructor(string memory _text){
        text = _text;
    }
}

// 先继承S，再继承T
contract U is S,T {
    constructor(string memory _name, string memory _text) S(_name) T(_text){}
}
