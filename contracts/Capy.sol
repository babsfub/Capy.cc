// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CAPY is ERC20 {
    address public owner;
    uint256 public referralFee = 3;
    uint256 public noReferralFee = 6;
    mapping(address => bool) public referralCodes;
    address public feeRecipient;
    IERC4626 public rewardPool;

    constructor(address _feeRecipient, address _rewardPool) ERC20("Capycoin", "CAPY") {
        owner = msg.sender;
        feeRecipient = _feeRecipient;
        rewardPool = IERC4626(_rewardPool);
        uint256 totalSupply = 100000000 * (10 ** uint256(decimals()));
        uint256 ownerShare = totalSupply * 10 / 100;
        _mint(owner, ownerShare);
        _mint(_rewardPool, totalSupply - (ownerShare * 2));
    }

    function buyTokenWithReferral(address referrer) external payable {
        require(referralCodes[referrer], "Invalid referral code");
        uint256 fee = msg.value * referralFee / 100;
        uint256 amountToBuy = msg.value - fee;
        _mint(msg.sender, amountToBuy);
        payable(feeRecipient).transfer(fee);
        rewardPool.deposit(fee);
    }

    function buyTokenWithoutReferral() external payable {
        uint256 fee = msg.value * noReferralFee / 100;
        uint256 amountToBuy = msg.value - fee;
        _mint(msg.sender, amountToBuy);
        payable(feeRecipient).transfer(fee);
        rewardPool.deposit(fee);
    }

    function setReferralCode(address referrer, bool status) external {
        require(msg.sender == owner, "Only owner can set referral codes");
        referralCodes[referrer] = status;
    }
}

interface IERC4626 {
    function deposit(uint256 amount) external;
}
