// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/// @title Ownft, an NFT contract
/// @notice Allows anyone to mint their own NFT by supplying a URI to the NFT
contract Ownft is ERC721Enumerable, ERC2981 {
    struct NftMetadata {
        string description;
        string imageUri;
    }
    uint256 private s_tokenCounter;
    mapping(uint256 => NftMetadata) private s_tokenIdToNftMeta;

    constructor() ERC721("Ownft", "OFT") {}

    /// @notice Mint an NFT by supplying an image URI
    /// @param description A text description of the NFT content
    /// @param imageUri A URI of the NFT image
    /// @param royaltyBps Royalty in basis points (500 = 5%)
    function mintNft(string calldata description, string calldata imageUri, uint96 royaltyBps) public {
        s_tokenIdToNftMeta[s_tokenCounter] = NftMetadata({description: description, imageUri: imageUri});
        _safeMint(msg.sender, s_tokenCounter);
        _setTokenRoyalty(s_tokenCounter, msg.sender, royaltyBps);
        s_tokenCounter += 1;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        NftMetadata storage nftMetadata = s_tokenIdToNftMeta[tokenId];
        string memory nftName = string.concat(name(), " #", Strings.toString(tokenId));
        string memory encodedMetadata =
            Base64.encode(createMetadataJson(nftName, nftMetadata.description, nftMetadata.imageUri));
        string memory metadataUri = string.concat(_jsonB64BaseUri(), encodedMetadata);
        return metadataUri;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function createMetadataJson(string memory name, string memory description, string memory imageUri)
        public
        pure
        returns (bytes memory)
    {
        bytes memory jsonMetadata = abi.encodePacked(
            '{"name": "',
            Strings.escapeJSON(name),
            '", "description": "',
            Strings.escapeJSON(description),
            '", "image": "',
            Strings.escapeJSON(imageUri),
            '"}'
        );

        return jsonMetadata;
    }

    function _jsonB64BaseUri() private pure returns (string memory) {
        return "data:application/json;base64,";
    }
}
