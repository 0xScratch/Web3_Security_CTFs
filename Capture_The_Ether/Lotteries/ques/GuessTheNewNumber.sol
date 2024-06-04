// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract GuessTheNewNumberChallenge {
    bool public isPassed;
    function guess(uint8 n) public {
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));

        if (n == answer) {
            isPassed = true;
        }
    }
}