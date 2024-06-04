/*
    This token contract allows you to buy and sell tokens at an even exchange rate of 1 token per ether.

    The contract starts off with a balance of 1 ether. See if you can take some of that away.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor() payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        unchecked {
            require(msg.value == numTokens * PRICE_PER_TOKEN);

            balanceOf[msg.sender] += numTokens;
        }
    }

    function sell(uint256 numTokens) public payable{
        unchecked {
            require(balanceOf[msg.sender] >= numTokens);

            balanceOf[msg.sender] -= numTokens;
            payable(msg.sender).transfer(numTokens * PRICE_PER_TOKEN);
        }
    }
}