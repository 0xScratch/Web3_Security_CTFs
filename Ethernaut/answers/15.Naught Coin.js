/*
    This is a kind of easy one, atleast for me it really is..Just there's a good reading or understanding of what's exactly going in ERC20 token contract under that openzeppelin library...

    Well, Let's dive in and see what's going on here!!

    This is just a simple ERC20 token implementation and creation of our own token that is named 'NaughtCoin', with some large amount of initial supply and that all is alloted to our wallet address..
    The goal is to transfer or just empty out our current wallet..Seems easy right?
    But there's a fucking twist, if you closely look for that 'trasnfer' function, you will find out that modifier which stops us to use it for around 10 years, hmm really painful!!

    Now, the catch is that it's easy to take out tokens from our wallet, just need some quick brainstorming..

    The idea behind all this is that, ERC20 provides us two more functions for help (btw there's a bunch more function which ERC20 provides, either look the original code on github or just copy paste this one on REMIX, and seek it out!!)
    
    'approve' - this function is used by any wallet to let some other address to spend some tokens from it's account (refer ERC20.sol at github for depth)

    'transferFrom' - the only accounts which got permission are allowed to spend tokens from the referred wallet (refer to github)
*/

// first we gonna check the balannce of our account using javascript implementing functions
(await contract.balanceOf(player)).toString()
"1000000000000000000000000"

// that's the amount we currently held, now let's approve us to spend our own tokens
await contract.approve(player, "1000000000000000000000000")

// After we got approved, we need to transfer these tokens to some random address
var some_random_address;

await contract.transferFrom(player, some_random_address, "1000000000000000000000000")

// Now let's check our balance again
(await contract.balanceOf(player)).toString()
"0"

// CHEERS!!!