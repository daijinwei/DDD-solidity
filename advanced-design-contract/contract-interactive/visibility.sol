// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*

任务：编写一个Solidity合约，包含所有四种可见性的函数和状态变量，并验证它们的访问权限。
作业目标：
1. 理解不同可见性修饰符的作用。目的：区分private，internal，public，external 可见性
2. 编写并测试合约，确保对各类可见性修饰符有深入理解。
*/

contract Base{
    uint private x = 1;
    uint internal y = 2;
    uint public z = 3;
    event Log(string  msg);
    function funcA() private {
        emit Log("Base.funcA");
    }

    function funcB() internal virtual {
        emit Log("Base.funcB");
    }

    function funcC() public {
        emit Log("Base.funcC");
    }

    function funcD() external {
        emit Log("Base.funcD");
    }

    function funcF() external {
        x + y + z;
        funcA();
        funcB();
        funcC();
        //funcD(); // external 只能在合约外部调用
    }

}

contract Ddrived is Base{
      function call() external {
        y + z;
        // Base.funcA(); // private属性，子合约不能调用
        funcB();        // internal,子合约能调用
        funcC();        // public,子合约能调用
        //funcD();        // external,子合约能调用
      }
}
