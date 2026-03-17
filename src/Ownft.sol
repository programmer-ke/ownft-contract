// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/// @title Ownft, an NFT contract
/// @notice Allows anyone to mint their own NFT by supplying a URI to the NFT
contract Ownft is ERC721Enumerable {
    constructor() ERC721("Ownft", "OFT") {}
}
