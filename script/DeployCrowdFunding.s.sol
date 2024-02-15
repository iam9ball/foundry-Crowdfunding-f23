
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol"; 
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

uint256 constant FUNDING_GOAL = 100E18;
uint256 constant CAMPAIGN_DURATION = 1708094597;



contract DeployCrowdFunding is Script {

    function run() external returns(CrowdFunding, HelperConfig) {
  
      HelperConfig helperConfig = new HelperConfig();
      address priceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        CrowdFunding crowdFunding = new CrowdFunding(FUNDING_GOAL, CAMPAIGN_DURATION, priceFeed);
        vm.stopBroadcast();
        return (crowdFunding, helperConfig);

    }

}
