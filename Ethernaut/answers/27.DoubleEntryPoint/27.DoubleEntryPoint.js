/*
    Kind of a nice one, but still you need to know a bit of stuff about Double Entry point

    Moreover, you can find the explanation in these two links:
        1. https://medium.com/coinmonks/26-double-entry-point-ethernaut-explained-f9c06ac93810
        2. https://daltyboy11.github.io/every-ethernaut-challenge-explained/#doubleentrypoint
*/

// First we need to deploy our DetectionBot contract, for that just copy down the code avaialble in 27.DetectionBot.sol 
// It will ask for a vault address which can be retrieved like this
const cryptoVaultAddr = await contract.cryptoVault()

// Now we need to register our bot within the Forta contract
const fortaAddr = await contract.forta()

// Copy the address of your deployed DetectionBot
const detectionBotAddr = "<your-bot-address>"

// Setting up the function part of the call data - Copy the down code and paste it in the console
const func = {
    "inputs": [
      { 
        "name": "detectionBotAddr",
        "type": "address"
      }
    ],
    "name": "setDetectionBot", 
    "type": "function"
};

// Next, we will define the parameters of the call, which is where we will pass in our detection bot address
const params = [detectionBotAddr]

// Now just concatenate our calldata
const data = web3.eth.abi.encodeFunctionCall(func, params)

// Finally, we send our transaction to set our bot
await web3.eth.sendTransaction({
  from: player,
  to: fortaAddr,
  data: data
})

// Now you can just submit the instance