// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
1. 定义接口 `ICounter`，包含以下函数：
- `function count() external view returns (uint);`
- `function increment() external;`
2. 编写合约 `CallCounter`，包含以下功能：
- 定义状态变量 `uint public count;`
- 定义函数 `incrementCounter` 调用 `ICounter.increment` 函数
- 定义函数 `updateCount` 调用 `ICounter.count` 函数，并更新状态变量 `count`
3. 部署 `CallCounter` 合约后，通过传入已部署的计数器合约地址，调用 `incrementCounter` 和 `updateCount` 函数，实现计数器的增加和获取当前计数值的功能。
学员需完成合约编写、部署和测试，确保合约功能正常运行。
*/

interface Icouter{
    function count() external view returns (uint);
    function increment() external;
}

contract CallCoutner{
    function incrementCounter(address _count) external{
        Icouter(_count).increment();
    }

    function getCount(address _count) external view returns (uint){
        return Icouter(_count).count();
    }
}
