// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "../Interfaces/IReceiptToken.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract Pool {
    /**
     * Main functions
     */

    /**
     * @notice Used by liquidity providers to deposit stable coins as a liqudity
     */

    /**
     * @notice Borrower can pay 14% APY
     * @notice Depositor can get 12% APY
     * @notice Loan Repayment period for 3 years User selects the interval;
     * @notice Loan repayment can be extended but interest increase by 2% every year for additional three years
     */

    struct UserInfo {
        uint256 depositStartTime;
        bool isLiqiudator;
        uint256 interestAccumulated;
    }

    mapping(address => UserInfo) internal userInfo;
    IReceiptToken internal receiptToken;
    address internal underlying;

    event AssetDeposited(address from, uint256 amount);

    modifier checkAddress(address _address) {
        require(_address != address(0), "Invalid address");
        _;
    }

    constructor(address _receiptTokenAddress, address _underlying) {
        receiptToken = IReceiptToken(_receiptTokenAddress);
        underlying = _underlying;
    }

    /**
     * @notice Used to deposit Assets to the pool and get rewards
     * Everytime user deposited The initail balance interest calculated and stored.
     */
    function deposit(uint256 amount, address from) external checkAddress(from) {
        require(IERC20(underlying).transferFrom(from, address(this), amount), "Transfer failed");
        if (userInfo[from].isLiqiudator) {
            uint256 _accumulatedInterest = calculateInterest();
            UserInfo storage _userInfo = userInfo[from];
            _userInfo.depositStartTime = block.timestamp;
            _userInfo.interestAccumulated += _accumulatedInterest;
        } else {
            UserInfo memory _userInfo = UserInfo(block.timestamp, true, 0);
            userInfo[from] = _userInfo;
        }

        IReceiptToken.mint(from, amount);
        emit AssetDeposited(from, amount);
    }

    function depositWithPermint(uint256 assets, address receiver) external {}
    /**
     * @notice Used to withdraw principal from the pool by redeming receipt token.
     */
    function withdraw() external {}

    /**
     * @notice This function is used to borrow assets from the pool
     */
    function borrow() external {}

    /**
     * @notice This function is used to repay the borrowed asset back to the protocol
     */
    function repay() external {}

    /**
     * @notice
     */

    function repayWithPermit() external {}

    function claimInterest() external {}

    function depositInterest() external {}

    function checkYourInterest() external {}

    function calculateInterest() private returns (uint256) {}
}
