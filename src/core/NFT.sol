// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    struct RWA {
        string _type;
        uint256 value;
    }

    constructor() ERC721("Real World Asseet", "RWA") {
        //This constructor changes to initialize for upgradable contract
    }

    modifier onlyAdmin() {
        _;
    }

    function mintRWA() external onlyAdmin {
        //This function Registers real world asset on blockchain
    }
}
