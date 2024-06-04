/*
    Quite Straightforward, just a copy paste of the question code in either your IDE or remix, and you will get the shit happening..

    Well, let's just deep dive into this contract..

    First vulnerability is quite clear, you can see that when the `Donations donation` is initialized, it wasn't defined by storage/memory. Usually, storage is by default..But that leads to a problem, this gives it the power to overwrite the storage slots.

    Thus, in the code below

    ```
    function donate(uint256 etherAmount) public payable {
        // amount is in ether, but msg.value is in wei
        uint256 scale = 10**18 * 1 ether;
        require(msg.value == etherAmount / scale);

        Donation donation;
        donation.timestamp = block.timestamp;
        donation.etherAmount = etherAmount;

        donations.push(donation);
    }
    ```

    Here, line 17 and 18, kind of overwrites the slot 0 and 1 of the contract storage..and on slot 1 there's our owner's address..

    Thus, now we need to just overwrite the slot 1 with our address..

    For that, you need to convert your address in the form -> uint256(uint160(<your-address>))
    Now, we need to pass a some ether into it..but wait, now this costs a lot of ether when divided by `scale`, and here's the second vulnerability..

    Actually, value of scale is not 10**18, it's actually 10**18 * 10**18. Thus we can calculate the value of msg.value using 'uint256(uint160(<your-address>)) / scale'

    and then the owner will be our address, and we be able to call the withdraw function!
*/