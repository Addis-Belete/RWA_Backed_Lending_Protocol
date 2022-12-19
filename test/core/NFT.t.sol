// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "forge-std/Test.sol";
import "../../src/core/NFT.sol";

contract NFTTest is Test {
    NFT nft;
    address admin = address(20);

    event RWAMinted(address indexed owner, uint256 value, NFT.AssetType indexed assetType, string _tokenURI);

    function setUp() public {
        nft = new NFT(admin);
    }

    function testMintRWA() public {
        vm.startPrank(admin);
        vm.expectEmit(true, false, true, false);
        emit RWAMinted(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        NFT.RWA memory rwa = nft.getRWADetails(1);
        assertEq(rwa.owner, address(30));
        assertEq(rwa.value, 20000);
        assertEq(rwa.isActive, false);
        assertEq(rwa.isInOurOffice, true);
        string memory _tokenURI = nft.tokenURI(1);
        assertEq(_tokenURI, "www.token1.com");
        vm.stopPrank();
    }
}
