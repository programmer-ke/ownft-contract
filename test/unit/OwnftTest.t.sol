// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {Ownft} from "src/Ownft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

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

    function testValidMetadataJsonCreated() public view {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        string memory name = "Ownft #123";
        string memory expectedJson =
            '{"name": "Ownft #123", "description": "My NFT Description", "image": "https://ipfs.io/ipfs/someipfscid"}';

        bytes memory jsonMetadata = ownft.createMetadataJson(name, description, imageUri);

        assertEq(keccak256(bytes(expectedJson)), keccak256(jsonMetadata));
    }

    function testCanRetrieveTokenMetadataUri() public {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        string memory name = "Ownft #0";

        // prepare the expected b64 encoded NFT Metadata Uri
        string memory encodedMetadata = Base64.encode(ownft.createMetadataJson(name, description, imageUri));
        string memory expectedMetadataUri = string(abi.encodePacked("data:application/json;base64,", encodedMetadata));

        console.log(expectedMetadataUri);

        // mint nft and retrieve Uri
        vm.prank(USER);
        ownft.mintNft(description, imageUri);
        string memory tokenMetadataUri = ownft.tokenURI(0);

        assertEq(keccak256(bytes(tokenMetadataUri)), keccak256(bytes(expectedMetadataUri)));
    }
}
