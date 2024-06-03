/*
    This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.

    ### THINGS THAT MIGHT HELP ###
    - Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
    - The assembly keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. The extcodesize call in this gate will get the size of a contract's code at a given address.
    - The ^ character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation. The Coin Flip level is also a good place to start when approaching this challenge.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}