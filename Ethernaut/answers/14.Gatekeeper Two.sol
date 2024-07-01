/*
    Hmm, another level which might make some people scratch their damn head..But still this was really easy as compared to last one.
    One need to grab the insights and working of `extcodesize` and `XOR`

    Anyways, Let's fucking go!!

    # Gate 1: There's no need to say anything about this gate, just attack with a smart contract and you gonna nail it

    # Gate 2: This gate is based on the fact that, no external contract should interact with this contract..
              - Actually that 'extcodesize' checks the size of the contract on a particular address, suppose I am interacting with that contract with my own smart contract then I be denied from it, because my 'extcodesize' won't be zero, But if I interact it with any EOA..guess what I be successful cuz EOA don't have any code within them, i.e no smart contracts
              - Yea Yea, a problem I see here and you too..Now if we did use a EOA then how we be passing through gate 1..Here's the answer to it!!
              - There's used to be a vulnerability with this 'extcodesize', just take a step back to basics, when we slide through any constructor, that's the state when the contract is being deployed but haven't finished the process yet, that means between the process of deploying contract, if we called that particular 'extcodesize' our size will still be zero cuz we really haven't deployed any contract till now (Infact! we are halfway ^_^), This fools the barrier and we are going in buddy!!

    # Gate 3: This was quite easy and as well as be difficult too if you don't really know much about XOR. Try to fucking read something about it or just stay here:
              - 'XOR' or '^' is nothing but it just when performed between any two binary numbers, it act like:
                
                |   X   |   Y   |  XOR  |
                |   0   |   0   |   0   |
                |   0   |   1   |   1   |
                |   1   |   0   |   1   |
                |   1   |   1   |   0   |

                As you can see, if bits are same result be '0' and if they are different then it is '1'
            
            - Our required barrier is -> require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max)
            - We need to pass a particular gatekey which might equates the L.H.S to type(uint64).max (in bytes - 0xffffffffffffffff)
            - Now it makes some sense, Usually 1 'f' in 0xffffffffffffffff equals '1111' (in binary format) that means there gonna be a whole series of 1's (in binary format) at R.H.S
            - Now my method is, If we converted that damn L.H.S first part to some binary number and make it XOR with it's 1's complement then it gonna be the desired result we want, Like suppose the 'first part' at L.H.S is 0xfb3 something and in binary format it is 0110100011, it's complement will be 1001011100, and if both be configured with '^' they will form -> 1111111111
            - To nail this thing, we won't be really converting that thing to binary inside our code, cuz that be done behind the scenes as hexadecimals consist of 1's complement too
            - We will use '~' to make the key formed into the 1's complement, and it do works..am not joking dude, try and see

            - Now my another method is, if we went into a situation where A ^ B -> X, and here our task is to find X, then that's easy cuz we know the '^' thing now, But if our task switched to, find 'B' where both A and X are given, what we gonna do? Let's solve this then

                    A = 10101, B = 01010
                    A ^ B = 11111 -> X

                    Now we are given just A and X, then what
                     10101
                   ^ 11111
                    -------
                     01010
                
                i.e if we did A ^ X, then we will get B..As simple as that
            
            - Thus our key will be 'first part' ^ '0xfffffffffffffffff'
        
        and All gates are unlocked now
*/  

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Declaring the interface
interface GateKeeperTwo{
    function enter(bytes8) external returns (bool);
}

contract Attack{
    // Here, I am solving this using my first method
    // But you can consider even use this code -> bytes8 key = bytes8(keccak256(abi.encodePacked(address(this)))) ^ 0xffffffffffffffff;
    bytes8 key = ~bytes8(keccak256(abi.encodePacked(address(this))));

    constructor(address victim){
        // Here we called the function at the time of deployment, thus bypassing the second gate!
        GateKeeperTwo(victim).enter(key);
    }
}