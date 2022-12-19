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

    function testFailMintRWA() public {
        vm.startPrank(address(10));
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        vm.expectRevert("Only admin");
    }

    function testTransferFrom() public {
        vm.startPrank(admin);
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        vm.stopPrank();
        vm.startPrank(address(30));
        nft.approve(admin, 1);
        vm.stopPrank();
        vm.startPrank(admin);
        nft.transferFrom(address(30), address(40), 1);
        NFT.RWA memory rwa = nft.getRWADetails(1);
        assertEq(rwa.owner, address(40));
        vm.stopPrank();
    }

    function testFailTransferFrom() public {
        vm.startPrank(admin);
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        vm.stopPrank();
        vm.startPrank(address(30));
        nft.approve(admin, 1);
        vm.stopPrank();
        vm.startPrank(admin);
        nft.transferFrom(address(20), address(40), 1);
        NFT.RWA memory rwa = nft.getRWADetails(1);
        assertEq(rwa.owner, address(40));
        vm.stopPrank();
    }

    function testSafeTransferFrom() public {
        vm.startPrank(admin);
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        vm.stopPrank();
        vm.startPrank(address(30));
        nft.approve(admin, 1);
        vm.stopPrank();
        vm.startPrank(admin);
        nft.safeTransferFrom(address(30), address(40), 1);
        NFT.RWA memory rwa = nft.getRWADetails(1);
        assertEq(rwa.owner, address(40));
        vm.stopPrank();
    }

    function testFailSafeTransferFrom() public {
        vm.startPrank(admin);
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        vm.stopPrank();
        vm.startPrank(address(30));
        nft.approve(admin, 1);
        vm.stopPrank();
        vm.startPrank(admin);
        nft.safeTransferFrom(address(20), address(40), 1);
        NFT.RWA memory rwa = nft.getRWADetails(1);
        assertEq(rwa.owner, address(40));
        vm.stopPrank();
    }
}
