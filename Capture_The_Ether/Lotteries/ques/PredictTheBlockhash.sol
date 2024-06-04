/*
    Guessing an 8-bit number is apparently too easy. This time, you need to predict the entire 256-bit block hash for a future block.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PredictTheBlockHashChallenge {
    address guesser;
    bytes32 guess;
    uint256 settlementBlockNumber;
    bool public isPassed;


    function lockInGuess(bytes32 hash) public {
        require(guesser == address(0));

        guesser = msg.sender;
        guess = hash;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser);
        require(block.number > settlementBlockNumber);

        bytes32 answer = blockhash(settlementBlockNumber);

        guesser = address(0);
        if (guess == answer) {
            isPassed = true;
        }
    }
}