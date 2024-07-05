/*
    So this is the contract, which we gonna interact with

    There be just some different data types of solidity, and we gonna access them through 'web3.eth.getStorageat'
    This basic method will make us see every variables stored at evm related to this contract, including the 'private' ones
    Make sure that 'private' ones just don't get accessed by any EOA and smart contracts, otherwise they can be just read!!

    // Some EVM functionality:
        - Actually EVM has around 2**256 slots for data storage per contract, starting from 0 to 2**256 - 1
        - and each slot can have storage upto 32 bytes
        - like suppose if a variables gathered some storage in a particular slot, then if the space remains for the next variable, then it will be stored in same slot, otherwise get a new one

    Let's fucking Go.....
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault{
    //slot 0
    uint public count = 123; // 32 bytes, as 256 bits divided by 8 = 32 bytes and 1 byte = 8 bits

    // slot 1
    address public owner = msg.sender; // 20 bytes
    bool public isTrue = true; // 1 byte
    uint16 public u16 = 31; // 2 bytes, as 16 bits / 8 bits = 2

    // slot 2
    bytes32 private password;

    // constants don't use storages, they get configured in the bytecode
    uint public constant someConst = 123;

    // slot 3, 4, 5 (one for each array element)
    bytes32[3] public data;

    struct User{
        uint id;
        bytes32 password;
    }

    // slot 6 - length of array
    // starting from slot keccak256(6) - array elements
    // slot where array element is stored = keccak256(slot) + (index * elementSize)
    // where slot = 6 and elementSize = 2 (1 (uint) + 1 (bytes32)) -> 2 slots next to keccak256(6) gonna be booked by first element
    User[] private users;

    // slot 7 - empty
    // entries are stored at keccak256(key, slot)
    // where slot = 7, key = map key
    mapping(uint => User) private idToUser;

    constructor(bytes32 _password){
        password = _password;
    }

    function addUser(bytes32 _password) public {
        User memory user = User({
            id: users.length,
            password: _password
        });

        users.push(user);
        idToUser[user.id] = user;
    }

    function getArrayLocation(uint slot, uint index, uint elementSize) public pure returns (uint) {
        return uint(keccak256(abi.encodePacked(slot))) + (index * elementSize);
    }

    function getMapLocation(uint slot, uint key) public pure returns(uint) {
        return uint(keccak256(abi.encodePacked(key, slot)));
    }
}

