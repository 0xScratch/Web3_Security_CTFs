/*
    Kind of easy one, if you really know how to access the storages and the way to manipulating it if the code contains any vulnerability. Well this question be well descripted down on the original 'Capture the Ether' challenge, cuz most of the changes have been done in the latest solidity versions regarding this. Sharing the link -> https://capturetheether.com/challenges/math/mapping/

    Let's deep dive in this:

    Prerequisites: Must get familiar about solidity storage slots, how it stores data and how data from different datatypes are been stored in these slots

    Now, there was a weird thing with this challenge contract, there wasn't any function or way to change the `isComplete` boolean value. Well that strucked me too!

    So, we need to find a way such that this `isComplete` boolean value can be changed to true

    Now, we being using a dynamic array in this code, and if you be well aware that dynamic arrays don't keep up their elements in a direct slot order as static arrays, these just assign the slots quite differently. But here we are more keen to the fact that, this dynamic array can even cover up the whole solidity storage allocated to any smart contract if by chance some attacker tries to manipulate the storage slots.

    Notice the function `set()` and the way it contains the code line ->   
        if (map.length <= key) {
            map.length = key + 1;
        }

    if we mark the key as the max_uint-1, then the map.length will be max_uint, and thus it will extend the whole storage under that dynamic array,

    Now, we need to find the slot of `isComplete`, remember these slots are won't be exactly at their original positions like in the storage earlier, their slots will be changed just due to the fact that dynamic arrays calculate slots for a particular value in different way, right now we just know that the length of dynamic array will be stored at slot 1, and isComplete was just before it earlier, so now it will become at index -> 2^256 - keccak(1), which gave us the key or slot of our `isComplete` boolean..now just use that `set` function and change it's value..
*/