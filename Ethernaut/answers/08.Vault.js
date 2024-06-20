/*
    Must refer the Bonus part - PrivateStorages

    So this is quite an easy question and makes you aware of the fact that, private doesn't means your data is hidden in solidity, it just means that particular variable won't be accessible to any other contract

    So we gonna use the 'getStorageAt' method of web3 library and it's done!!
*/
// first initlialize the address of your target contract
addr = 'your contract address'

// Usually EVM stores the contract data in slots, like you can see first initialization is of variable 'locked' which takes just 1 byte space, so slot 0 contains variable locked, and in the case of bytes32 'password' it can't enter in slot0 as it requires 32 bytes and slot 0 just got 31 bytes left, so need to enter in another slot, slot1

// Now we will get storage of slot1
await web3.eth.getStorageAt(addr, 1) // param1 -> contract address, param2 -> slot value, param3 (optional) -> mostly contains calldata

// you will get a hexadecimal result, just copy that
await contract.unlock("yourHexadecimalResult")