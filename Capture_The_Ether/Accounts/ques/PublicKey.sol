/*
    Recall that an address is the last 20 bytes of the keccak-256 hash of the address's public key.

    To complete this challenge, find the public key for the owner's account.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PublicKeyChallenge {
    address owner = 0x92b28647Ae1F3264661f72fb2eB9625A89D88A31;
    bool public isComplete;

    function authenticate(bytes memory publicKey) public {
        require(address(uint160(uint256(keccak256(publicKey)))) == owner);

        isComplete = true;
    }
}