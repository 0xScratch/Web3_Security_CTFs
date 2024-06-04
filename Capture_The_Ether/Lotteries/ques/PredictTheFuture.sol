/*
    This time, you have to lock in your guess before the random number is generated. To give you a sporting chance, there are only ten possible answers.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PredictTheFutureChallenge {
    address guesser;
    uint8 guess;
    uint256 settlementBlockNumber;
    bool public isPassed;

    function lockInGuess(uint8 n) public {
        require(guesser == address(0));

        guesser = msg.sender;
        guess = n;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser);
        require(block.number > settlementBlockNumber);

        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))) % 10;

        guesser = address(0);
        if (guess == answer) {
            isPassed = true;
        }
    }
}