/*
    Same as the previous one, but this time we have to really take the benefit of vulnerability and steal out 1000000
    Yeah, as last time it's easy to guess that this is kind of unchecked (overflow or underflow) one, but the clever thing is, where the vulnerability is..cuz this code looks quite perfect on the first look.

    There's a thing in code auditing, most of the times the vulnerability is not in the expected paths..it's always kind of hidden from most of the people otherwise why it be a vulnerability in the first case. Ain't it?

    So, let's see how we can exploit this vulnerability and steal out 1000000

    You must have gone through the whole code and by far is mostly aware of what all these functions do.

    Let's go through this scenario:
        Option 1.

            Account A calls transfer(B, any value <= acc. A's balance);
        Option 2.

            Account A calls approve(B, value);.
            Account B calls transferFrom(A, B, value < previously approved value);
    
    But these are expected paths, and you won't be finding any problem with them, the basic vulnerability is found in the `_transfer` function, which doesn't have any checks for the value.

    Now, let's try this approach:
        1. Account A calls transfer(B, 510);
        2. Account B calls approve(A, 1000);
        3. Account A calls transferFrom(B, B, 500);
    
    Let's dive into each step:
        1. Here Account A already have 1000 in it's balance and after calling the function, Account A -> 490, Account B -> 510
        2. Here Account B calls approve 1000 which is more than it's capacity and this works due to a check vulnerability in transferFrom function. That means Allowance[B][A] = 1000, where B is msg.sender and A is spender
        3. Now, here the magic happens, 
            a. require(balanceOf[from] >= value); -> this check passed as balanceOf[B] is 510 which is greater than 500
            b. require(balanceOf[to] + value >= balanceOf[to]); -> this checks passed too, as balanceOf[B] is 510 and balanceOf[B] + value(500) > balanceOf[B]
            c. require(allowance[from][msg.sender] >= value); -> this check also passed, as Allowance[B][B] = 1000, which is greater than 500

            d. allowance[from][msg.sender] -= value; -> here Allowance[B][B] is decreased by 500
            e. _transfer(to, value);
                i. balanceOf[msg.sender] -= value; -> here the shit happens, balance of A is 490, and value is 500..which created a underflow situation..and our balance of A becomes a lot more than 1000000

    Cheers!!
*/
