// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {Ownft} from "src/Ownft.sol";

contract OwnftTest is Test {
    Ownft public ownft;

    address USER = makeAddr("user");

    function setUp() public {
        ownft = new Ownft();
    }

    function testInitialSupply() public view {
        assertEq(ownft.totalSupply(), 0);
    }

    function testCanMintToken() public {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        vm.prank(USER);

	// mint nft
	ownft.mintNft(description, imageUri);

	// supply should have increased
        assertEq(ownft.totalSupply(), 1);
    }

    // should be able to retrieve nft metadata uri by token id
    
}
