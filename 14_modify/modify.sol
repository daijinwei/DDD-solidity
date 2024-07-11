// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NumberModifier {
    // 定义私有状态变量
    uint private number;

    // Modifier to ensure number is not zero
    modifier nonZero() {
        require(number != 0, "Need number not equal error");
        // 检查完毕后，再继续执行具体的函数
        _;
    }

        // Modifier to ensure number is not zero
    modifier cap(uint x) {
        require(number < x, "x great than 100");
        // 检查完毕后，再继续执行具体的函数
        _;
    }
    // 三明治装饰器
    modifier sanswich(){
        number *= 2;
        _;
        number -= 1;
    }
    function foo() public sanswich {
        number *=10;
    }

    function doubleNumber() public nonZero {
        number *=2;
    }

    function resetNumber() public nonZero{
        // 私有状态变量重置为0
        number=0;
    }

    function settNumber(uint x) public cap(x) {
        // 私有状态变量重置为0
        number=x;
    }

    function gettNumber() external view returns(uint){
        // 私有状态变量重置为0
        return number;
    }
}
