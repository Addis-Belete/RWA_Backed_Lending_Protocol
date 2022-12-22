// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

interface IReceiptToken {
    function mint(address _userAddress, uint256 amount) external;
    function burn(address _userAddress, uint256 amount) external;
}