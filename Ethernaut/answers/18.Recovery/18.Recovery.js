/*
    Kind of a easy one only if you know how to recover an address, otherwise it's hard and you won't find any way!!

    So basically you need to recover the address and this can be done by the below code, here how it works
    You need to get the main contract address which is deploying the other contract 'SimpleToken', that means when we created a new instance, it automatically deployed its first simple token contract (instance of it), if you have paid attention, you might have noticed that 0.001 ether was paid from your side

    Usually a contract address is retrieved by making some calculations with the help of our main contract address which is creating the instance of 'simple token', here main contract address is -> 'Recovery' one. and a nonce (number of transactions made by that contract, which is just 1 so far)
    With this we got the lost account address

    There's one more easy way, after creating the instance of Recovery level, go to your metamask and click on the latest transaction, then move to the option 'view on block explorer', there you will find the contract address we are looking for!!

    Well, we got the contract address, now time to rush for the solidity hack code and call destroy, for that just reach down to `18.Recovery.sol`
*/

var getContractAddress = require('@ethersproject/address').getContractAddress

var futureAddress = getContractAddress({
    from: "0x1Bf9870fdB141c822aAa8aF1aB1002A37Ae7DD9f",
    nonce: 1
})

console.log(futureAddress)
// lost contract address -> 0x43b7819801d07e944001c8C3bee2C64D2Ad95F83