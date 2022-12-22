// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract ReceiptToken is ERC20 {
    address internal poolAddress;
    address internal admin;

    event PoolAddressChanged(address _poolAddress);

    modifier onlyPool() {
        require(msg.sender == poolAddress, "Only by pool");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only by admin");
        _;
    }

    constructor(address _poolAddress) ERC20("Receipt Token", "RT") {
        poolAddress = _poolAddress;
    }

    /**
     * @dev {See IERC20 mint function}
     */
    function mint(address _userAddress, uint256 amount) external onlyPool {
        _mint(_userAddress, amount);
    }

    /**
     * @dev {See IERC20 burn function}
     */
    function burn(address _userAddress, uint256 amount) external onlyPool {
        _burn(_userAddress, amount);
    }

    /**
     * @notice changes the address of the pool
     * @param _poolAddress the address of the pool to be changed;
     */
    function changePoolAddress(address _poolAddress) external onlyAdmin {
        require(_poolAddress != address(0), "Invalid Address");
        poolAddress = _poolAddress;
        emit PoolAddressChanged(_poolAddress);
    }
}
