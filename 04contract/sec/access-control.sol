// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
编程作业

作业说明

实现一个简化版本的访问控制合约，包含以下功能：

1. 定义两个角色：`admin`和`user`
2. 实现分配和撤销角色的函数
3. 为合约部署者分配`admin`角色

### 作业代码示例

```
solidity
作业要求

1. 仿照示例代码，实现基本访问控制功能
2. 编写测试用例，验证角色分配和撤销功能
3. 提交合约代码和测试结果

*/


// role => account => bool
contract AccessControllerExample{
    // 维护一个mapping表
    mapping(bytes32 => mapping(address => bool)) public roles;

    // 赋予角色事件
    event GrantRole(bytes32, address);

    // 取消角色事件
    event RevokeRole(bytes32, address);

    // 装饰器
    modifier onlyRead(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized!");
        _;
    }

    // 定义admin，user角色
    // 修改为public后，后去ADMIN的值 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ADMIN =  keccak256(abi.encodePacked("ADMIN"));
    // 修改为public后，后去USER的值 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant USER =  keccak256(abi.encodePacked("USER"));

    constructor (){
        _grant_role(ADMIN, msg.sender);
    }

    function _grant_role(bytes32 role, address account) internal {
        roles[role][account] = true;
        emit GrantRole(role, account);
    }

    function grant_role(bytes32 role, address account) external onlyRead(ADMIN) {
        _grant_role(role, account);
    }

    // 取消角色
    function revoke_role(bytes32 role, address account) external onlyRead(ADMIN) {
        roles[role][account] = false;
        emit RevokeRole(role, account);
    }
}
