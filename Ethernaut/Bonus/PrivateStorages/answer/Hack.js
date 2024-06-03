/*
    Well not basically a hack, just a way to get the storages, all you need to do is first interact with truffle or some private blockchain test thing like hardhat, ganache or whatever, just google it!!

    and you really need to get the contract address for this purpose
*/

addr = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"

// next we gonna find the data at slot 0, make sure at slot 0 we got a number uint256, so it gonna occupy the whole slot
num = web3.eth.getStorageAt(addr, 0, console.log) // -> returns something in bytes or hexadecimal format "0x0000.....0007b"
// Now we gonna convert it from hexadecimal notation to decimal notation, thus used 16
console.log(parseInt("0x7b", 16)) // 

// Now let's find the data from slot 1, which contains 3 data types, address -> 20bytes, bool -> 1byte, uint16 -> 2bytes
slot1 = web3.eth.getStorageAt(addr, 1, console.log) // it gonna return a hexadecimal number too, and all three types be listed in one, it's like "0x00...00[hexadecimal form of uint16][hexadecimal form of bool][hexadecimal form of address]"

// Let's find the data from slot 2, which is our password and it is private
slot2 = web3.eth.getStorageAt(addr, 2, console.log) // gives us a hexadecimal form and it's already in bytes form
console.log(web3.utils.toAscii(slot2)) // -> gives us our password in text form

// Slot 3, 4, 5 will easily get by the same method used above, cuz they are just 3 array elements stored in each slot taking 32bytes each

// Now let's figure out the dynamic arrays
// slot 6 will only contain the size of the array
slot6 = web3.eth.getStorageAt(addr, 6, console.log) // returns the size of array in the form of hexadecimals

// Now to get the data of the elements, we need to use the following method:
// - First find the keccak hash of 6
hash = web3.utils.soliditySha3({type: "uint", value: 6}) // returns the hash

// - This hash is the slot at which the first user resides, in particular id of first user, password gonna be in the next slot just after the id slot of first user
id1 = web3.eth.getStorageAt(addr, hash, console.log) // gives the id in hexadecimal format

// - Now increment the hash by 1 to get the password slot, make sure here increment doesn't meant hash + 1, you have to manually increase that hash by 1 as it's a hexadecimal form, for.e.g -> suppose the hash is '0xf6422....c0d3f", incrementing it by 1 becomes "0xf6422....c0d40"
// - Now after the hash is incremented and current hash becomes the slot of the password of first user
password1 = web3.eth.getStorageAt(addr, hash, console.log)

// For rest of the users, just increment the hash by 1 and you will get the damn slots of the others user's id and password

// Now let's jump to mapping thing, in which slot 7 gonna be empty, you can even check that using above methods
// Anyways the entries gonna be stored at keccak256(key, slot)
// 
web3.utils.soliditySha3({type: "uint", value: 0}, {type: "uint", value: 7})

// then for finding the storage data at that slot, apply the same thing
