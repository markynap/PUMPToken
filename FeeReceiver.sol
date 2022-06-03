//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    
    function symbol() external view returns(string memory);
    
    function name() external view returns(string memory);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);
    
    /**
     * @dev Returns the number of decimal places
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IOwnedContract {
    function getOwner() external view returns (address);
}

interface IXUSD {
    function sell(uint256 tokenAmount) external returns (address, uint256);
}

contract FeeReceiver {

    // Token
    address public constant token = 0x91Ebe3E0266B70be6AE41b8944170A27A08E3C2e;
    address public constant XUSD = 0x324E8E649A6A3dF817F97CdDBED2b746b62553dD;

    // Recipients Of Fees
    address public treasury;
    address public multisig;
    address public rewardLocker;

    // Fee Percentages
    uint256 public treasuryPercent = 25;
    uint256 public rewardLockerPercent = 50;
    uint256 public multisigPercent = 25;
    uint256 public bountyPercent = 1;

    // Token -> BNB
    address[] private path;

    // router
    IUniswapV2Router02 public constant router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    modifier onlyOwner(){
        require(
            msg.sender == IOwnedContract(token).getOwner(),
            'Only Token Owner'
        );
        _;
    }

    constructor() {
        path = new address[](2);
        path[0] = token;
        path[1] = XUSD;
    }

    function trigger() external {

        // Token Balance In Contract
        uint balance = IERC20(token).balanceOf(address(this));
        
        // sell Token in contract for BNB
        if (balance > 0) {

            // Bounty Reward For Triggerer
            uint bounty = currentBounty();
            if (bounty > 0) {
                IERC20(token).transfer(msg.sender, bounty);
                balance -= bounty;
            }

            // swap PUMP to XUSD
            IERC20(token).approve(address(router), balance);
            router.swapExactTokensForTokensSupportingFeeOnTransferTokens(balance, 0, path, address(this), block.timestamp + 300);

            // sell XUSD for stable
            (address stable,) = IXUSD(XUSD).sell(IERC20(XUSD).balanceOf(address(this)));

            // swap stable for BNB
            address[] memory stablepath = new address[](2);
            stablepath[0] = stable;
            stablepath[1] = router.WETH();

            // swap stable to BNB
            uint sBalance = IERC20(stable).balanceOf(address(this));
            IERC20(stable).approve(address(router), sBalance);
            router.swapExactTokensForETHSupportingFeeOnTransferTokens(sBalance, 0, stablepath, address(this), block.timestamp + 300);
            
            // delete path to refund gas
            delete stablepath;
        }

        if (address(this).balance > 0) {
            // fraction out bnb received
            uint part1 = address(this).balance * treasuryPercent / 100;
            uint part2 = address(this).balance * multisigPercent / 100;

            // send to destinations
            _send(treasury, part1);
            _send(multisig, part2);
            _send(rewardLocker, address(this).balance);
        }
    }

    function liquidateToken(address token_) external {
        require(
            token != token_, 'Call trigger() for this'
        );
        address[] memory swapPath = new address[](2);
        swapPath[0] = token_;
        swapPath[1] = router.WETH();
        uint balance = IERC20(token_).balanceOf(address(this));
        IERC20(token_).approve(address(router), balance);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(balance, 0, swapPath, address(this), block.timestamp + 300);
        delete swapPath;
    }

    function updateFeePercentages(uint reward_, uint treasury_, uint multisig_) external onlyOwner {
        require(
            reward_ + treasury_ + multisig_ == 100, 'Invalid Fees'
        );
        treasuryPercent = treasury_;
        rewardLockerPercent = reward_;
        multisigPercent = multisig_;
    }

    function setBountyPercent(uint256 bountyPercent_) external onlyOwner {
        require(bountyPercent_ < 100);
        bountyPercent = bountyPercent_;
    }

    function setTreasury(address treasury_) external onlyOwner {
        require(treasury_ != address(0));
        treasury = treasury_;
    }

    function setRewardLocker(address rewardLocker_) external onlyOwner {
        require(rewardLocker_ != address(0));
        rewardLocker = rewardLocker_;
    }
    
    function setMultisig(address multisig_) external onlyOwner {
        require(multisig_ != address(0));
        multisig = multisig_;
    }
    
    function withdraw() external onlyOwner {
        (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
        require(s);
    }
    
    function withdraw(address _token) external onlyOwner {
        IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
    }

    receive() external payable {}
    
    function _send(address recipient, uint amount) internal {
        (bool s,) = payable(recipient).call{value: amount}("");
        require(s);
    }

    function currentBounty() public view returns (uint256) {
        uint balance = IERC20(token).balanceOf(address(this));
        return ((balance * bountyPercent ) / 100);
    }
}
