// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract GuessTheNumberChallenge {
    uint8 answer = 42;
    bool public isPassed;

    function guess(uint8 n) public{ 

        if (n == answer) {
            isPassed = true;
        }
    }
}