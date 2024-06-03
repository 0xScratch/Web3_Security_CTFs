/*
    Here the main contract is 'HackMe.sol', and you can't make changes to both of them...

    your task - 
        Claim the ownership of 'HackMe.sol'
    
    Note - Make sure that while calling a 'delegatecall' on some other contract, your state variables stucture should match with that particular contract including the way they are declared!!
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.19;

contract Lib{
    uint public someNumber;

    function doSomething(uint _num) public{
        someNumber = _num;
    }
}