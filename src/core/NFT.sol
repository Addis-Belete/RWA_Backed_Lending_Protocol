// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    struct RWA {
        AssetType _type;
        uint256 value;
    }

    enum AssetType {
        DomesticBuilding,
        CommercialBuilding,
        Land,
        Vehicles,
        Machinery
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
