// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

interface IBlast {
    function claimAllYield(address token, address recipient) external;
}

contract CAPYVault is ERC4626, Ownable, ReentrancyGuard {
    using SafeERC20 for ERC20;
    using Math for uint256;
    using Address for address payable;
    
    IBlast private blast = IBlast(0x4300000000000000000000000000000000000002);
    uint256 private lastYieldClaimTime;
    uint256 private constant DAY_IN_SECONDS = 86400;
   
    

    uint256 private constant BASIS_POINT_SCALE = 1e4;
    uint256 private entryFeeBasisPoints;
    uint256 private exitFeeBasisPoints;
    uint256 private devFeeBasisPoints;
    uint256 public constant WITHDRAWAL_INTERVAL = 1 weeks;
    uint256 public constant MAX_WITHDRAWAL_PERCENT = 5;

    address public devAddress;

    mapping(address => uint256) public lastWithdrawalTime;
    mapping(address => uint256) public shareHolder;

    event Deposit(address indexed depositor, uint256 amount, uint256 fee);
    event Withdraw(address indexed receiver, uint256 amount, uint256 fee);
    event YieldClaimed(uint256 amount);

    enum Rounding { Up, Down }
    

     constructor( ERC20 _asset , string memory _name, string memory _symbol, address _devAddress )
        ERC4626(_asset)
        ERC20(_name, _symbol)
        Ownable(msg.sender)
        ReentrancyGuard()
    {
        // Initialisation des variables
        entryFeeBasisPoints = 4; 
        exitFeeBasisPoints = 5; 
        devFeeBasisPoints = 1;
        devAddress = _devAddress;
        

    }

    function claimYieldToVault() internal {
        uint256 currentTime = block.timestamp;
        if (currentTime - lastYieldClaimTime > DAY_IN_SECONDS) {
            blast.claimAllYield(address(this), address(this));
            emit YieldClaimed(address(this).balance); 
            lastYieldClaimTime = currentTime;
        }
    }

      function calculateFee(uint256 assets, uint256 feeBasisPoints, Rounding rounding) private pure returns (uint256) {
        uint256 fee = (assets * feeBasisPoints) / BASIS_POINT_SCALE;
        if (rounding == Rounding.Up && (assets * feeBasisPoints % BASIS_POINT_SCALE) > 0) {
            fee += 1; 
        }
        return fee;
    }

    function deposit(uint256 _assets) public nonReentrant {
        require(_assets > 0, "Deposit amount should be greater than zero");
        uint256 fee = _feeOnTotal(_assets, entryFeeBasisPoints);
        uint256 shares = previewDeposit(_assets - fee);
        super.deposit(_assets - fee, msg.sender);
        shareHolder[msg.sender] += shares;
        emit Deposit(msg.sender, _assets, fee);
    }

    function withdraw(uint256 _shares, address _receiver) public nonReentrant {
        require(_shares > 0, "Withdraw amount should be greater than zero");
        require(_receiver != address(0), "Receiver cannot be zero address");
        require(shareHolder[msg.sender] >= _shares, "Insufficient shares");
        require(block.timestamp >= lastWithdrawalTime[msg.sender] + WITHDRAWAL_INTERVAL, "Withdrawal interval not met");

        uint256 maxShares = (shareHolder[msg.sender] * MAX_WITHDRAWAL_PERCENT) / 100;
        require(_shares <= maxShares, "Withdrawal exceeds limit");

        claimYieldToVault(); 

        uint256 assets = previewWithdraw(_shares);
        uint256 devFee = _feeOnRaw(assets, devFeeBasisPoints); 
        uint256 fee = _feeOnRaw(assets, exitFeeBasisPoints) + devFee;
        super.withdraw(assets - fee, _receiver, msg.sender);

        payable(devAddress).transfer(devFee);

        shareHolder[msg.sender] -= _shares;
        lastWithdrawalTime[msg.sender] = block.timestamp;
        emit Withdraw(_receiver, assets, fee);
    }

    function _feeOnRaw(uint256 assets, uint256 feeBasisPoints) private pure returns (uint256) {
        return assets.mulDiv(feeBasisPoints, BASIS_POINT_SCALE);
    }

    function _feeOnTotal(uint256 assets, uint256 feeBasisPoints) private pure returns (uint256) {
        return assets.mulDiv(feeBasisPoints, feeBasisPoints + BASIS_POINT_SCALE);
    }

}
