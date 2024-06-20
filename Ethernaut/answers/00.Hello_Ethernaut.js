// These all are the commands you need to log in the console, use await for a better output!!

await contract.info()
await contract.info1()
await contract.info2('hello')
await contract.infoNum() // This gives us the number 42
await contract.info42()
await contract.theMethodName()
await contract.method7123949()

// password is a state variable, so it can be called up
await contract.password() // it gives us the password which is "ethernaut0" -> type string
await contract.authenticate("ethernaut0")

// then submit it