// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BombEngine {
    function explode() public payable{
        selfdestruct(payable(address(0)));
    }
}