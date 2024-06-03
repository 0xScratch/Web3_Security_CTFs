// Kind of a difficult one for me, or it's just happens when you are not really aware of much of the stuff. Lessor learned -> Fucking grab up assembly

// I won't be explaining much here, cuz then it be a freaking long article. Better to watch the D-squared video of ethernaut series


// First we be storing our bytecode in a var
var bytecode = '600a600c600039600a6000f3602a60505260206050f3' 

// then some transaction gonna be send in order to initialize the contract which be having the damn magic number
var txn = await web3.eth.sendTransaction({from: player, data: bytecode}) 

// just storing the contract address for ease and future use
var solverAddr = txn.contractAddress 

// Finally call the main function!!
await contract.setSolver(solverAddr)