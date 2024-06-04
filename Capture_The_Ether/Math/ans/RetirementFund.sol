/*
    Quite easy one, I guess.
    But yeah, the problem with me is that I am seeing these questions with versions of Solidity that are too old. Thus, this really sometimes confuse with up and I bring out my own solutions.
    Anyways, if you have seen this code carefully...You must have notice that there is a kind of underflow thing happening in function `collectPenalty`, if the address(this).balance becomes greater than startBalance.

    So, now our task becomes, how to force ether into that contract despite the fact that it doesn't consist of any fallback or receive function..

    Here, we gonna use `selfdestruct`..This is a kind of method by which you can force ether into some contract even if didn't have any receive or fallback function. Just you need to create a contract, send some ether to it, and after the selfdestruct is called, with a value of your target contract (the contract in which you want to force some ether), then the contract will be destroyed and our ether will be transfered

    Steps to complete this level:
        1. Just launch that contract with owner as some other address (Remember it is just useless to cheat with these levels)
        2. Now select the address with which you gonna play, enter it in the constructor and pass in 1 ether in the contract.
        3. Now the balance of our `RetirementFund` contract becomes 1 ether.
        4. Just deploy the below contract with 1 ether as msg.value..and you will notice the balance of `RetirementFund` contract becomes 2 ether
        5. After calling the `collectPenalty` function, you will just win this level
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Attack{

    constructor (address payable target) payable {
        require(msg.value > 0);
        selfdestruct(target);
    }
}