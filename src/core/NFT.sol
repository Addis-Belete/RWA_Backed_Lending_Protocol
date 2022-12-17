// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    struct RWA {
        AssetType assetType;
        uint256 value;
        uint256 mintingDate;
        address owner;
    }

    enum AssetType {
        DomesticBuilding,
        CommercialBuilding,
        Land,
        Vehicles,
        Machinery
    }

    mapping(uint256 => RWA) public realWorldAssetDetails; //AssetId -> RWA
    uint256 private tokenId;
    address private admin;

    /**
     * @notice Emitted after the RWA minted.
     * @param owner The address of the RWA oner
     * @param value The value of the RWA at the time of minting
     * @param assetType The type of the asset
     * @param _tokenURI The URI to the metadata of the RWA
     */
    event RWAMinted(address indexed owner, uint256 value, AssetType indexed assetType, string _tokenURI);

    constructor(address _admin) ERC721("Real World Asseet", "RWA") {
        admin = _admin;
        //This constructor changes to initialize for upgradable contract
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only called by admin");
        _;
    }

    /**
     * @notice Mints an NFT that represents realworld asset
     * @dev RWA only minted by the admin
     * @param _owner The address of the RWA oner
     * @param _value The value of the RWA at the time of minting
     * @param _assetType The type of the asset
     * @param _tokenURI The URI to the metadata of the RWA
     */
    function mintRWA(address _owner, uint256 _value, AssetType _assetType, string calldata _tokenURI)
        external
        onlyAdmin
    {
        tokenId++;
        realWorldAssetDetails[tokenId] = RWA(_assetType, _value, block.timestamp, _owner);
        _mint(_owner, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        emit RWAMinted(_owner, _value, _assetType, _tokenURI);
    }
}
