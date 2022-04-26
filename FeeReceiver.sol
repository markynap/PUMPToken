//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./IERC20.sol";

interface IOwnedContract {
    function getOwner() external view returns (address);
}

interface IXUSD {
    function burn(uint amount) external;
}

contract BuyReceiver {

    // Token
    address public immutable token;

    // XUSD Token
    address public constant XUSD = 0x324E8E649A6A3dF817F97CdDBED2b746b62553dD;

    // Recipients Of Fees
    address public treasury = 25;
    address public multisig = 15;
    address public rewardLocker = 50;

    // Fee Percentages
    uint256 public treasuryPercent;
    uint256 public rewardLockerPercent;
    uint256 public multisigPercent;

    // Token -> BNB
    address[] path;

    // router
    IUniswapV2Router02 router;

    // Events
    event Approved(address caller, bool isApproved);

    modifier onlyOwner(){
        require(
            msg.sender == IOwnedContract(token).getOwner(),
            'Only Token Owner'
        );
        _;
    }

    constructor(address token_, address router_) {
        require(
            token_ != address(0),
            'Zero Address'
        );

        // Initialize Token
        token = token_;

        // Initialize Router
        router = IUniswapV2Router02(router_);

        // set initial approved
        approved[msg.sender] = true;
    }

    function trigger() external {

        // Token Balance In Contract
        uint balance = IERC20(token).balanceOf(address(this));
        
        // sell Token in contract for BNB
        if (balance > 0) {
            IERC20(token).approve(address(router), balance);
            router.swapExactTokensForETHSupportingFeeOnTransferTokens(balance, 0, path, address(this), block.timestamp + 300);
        }

        if (address(this).balance > 0) {
            // fraction out bnb received
            uint part1 = address(this).balance * treasuryPercent / 100;
            uint part2 = address(this).balance * multisigPercent / 100;
            uint part3 = address(this).balance * rewardLockerPercent / 100;

            // send to destinations
            _send(treasury, part1);
            _send(multisig, part2);
            _send(rewardLocker, part3);
            _send(XUSD, address(this).balance);
            IXUSD(XUSD).burn(IERC20(XUSD).balanceOf(address(this)));
        }
    }

    function liquidateToken(address token_) external {
        require(
            token != token_, 'Call trigger() for this'
        );
        address[] memory swapPath = new address[](2);
        swapPath[0] = token_;
        swapPath[1] = router.WETH();
        IERC20(token_).approve(address(router), balance);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(balance, 0, swapPath, address(this), block.timestamp + 300);
        delete swapPath;
    }

    function updateFeePercentages(uint reward_, uint treasury_, uint multisig_) external onlyOwner {
        require(
            reward + treasury_ + multisig_ < 100, 'Invalid Fees'
        );
        treasuryPercent = treasury_;
        rewardLockerPercent = reward_;
        multisigPercent = multisig_;
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
   
    function setApproved(address caller, bool isApproved) external onlyOwner {
        approved[caller] = isApproved;
        emit Approved(caller, isApproved);
    }
    
    function setMinTriggerAmount(uint256 minTriggerAmount) external onlyOwner {
        minimumTokensRequiredToTrigger = minTriggerAmount;
    }
    
    function setTrustFundPercentage(uint256 newAllocatiton) external onlyOwner {
        trustFundPercentage = newAllocatiton;
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
}