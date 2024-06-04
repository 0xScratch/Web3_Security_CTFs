/*
    Well, this was quite easily visible due to my `unchecked` keywords...

    Here, we be using that 'integer overflow' thing. This method will work well with the solidity versions less than 0.8, cuz after that solidity started using underflow-overflow checks. Thus, to neglect these effects, we have to use `unchecked`

    Now, the vulnerability is in buy function, Here's how:
        
    E.g. a uint8 can store up to 8 bits: 11111111 = 2^8 — 1 = 255. What happens if we try to do the following calculation?

        uint8 num = 255;
        uint8 numPlusOne = num + 1;
        As there is no more room for another number, the variable numPlusOne will reset back to 0. Adding 2 will result in 1, and so on.
    
    Now, if we consider the large number uint256, the largest number will be -> 115792089237316195423570985008687907853269984665640564039457584007913129639935

    Let's take a closer look at our require statement in `buy` function:
        require(msg.value == numTokens * PRICE_PER_TOKEN)
    
    To pass this require statement, the amount of tokens (numTokens) will be multiplied by 1 ether. And remember that the EVM will interpret 1 ether as 10^18 or 1000000000000000000. So what if we try to buy the following amount?
        (MAX_UINT / 10^18) + 1= 115792089237316195423570985008687907853269984665640564039458
    
    Multiplying it by 10^18 will result in an overflow of 415992086870360064, a little bit below half an ether. So, sending that amount of wei as the msg.value will pass the require statement and give us a lot of tokens.

    After this, the challenge is quite simple, the balance will be 1.415992086870360064 and we can just sell 1 token to receive 1 ether and complete the challenge.
*/