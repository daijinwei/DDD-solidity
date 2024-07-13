// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. **合约初始化和调用**
- 创建一个合约 `MyCallerContract`，用于调用目标合约 `MyTargetContract`。
- 在 `MyCallerContract` 中编写一个函数 `setTargetX`，调用 `MyTargetContract` 的 `setX` 函数，并传递参数。
2. **直接调用**
- 在 `MyCallerContract` 中编写一个函数 `getTargetX`，直接调用 `MyTargetContract` 的 `getX` 函数，并返回结果。
3. **传递Ether**
- 在 `MyCallerContract` 中编写一个函数 `setXWithEther`，调用 `MyTargetContract` 的 `setXAndReceiveEther` 函数，并传递Ether值。
4. **处理多个返回值**
- 在 `MyCallerContract` 中编写一个函数 `getXAndValueFromTarget`，调用 `MyTargetContract` 的 `getXAndValue` 函数，并返回多个输出值。
*/

contract MyCallerContract{
    function setX(MyTargetContract _test, uint256 _x)external {
        _test.setX(_x);
    }

    function getX(MyTargetContract _test)external  view returns(uint256) {
        return _test.getX();
    }

    function setXAndReceiveEther(MyTargetContract _test,uint256 _x)external {
        return _test.setXAndReceiveEther(_x);
    }

    function getXAndValue(MyTargetContract _test)public view returns(uint256, uint256){
        return _test.getXAndValue();
    }
}


contract MyTargetContract{
    uint256 public x;
    uint256 public value = 123;
    function setX(uint256 _x)public returns(uint256) {
        x = _x;
        return x;
    }

    function getX()public view returns(uint256) {
        return x;
    }

    function setXAndReceiveEther(uint256 _x)public payable{
        x = _x;
        value = msg.value;
    }

    function getXAndValue()public view returns(uint256, uint256){
        return (x, value);
    }
}

