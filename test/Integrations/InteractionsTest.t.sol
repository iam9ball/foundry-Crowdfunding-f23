// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {DeployCrowdFunding} from "../../script/DeployCrowdFunding.s.sol";
import {CrowdFunding} from "../../src/CrowdFunding.sol";
import {FundMeCrowdFunding,  WithdrawCrowdFunding} from "../../script/Interactions.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract InteractionsTest is Test {
    CrowdFunding crowdFunding;
    HelperConfig helperConfig;

     uint256 constant SEND_VALUE = 0.1 ether;
   
     function setUp () public {
       DeployCrowdFunding deployCrowdFunding = new DeployCrowdFunding();
       (crowdFunding, helperConfig) = deployCrowdFunding.run();
    
 }


     function testInteractionsFund() public {
        FundMeCrowdFunding fundMeCrowdFunding = new FundMeCrowdFunding();
        
         fundMeCrowdFunding.fundMe(address(crowdFunding), SEND_VALUE);
        assertEq(address(crowdFunding).balance, 0.1 ether);

         WithdrawCrowdFunding withdrawCrowdfunding = new  WithdrawCrowdFunding();

         withdrawCrowdfunding.withdrawCrowdFunding(address(crowdFunding));
         assertEq(address(crowdFunding).balance, 0);


     }
     
}