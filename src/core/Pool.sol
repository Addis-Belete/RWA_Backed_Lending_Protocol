// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "../Interfaces/IReceiptToken.sol";
import "./NFT.sol";
import "openze ppelin-contracts/token/ERC20/IERC20.sol";

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

    //Struct the holds a borrow info
    struct BorrowInfo {
        uint256 borrowedAmount;
        bool isBorrowed;
    }

    mapping(address => UserInfo) internal userInfo;
    IReceiptToken internal receiptToken;
    address internal underlying;
    NFT internal asset;

    event AssetDeposited(address indexed from, uint256 amount);

    event AssetWithdrawed(address indexed to, uint256 amount);

    modifier checkAddress(address _address) {
        require(_address != address(0), "Invalid address");
        _;
    }

    constructor(address _receiptTokenAddress, address _underlying, address _nftAddress) {
        receiptToken = IReceiptToken(_receiptTokenAddress);
        underlying = _underlying;
        asset = NFT(_nftAddress);
    }

    /**
     * @notice Used to deposit Assets to the pool and get rewards
     * Everytime user deposited The initail balance interest calculated and stored.
     */
    function deposit(address from, uint256 amount) external checkAddress(from) {
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

        receiptToken.mint(from, amount);
        emit AssetDeposited(from, amount);
    }

    function depositWithPermint(uint256 assets, address receiver) external {}
    /**
     * @notice Used to withdraw principal from the pool by redeming receipt token.
     */

    function withdraw(address to, uint256 amount) external checkAddress(to) {
        require(receiptToken.balanceOf(to) >= amount, "Less amount");
        // calculateInterest();
        //UserInfo storage _userInfo = userInfo[to];
        receiptToken.burn(to, amount);
        require(IERC20(underlying).transferFrom(address(this), to, amount), "Transfer failed");
        emit AssetWithdrawed(to, amount);
    }

    /**
     * @notice This function is used to borrow assets from the pool
     */
    function borrow(address to, uint256 amount, uint256 itemId) external checkAddress(to) {
        require(asset.ownerOf(itemId) == to, "Not Owner");
        require(IERC20(underlying).balanceOf(address(this)) > amount, "No liquidity");
        NFT.RWA storage rwa = realWorldAssetDetails();
    }

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

    function getLatestUnderlyingPrice() internal returns (uint256) {}

    function calculateInterest() private returns (uint256) {}
}
