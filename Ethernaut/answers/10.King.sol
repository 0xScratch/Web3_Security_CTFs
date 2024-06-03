/*
    This was a tricky one for sure, but much to learn

    So the trick was, usually transfer does only holds up 2300 gas and if it's sent more from that, it kind of fucks up!!
    and that particular contract thought of only EOA accounts gonna interact with it, but if in case a contract account interacted with King contract, what happens is that -> Whenever king tries to transfer the ether back to contract account, three cases happens at the same time:
        - We haven't set any receive criteria in our attack contract, so Contract don't find a way to take any ether
        - The fallback method reverts the transaction
        - 2300 gas limit due to transfer exceeds
    
    Now what happens, King contract don't have any criteria to check whether the transaction was successful or not, and msg.value, msg.sender remains same, and the contract doesn't finds a way to change it

    In simple words, always make sure that whenever your contract is sending some ether to some other contract or wallet, don't always assume it will take your amount for sure, so you need to find a way yourself as a smart contract dev, to check whether the transfer gonna be valid or not 

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack{

    constructor(address _kindAddress) payable{
        address(_kindAddress).call{value: msg.value}("");
    }

    fallback() external payable{
        revert();
    }
}