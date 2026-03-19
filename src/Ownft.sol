// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/// @title Ownft, an NFT contract
/// @notice Allows anyone to mint their own NFT by supplying a URI to the NFT
contract Ownft is ERC721Enumerable {
    struct NftMetadata {
        string description;
        string imageUri;
    }
    uint256 private s_tokenCounter;
    mapping(uint256 => NftMetadata) private s_tokenIdToNftMeta;

    constructor() ERC721("Ownft", "OFT") {}

    function mintNft(string calldata description, string calldata imageUri) public payable {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToNftMeta[s_tokenCounter] = NftMetadata({description: description, imageUri: imageUri});
        s_tokenCounter += 1;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        NftMetadata storage nftMetadata = s_tokenIdToNftMeta[tokenId];
        string memory nftName = string.concat(name(), " #", Strings.toString(tokenId));
        string memory encodedMetadata =
            Base64.encode(createMetadataJson(nftName, nftMetadata.description, nftMetadata.imageUri));
        string memory metadataUri = string.concat(_jsonB64BaseUri(), encodedMetadata);
        return metadataUri;
    }

    function createMetadataJson(string memory name, string memory description, string memory imageUri)
        public
        pure
        returns (bytes memory)
    {
        bytes memory jsonMetadata = abi.encodePacked(
            '{"name": "', name, '", "description": "', description, '", "image": "', imageUri, '"}'
        );

        return jsonMetadata;
    }

    function _jsonB64BaseUri() private pure returns (string memory) {
        return "data:application/json;base64,";
    }
}
