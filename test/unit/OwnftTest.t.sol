// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {Test, console} from "forge-std/Test.sol";
import {Ownft} from "src/Ownft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract OwnftTest is Test {
    event MetadataUpdate(uint256 _tokenId); // emitted for token metadata updates (ERC4906)

    Ownft public ownft;

    address USER = makeAddr("user");
    address OTHERUSER = makeAddr("otheruser");

    function setUp() public {
        ownft = new Ownft();
    }

    function testInitialSupply() public view {
        assertEq(ownft.totalSupply(), 0);
    }

    function testCanMintToken() public {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        uint96 royaltyPercentage = 500; // basis points units i.e. 5%
        vm.prank(USER);

        // mint nft
        ownft.mintNft(description, imageUri, royaltyPercentage);

        // supply should have increased
        assertEq(ownft.totalSupply(), 1);
    }

    function testValidMetadataJsonCreated() public view {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        string memory name = "Ownft #123";
        console.log("user address", USER);
        string memory expectedJson =
            '{"name": "Ownft #123", "description": "My NFT Description", "image": "https://ipfs.io/ipfs/someipfscid", "owner": "0x6ca6d1e2d5347bfab1d91e883f1915560e09129d"}';

        bytes memory jsonMetadata = ownft.createMetadataJson(name, description, imageUri, USER);

        assertEq(keccak256(bytes(expectedJson)), keccak256(jsonMetadata));
    }

    function testCanRetrieveTokenMetadataUri() public {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        string memory name = "Ownft #0";
        uint96 royaltyPercentage = 500;

        // prepare the expected b64 encoded NFT Metadata Uri
        string memory encodedMetadata = Base64.encode(ownft.createMetadataJson(name, description, imageUri, USER));
        string memory expectedMetadataUri = string(abi.encodePacked("data:application/json;base64,", encodedMetadata));

        console.log(expectedMetadataUri);

        // mint nft and retrieve Uri
        vm.prank(USER);
        ownft.mintNft(description, imageUri, royaltyPercentage);
        string memory tokenMetadataUri = ownft.tokenURI(0);

        assertEq(keccak256(bytes(tokenMetadataUri)), keccak256(bytes(expectedMetadataUri)));
    }

    function testTokenURIRevertsIfTokenNotMinted() public {
        vm.expectRevert();
        ownft.tokenURI(1);
    }

    function testCanUpdateTokenDescription() public {
        string memory originalDescription = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        uint96 royaltyPercentage = 500; // basis points units i.e. 5%

        // mint nft
        vm.prank(USER);
        ownft.mintNft(originalDescription, imageUri, royaltyPercentage);

        (string memory storedDescription,) = ownft.getNftMetadata(0);
        assertEq(originalDescription, storedDescription);

        // update description
        string memory newDescription = "My NFT doing awesome thing";

        vm.prank(USER);

        vm.expectEmit(false, false, false, true);
        emit MetadataUpdate(0);

        ownft.updateTokenDescription(0, newDescription);

        // confirm changes
        (storedDescription,) = ownft.getNftMetadata(0);
        assertEq(newDescription, storedDescription);
        assertNotEq(originalDescription, storedDescription);
    }

    function testOnlyOwnerCanUpdateDescription() public {
        string memory originalDescription = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        uint96 royaltyPercentage = 500; // basis points units i.e. 5%

        // mint nft
        vm.prank(USER);
        ownft.mintNft(originalDescription, imageUri, royaltyPercentage);

        // let other user attempt update
        vm.prank(OTHERUSER);

        vm.expectRevert(Ownft.Ownft__NotTokenOwner.selector);
        ownft.updateTokenDescription(0, "Description from malicious user");
    }

    function testEmptyDescriptionReverts() public {
        // minting with empty description should revert
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        uint96 royaltyPercentage = 500; // basis points units i.e. 5%
        vm.prank(USER);

        vm.expectRevert(Ownft.Ownft__InvalidDescription.selector);
        ownft.mintNft("", imageUri, royaltyPercentage);

        // updating description with empty string should revert
        vm.prank(USER);
        ownft.mintNft("some description", imageUri, royaltyPercentage);

        vm.prank(USER);
        vm.expectRevert(Ownft.Ownft__InvalidDescription.selector);
        ownft.updateTokenDescription(0, "");
    }

    function testEmptyImageUriReverts() public {
        // minting with empty imageUri should revert
        string memory description = "my token";
        uint96 royaltyPercentage = 500; // basis points units i.e. 5%
        vm.prank(USER);

        vm.expectRevert(Ownft.Ownft__InvalidImageUri.selector);
        ownft.mintNft(description, "", royaltyPercentage);
    }

    function testNonExistentTokenMetadataReverts() public {
        vm.prank(USER);

        vm.expectRevert();
        ownft.getNftMetadata(2);
    }

    function testTokenTransferEmitsMetadataUpdate() public {
        string memory description = "My NFT Description";
        string memory imageUri = "https://ipfs.io/ipfs/someipfscid";
        uint96 royaltyPercentage = 500; // basis points units i.e. 5%

        // mint nft
        vm.prank(USER);
        ownft.mintNft(description, imageUri, royaltyPercentage);

        // transfer token to new user
        vm.prank(USER);

        vm.expectEmit(false, false, false, true);
        emit MetadataUpdate(0);

        ownft.safeTransferFrom(USER, OTHERUSER, 0);
    }
}
