/**
    This contract is used only for the requirements of 1st and 2nd condition which is mentioned here -> https://github.com/0xScratch/Web3_Security_CTFs/blob/d6ae02ea7bb9d5710512c40af51925598adcb4a4/Ethernaut/README.md#L1283
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Stake {
    function StakeWETH(uint256 amount) external returns (bool);
}

interface IWETH {
    function approve(address spender, uint256 amount) external returns (bool);
}

contract MaliciousStaker {
    Stake private immutable i_stake;
    IWETH private i_weth;

    uint256 private defaultStake = 0.001 ether + 1 wei;

    constructor(Stake _stake, IWETH _weth) payable {
        require(msg.value >= defaultStake, "Not enough eth sent");
        i_stake = _stake;
        i_weth = _weth;
    }

    function stakeWETH() private {
        i_weth.approve(address(i_stake), type(uint256).max);
        i_stake.StakeWETH(defaultStake);
    }
}