// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Ownft} from "src/Ownft.sol";
import {BasicNft} from "src/BasicNft.sol";

contract MintOwnft is Script {
    string public constant GIF = "https://ipfs.io/ipfs/bafybeiehuuwijco3dgblpaq56isbrum32gtjd6neaewj322c5ptjp5vdjy";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Ownft", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        string memory description = "Dancing forever";
        uint96 royaltyBps = 500; // 5%

        vm.startBroadcast();
        Ownft(contractAddress).mintNft(description, GIF, royaltyBps);
        vm.stopBroadcast();
    }
}

contract MintBasicNft is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}
