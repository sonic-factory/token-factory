// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "../src/SimpleToken.sol";
import "../src/TokenFactory.sol";

contract Deploy is Script {

    function run() external {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // Insert Deploy logic here.

        vm.stopBroadcast();
    }
}