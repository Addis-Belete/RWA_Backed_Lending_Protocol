// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../src/core/NFT.sol";

contract NFTTest is Test {
    NFT nft;
    address admin = address(20);

    function setUp() public {
        nft = new NFT(admin);
    }

    function testMintRWA() public {
        vm.startPrank(admin);
        nft.mintRWA(address(30), 20000, NFT.AssetType(0), "www.token1.com");
        vm.stopPrank();
    }
}
