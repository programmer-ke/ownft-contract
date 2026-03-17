// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {Ownft} from "src/Ownft.sol";

contract OwnftTest is Test {
    Ownft public ownft;

    function setUp() public {
        ownft = new Ownft();
    }

    function testInitialSupply() public view {
        assertEq(ownft.totalSupply(), 0);
    }
}
