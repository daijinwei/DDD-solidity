// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
任务描述： 请编写一个 Solidity 合约，其中包含一个基础合约和两个继承该基础合约的子合约，再创建一个继承自这两个子合约的合约。在这个合约中：

1. 使用直接调用的方式调用父合约的一个函数。
2. 使用 `super` 关键字调用父合约的另一个函数。

**要求**：

基础合约应包含两个函数，并使用事件记录日志。
子合约应覆盖基础合约中的函数。
复合继承合约应调用子合约中的函数，并演示直接调用和使用 `super` 的区别。

*/

contract Base{
    event  Log(string _msg);
    function foo()public virtual {
        emit Log("Base.foo");
    }

    function bar()public virtual {
        emit Log("Base.bar");
    }
}


contract F is Base{
    function foo()public virtual override {
        emit Log("F.foo");
        // 直接调用父合约函数
        Base.foo();
    }

    function bar()public virtual override{
        emit Log("F.bar");
        // super关键字调用父合约函数
        super.bar();
    }
}

contract G is Base{
    function foo()public virtual override {
        emit Log("G.foo");
        // 直接调用父合约函数
        Base.foo();
    }

    function bar()public virtual override{
        emit Log("G.bar");
        // super关键字调用父合约函数
        super.bar();
    }
}


contract H is F,G {
    function foo()public override(F,G) {
        emit Log("H.foo");
        // 直接调用父合约函数
        F.foo();
    }

    function bar()public override(F,G){
        emit Log("H.bar");
        // super关键字调用父合约函数
        super.bar();
    }
}

