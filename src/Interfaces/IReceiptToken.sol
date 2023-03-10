// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";

interface IReceiptToken is IERC20 {
    function mint(address _userAddress, uint256 amount) external;
    function burn(address _userAddress, uint256 amount) external;
}
