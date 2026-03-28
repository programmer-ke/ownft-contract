// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {Ownft} from "src/Ownft.sol";
import {DeployOwnft} from "script/DeployOwnft.s.sol";

contract OwnftIntegrationTest is Test {
    Ownft public ownft;
    DeployOwnft public deployer;

    function setUp() public {
        deployer = new DeployOwnft();
        ownft = deployer.run();
    }

    function testContractCorrectName() public view {
        assertEq(ownft.name(), "Ownft");
        assertEq(ownft.symbol(), "OFT");
    }
}
