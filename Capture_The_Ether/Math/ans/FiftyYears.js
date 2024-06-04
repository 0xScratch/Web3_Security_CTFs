/*
    This is a kind of interesting one, and it be quite visible too where the vulnerability lies in the contract..

    Just this level is like the collaboration of past ones

    Let's deep dive:

    1. So, the prime vulnerability is with the code in the else block of `upsert()` function.
    2. They are referring to storage slots 0 and 1, that means contribution.amount value is equivalent to slot 0 which stores up the queue's length, and contribution.unlockTimestamp is equivalent to slot 1 which stores up the head.
    3. Now, the thing we gonna do is to transfer all the funds to us, but for this we need to pass the 2nd `require` check inside the function `withdraw` -> require(block.timestamp >= queue[index].unlockTimestamp);
    4. We can't pass this check directly, for this we have to make atleast one `queue.unlockTimestamp` inside the queue to be 0..Thus, this becomes kind of tricky..
    5. For this, we need to pass some value in that timestamp for the function `upsert`, it better be something to which if we add 1 day, that might get into overflow and turn into 0, by this we can pass the check on step 3
    6. Thus, we will pass -> upsert(1, 2**256 - 1 day)
        The contracts storage is now:

            Var	            Value
            queue.length	2
            head	        115792089237316195423570985008687907853269984665640564039457584007913129553536
            balance	        1
    7. Our head variable is a garbage value and we need to reset it to 0 so we can withdraw the first entry with the 1 ether amount. We chose the previously added queue item in a way such that it overflows the timestamp check when we call upsert a second time with timestamp = 0. This resets the head pointer to zero and pushes a queue item with a timestamp in the past.
    8. Now after passing -> upsert(2, 0)
        Our contracts storage becomes:
            Var	            Value
            queue.length	3
            head	        0
            balance	        3
    9. Also, make sure that sum of the total amount inside the instances of queues till now is -> 5, cuz  The contribution.amount = msg.value assignment writes to storage slot 0, where queue.length is stored. Then this contribution object with its actual values is pushed to the queue. An important thing to note is that because of the internal instruction order in the queue.push function, the queues length is first incremented, and then the queue entry is copied. As queue is just a struct pointer to storage slot 0 and 1, and storage slot 1, the queue's length, has been incremented, the queue entry's amount is actually msg.value + 1 - not msg.value as is written in the code.
    10. but the contract balance is still 3, now as we got the head value = 0, we can call the withdraw() function but it won't allow us that cuz the total amount will sum up to be 5, whereas actually balance gonna be 3, thus we can use the `selfdestruct` technique here which be done by you!

    Cheers!

*/