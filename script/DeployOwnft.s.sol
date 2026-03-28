// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;
import {Script} from "forge-std/Script.sol";
import {Ownft} from "src/Ownft.sol";

contract DeployOwnft is Script {
    function run() external returns (Ownft) {
        vm.startBroadcast();
        Ownft ownft = new Ownft();
        vm.stopBroadcast();
        return ownft;
    }
}
