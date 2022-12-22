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

    function deposit(uint256 assets, address receiver) external {}

    function withdraw() external {}

    function borrow() external {}

    function repay() external {}
}
