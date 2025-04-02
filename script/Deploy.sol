// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "../src/SimpleToken.sol";
import "../src/TokenFactory.sol";

contract Deploy is Script {

    function run() external {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        SimpleToken simpleToken = new SimpleToken();

        TokenFactory tokenFactory = new TokenFactory (
            address(simpleToken),
            deployer,
            0
        );

        console.log("SimpleToken deployed at: ", address(simpleToken));
        console.log("TokenFactory deployed at: ", address(tokenFactory));

        vm.stopBroadcast();
    }
}