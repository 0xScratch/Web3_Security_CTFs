/**
    Imagine a world where the rules are meant to be broken, and only the cunning and the bold can rise to power. Welcome to the Higher Order, a group shrouded in mystery, where a treasure awaits and a commander rules supreme.

    Your objective is to become the Commander of the Higher Order! Good luck!

    Things that might help:
    - Sometimes, calldata cannot be trusted.
    - Compilers are constantly evolving into better spaceships.

    Note: The original contract on ethernaut consists of solidity version 0.6.12. Just for this repo sake, I have updated the version to 0.8.0. The only change in the code apart from the version is -> On line 23, `treasury.slot` instead of `treasury_slot`.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HigherOrder {
    address public commander;

    uint256 public treasury;

    function registerTreasury(uint8) public {
        assembly {
            sstore(treasury.slot, calldataload(4))
        }
    }

    function claimLeadership() public {
        if (treasury > 255) commander = msg.sender;
        else revert("Only members of the Higher Order can become Commander");
    }
}