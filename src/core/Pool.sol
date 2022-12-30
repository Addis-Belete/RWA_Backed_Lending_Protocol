// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "../Interfaces/IReceiptToken.sol";

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

    IReceiptToken internal receiptToken;

    constructor(address _receiptTokenAddress) {
        receiptToken = IReceiptToken(_receiptTokenAddress);
    }

    /**
     * @notice Used to deposit Assets to the pool and get rewards
     */
    function deposit(uint256 assets, address receiver) external {}

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
}
