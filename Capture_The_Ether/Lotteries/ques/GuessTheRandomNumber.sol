// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract GuessTheRandomNumberChallenge {
    uint8 answer;
    bool public isPassed;

    constructor() {
        answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public {
        if (n == answer) {
            isPassed = true;
        }
    }
}