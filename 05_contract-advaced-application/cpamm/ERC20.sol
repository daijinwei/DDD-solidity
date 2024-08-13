// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
实现一个简单的ERC20代币合约，包含以下功能：

1. 定义代币的名称、符号和小数位数。
2. 实现转移功能。
3. 实现授权功能及其查询。
4. 实现代币的增发和销毁功能。
*/

// ERC20 标准接口
interface IERC20 {
    // totalSupply: 代币的总供应量，初始化时在构造函数中设定。
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20Token is IERC20 {
    // 代币的名称
    string public name = "Daijinwei ERC20 Token";
    // 定义代币的符号;
    string public symbol = "MET";
    // 定义代币的小数位数。
    uint8 public decimals = 18;
    
    // 代币发行的总量
    uint256 public totalSupply;

    // 每个账户的代币余额
    mapping(address => uint256) public balanceOf;

    // allowance: 存储每个地址允许被另一个地址转移的代币数量。
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    // transfer: 将代币从合约调用者的账户转移到指定地址。
    function transfer(address recipient, uint256 amount) external returns (bool){
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function TotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    // approve: 允许某个地址通过 transferFrom 函数来转移不超过指定数量的代币。
    function approve(address spender, uint256 amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // transferFrom: 由授权的地址调用，从 _from 地址转移代币到 _to 地址。
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not enough allowance");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
