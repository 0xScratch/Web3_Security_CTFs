/*
    To complete this challenge, become the owner.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract AssumeOwnershipChallenge {
    address owner;
    bool public isComplete;

    function AssumeOwmershipChallenge() public {
        owner = msg.sender;
    }

    function authenticate() public {
        require(msg.sender == owner);

        isComplete = true;
    }
}