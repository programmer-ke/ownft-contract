// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testCovertSvgToUri() public view {
        string memory expectedUri =
            "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPiAgPGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiBmaWxsPSJ5ZWxsb3ciIHI9Ijc4IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiLz4gIDxnIGNsYXNzPSJleWVzIj4gICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz4gICAgPGNpcmNsZSBjeD0iMTI3IiBjeT0iODIiIHI9IjEyIi8+ICA8L2c+ICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+PC9zdmc+";
        string memory svg =
            '<svg viewBox="0 0 200 200" width="400"  height="400" xmlns="http://www.w3.org/2000/svg">  <circle cx="100" cy="100" fill="yellow" r="78" stroke="black" stroke-width="3"/>  <g class="eyes">    <circle cx="70" cy="82" r="12"/>    <circle cx="127" cy="82" r="12"/>  </g>  <path d="m136.81 116.53c.69 26.17-64.11 42-81.52-.73" style="fill:none; stroke: black; stroke-width: 3;"/></svg>';
        string memory actualUri = deployer.svgToImageURI(svg);
        assert(keccak256(abi.encodePacked(actualUri)) == keccak256(abi.encodePacked(expectedUri)));
    }
}
