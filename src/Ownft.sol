// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {IERC4906} from "@openzeppelin/contracts/interfaces/IERC4906.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/// @title Ownft, an NFT contract
/// @notice Allows anyone to mint their own NFT by supplying a URI to the NFT
contract Ownft is ERC721Enumerable, ERC2981, IERC4906 {
    error Ownft__InvalidDescription();
    error Ownft__InvalidImageUri();
    error Ownft__NotTokenOwner();

    struct NftMetadata {
        string description;
        string imageUri;
    }

    bytes4 private constant IERC4906_INTERFACE_ID = bytes4(0x49064906);
    uint256 private s_tokenCounter;
    mapping(uint256 => NftMetadata) private s_tokenIdToNftMeta;

    constructor() ERC721("Ownft", "OFT") {}

    /// @notice Mint an NFT by supplying an image URI
    /// @param description A text description of the NFT content
    /// @param imageUri A URI of the NFT image
    /// @param royaltyBps Royalty in basis points (500 = 5%)
    /// @dev reverts if description or imageUri is empty
    function mintNft(string calldata description, string calldata imageUri, uint96 royaltyBps) public {
        if (!(bytes(description).length > 0)) {
            revert Ownft__InvalidDescription();
        }

        if (!(bytes(imageUri).length > 0)) {
            revert Ownft__InvalidImageUri();
        }

        s_tokenIdToNftMeta[s_tokenCounter] = NftMetadata({description: description, imageUri: imageUri});
        _safeMint(msg.sender, s_tokenCounter);
        _setTokenRoyalty(s_tokenCounter, msg.sender, royaltyBps);
        s_tokenCounter += 1;
    }

    /// @notice Allow token owner to update its description
    /// @param tokenId The token identifier
    /// @param newDescription The new token description
    /// @dev reverts if the message sender is not the owner
    ///  or if the description is empty
    function updateTokenDescription(uint256 tokenId, string calldata newDescription) public {
        if (ownerOf(tokenId) != msg.sender) {
            revert Ownft__NotTokenOwner();
        }

        if (!(bytes(newDescription).length > 0)) {
            revert Ownft__InvalidDescription();
        }

        NftMetadata storage nftMetadata = s_tokenIdToNftMeta[tokenId];
        nftMetadata.description = newDescription;
        emit MetadataUpdate(tokenId);
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

    /// @notice Retrieves token description and imageUri associated with the token
    function getNftMetadata(uint256 tokenId) public view returns (string memory, string memory) {
        NftMetadata storage nftMetadata = s_tokenIdToNftMeta[tokenId];
        return (nftMetadata.description, nftMetadata.imageUri);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Enumerable, ERC2981, IERC165)
        returns (bool)
    {
        return (interfaceId == IERC4906_INTERFACE_ID) || super.supportsInterface(interfaceId);
    }

    /// @dev Returns a properly formatted token metadata JSON
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
