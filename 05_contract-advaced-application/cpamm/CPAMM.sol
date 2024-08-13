    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    /*
    恒乘积自动市场制造商（Constant Product Automated Market Maker，简称CPAMM）是一种常见的去中心化交易所（DEX）市场制造商模型，最著名的实现是Uniswap。它的主要思想是使用一个数学公式来决定资产的价格，并确保交易的流动性。

    核心思想
    CPAMM的核心思想是维护一个恒定的乘积，即资产对的乘积总是保持不变。具体来说，对于一个由两个资产（如代币A和代币B）组成的交易池，公式如下：
    x×y=k
    其中：
    x 是代币A的数量
    y 是代币B的数量
    k 是一个常数，表示池中代币A和代币B数量的乘积

    交易过程
    加入流动性：
    流动性提供者（LP）向池中注入代币A和代币B，保持 x×y=k 不变。例如，假设初始的 𝑘 是 1000，当代币A的数量变成 𝑥1时，代币B的数量必须变成 𝑦1以保持 𝑥1×𝑦1=𝑘x。

    交易：
    交易者从池中购买或出售代币。在这个过程中，代币A和代币B的数量都会发生变化。假设一个交易者想要用代币A购买代币B，那么代币A的数量增加，代币B的数量减少。为了保持恒乘积 𝑘k 不变，代币B的单价会增加。
    */


    /*
使用方法：
1. 先部署erc20.sol合约。部署两次，分别为作为tokenA，tokenB；
2. 找到tokenA，tokenB的合约地址，再部署CPAMM合约；
3. 找到CPAMM合约地址，在tokenA和tokenB合约中分别approve CPAMM合约地址能trasfer的数额；
4. CPAMM合约中，添加流动性addLiquidity;
5. 调用swap函数
*/


    import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

    contract CPAMM{
        // Interfaces for the ERC20 tokens
        IERC20 public tokenA;
        IERC20 public tokenB;

        // Reserves for the tokens in the pool
        uint256 public reserveA;
        uint256 public reserveB;

        uint public totalSupply;
        mapping(address => uint) public balanceOf;

        // Fee rate is 0.3% 费率
        uint256 private constant FEE_DENOMINATOR = 10000;
        uint256 public fee = 30;

        // 份额
        uint256 public shared = 0;

        constructor(address _tokenA, address _tokenB){
            tokenA = IERC20(_tokenA);
            tokenB = IERC20(_tokenB);
        }
        
        function _mint(address _to, uint amounts) private {
            balanceOf[_to] += amounts;
            totalSupply += amounts;
        }

        function _burst(address _to, uint amounts) private {
            balanceOf[_to] -= amounts;
            totalSupply -= amounts;
        }

        function _update(uint _reserveA, uint _reserveB) private {
            reserveA = _reserveA;
            reserveB = _reserveB;
        }

        // 指定的用户 交易的数额
        function swap(address inputToken, uint256 amountIn)external returns(uint256 amountOut) {
            require(amountIn > 0, "Invalid amount");

            // transfer tokenin 确定交换进来的token
            bool isTokenA = inputToken == address(tokenA);
            // 定义tonken输入，输出
            (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn,uint reserveOut) = isTokenA? (tokenA, tokenB, reserveA, reserveB) :(tokenB, tokenB, reserveB, reserveA);
        
            // 转入token tokenIn
            tokenIn.transferFrom(msg.sender, address(this), amountIn);

            // calc tokenout 包括手续费, 0.3%手续费
            // 计算公式：y*dx/(x+dx) = dy， dx 输入，dy输出，x已有的tokenA，y已有的tokenB
            uint amountInWithFee = amountIn*(FEE_DENOMINATOR - fee) / FEE_DENOMINATOR;
            amountOut = reserveOut * amountInWithFee/(reserveIn + amountInWithFee);

            tokenOut.transfer(msg.sender, amountOut);
        
            // update reserve
            _update(tokenA.balanceOf(address(this)), tokenB.balanceOf(address(this)));
        }

        // 注入流动性
        function addLiquidity(uint256 amountA, uint256 amountB) external {
            tokenA.transferFrom(msg.sender, address(this), amountA);
            tokenB.transferFrom(msg.sender, address(this), amountB);

            if(shared == 0){
                shared = sqrt(amountA*amountB);
            } else {
                shared = min(amountA*totalSupply/reserveA, amountB*totalSupply/reserveB);
            }

            _mint(msg.sender, shared);
            _update(tokenA.balanceOf(address(this)),
                tokenB.balanceOf(address(this))
            );

        }
        // 完全平方根函数，计算不大于 x 的最大整数平方根
        function sqrt(uint256 x) internal pure returns (uint256) {
            if (x == 0) return 0;
            
            uint256 z = (x + 1) / 2;
            uint256 y = x;
            
            while (z < y) {
                y = z;
                z = (x / z + z) / 2;
            }
            
            return y;
        }

        // 计算两个数中的最小值
        function min(uint256 a, uint256 b) internal pure returns (uint256) {
            return a < b ? a : b;
        }
    }
