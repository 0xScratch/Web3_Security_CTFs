/*
    This ERC20-compatible token is hard to acquire. Theres a fixed supply of 1,000 tokens, all of which are yours to start with.

    Find a way to accumulate at least 1,000,000 tokens to solve this challenge.
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TokenWhaleChallenge {
    address player;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC20 Token";
    string public symbol = "SET";
    uint8 public decimals = 18;

    constructor(address _player) {
        player = _player;
        totalSupply = 1000;
        balanceOf[player] = 1000;
    }

    function isComplete() public view returns (bool) {
        return balanceOf[player] >= 1000000;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _transfer(address to, uint256 value) internal {
        unchecked {
            balanceOf[msg.sender] -= value;
            balanceOf[to] += value;

            emit Transfer(msg.sender, to, value);
        }
    }

    function transfer(address to, uint256 value) public {
        unchecked {
            require(balanceOf[msg.sender] >= value);
            require(balanceOf[to] + value >= balanceOf[to]);

            _transfer(to, value);
        }
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 value) public {
        unchecked {
            allowance[msg.sender][spender] = value;
            emit Approval(msg.sender, spender, value);
        }
    }

    function transferFrom(address from, address to, uint256 value) public {
        unchecked {
            require(balanceOf[from] >= value);
            require(balanceOf[to] + value >= balanceOf[to]);
            require(allowance[from][msg.sender] >= value);

            allowance[from][msg.sender] -= value;
            _transfer(to, value);
        }
    }
}