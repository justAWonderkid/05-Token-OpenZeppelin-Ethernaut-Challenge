
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract DeployToken is Script {

    Token token;
    address public owner = makeAddr("owner");

    function run() external returns(Token) {
        vm.startBroadcast(owner);
        token = new Token(100e18);
        vm.stopBroadcast();
        return token;
    }

}