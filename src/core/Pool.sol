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
        uint256 priceOfUnderlyingAtBorrowing;
        bool isBorrowed;
    }

    mapping(address => UserInfo) internal userInfo; //mapping userAddress -> UserInfo
    mapping(address => mapping(uint256 => BorrowInfo)) internal borrowInfo; // mapping userAddress -> assetId -> BorrowInfo

    IReceiptToken internal receiptToken;
    address internal underlying;
    uint256 internal collateralizationRatio;
    NFT internal asset;

    /**
     * @notice Emitted when asset deposited to the pool
     * @param from The Address of the depositor
     * @param amount The number of asset deposited
     */
    event AssetDeposited(address indexed from, uint256 amount);

    /**
     * @notice Emitted when asset withdrawn from the pool
     * @param to The address of the receiver
     * @param amount The amount of asset withdrawn
     */
    event AssetWithdrawed(address indexed to, uint256 amount);

    /**
     * @notice Emitted when a user borrowed asset from the pool
     * @param to The address of borrower
     * @param itemId The Id of the collateral
     */
    event Borrowed(address indexed to, uint256 itemId);

    modifier checkAddress(address _address) {
        require(_address != address(0), "Invalid address");
        _;
    }

    constructor(
        address _receiptTokenAddress,
        address _underlying,
        address _nftAddress,
        uint256 _collateralizationRatio
    ) {
        receiptToken = IReceiptToken(_receiptTokenAddress);
        underlying = _underlying;
        asset = NFT(_nftAddress);
        collateralizationRatio = _collateralizationRatio;
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
     * @dev User can borrow only <= 70% of a collateral value
     */
    function borrow(address to, uint256 amount, uint256 itemId) external checkAddress(to) {
        require(amount > 0, "amount > 0");
        require(asset.ownerOf(itemId) == to, "Not Owner"); //This can check both if the itemId is valid and the owner is to
        require(IERC20(underlying).balanceOf(address(this)) > amount, "No liquidity");
        require(!borrowInf[to][itemId].isBorrowed, "Already Borrowed");

        NFT.RWA memory rwa = assets.getRWADetails(itemId);
        uint256 currentUnderlyingPrice = getLatestUnderlyingPrice();
        uint256 borrowingAmount = (rwa.value * collateralizationRatio) / currentUnderlyingPrice;
        require(borrowingAmount >= amount, "Insufficient collateral");

        borrowInfo[to][itemId] = BorrowInfo(borrowingAmount, currentUnderlyingPrice, true);

        require(IERC20(underlying).transferFrom(address(this), to, borrowingAmount), "Transfer failed");

        emit Borrowed(to, itemId);
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

    function getLatestUnderlyingPrice() internal returns (uint256) {
        return 1;
    }

    function calculateInterest() private returns (uint256) {}
}
