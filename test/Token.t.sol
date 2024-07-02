// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";
import {DeployToken} from "../script/DeployToken.s.sol";

contract TokenTest is Test {

    Token token;
    DeployToken deployer;

    address public owner = makeAddr("owner");
    address public userOne = makeAddr("userOne");
    address public userTwo = makeAddr("userTwo");

    function setUp() external {
        deployer = new DeployToken();
        token = deployer.run();
    }

    function testBalanceOfDeployer() external view{
        assertEq(token.balanceOf(owner), 100e18);
    }

    function testTransferfunction() external {
        vm.startPrank(userOne);
        token.transfer(userTwo, 10e18);
        assertEq(token.balanceOf(userTwo), 10e18);
        assertEq(token.balanceOf(userOne), (type(uint256).max - 10e18) + 1);
        vm.stopPrank();

        console.log("Balance of User1: ", token.balanceOf(userOne));
        console.log("Balance of User2: ", token.balanceOf(userTwo));
    }

}