// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {CrowdFunding} from "../../src/CrowdFunding.sol";
import {DeployCrowdFunding} from "../../script/DeployCrowdFunding.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract CrowdFundingTest is Test {
    CrowdFunding crowdFunding;
    HelperConfig helperConfig;

    address User = makeAddr("User");
    uint256 constant STARTING_BALANCE = 0.1 ether;

    function setUp()  external {
     DeployCrowdFunding deployCrowdFunding = new DeployCrowdFunding();
     (crowdFunding, helperConfig) = deployCrowdFunding.run();
     vm.deal(User, STARTING_BALANCE);
     
        
    }

    function testMinimumUsdIsFive() public {
        assertEq(crowdFunding.MINIMUM_USD(), 5E8);
        
    }

    function testOwnerIsMsgSender() public {
        assertEq(crowdFunding.owner(), msg.sender);  
    }

    function testCampaignDurationNotPassed() public view {
      
        assert(crowdFunding.i_campaignDuration() > block.timestamp);
    }

    modifier timeNotPassed () {
         assert(crowdFunding.i_campaignDuration() > block.timestamp);
         _;
    }
    
    function testMinimumUsdIsLessThanMsgValue() public   {
        vm.expectRevert();
        crowdFunding.fundMe();
    }

   


    // function testFunderIsInDataStructure() public {
    //     vm.prank(User);
    //     crowdFunding.fundMe{value: 6e8}();
    //     testCampaignDurationNotPassed();
    //     address funder = crowdFunding.getFunders(0);
    //     assertEq(funder, User);

    //     uint256 funderToAmtFunded = crowdFunding.getFunderToAmtFunded(User);
    //     assertEq(funderToAmtFunded, 6e8);

    //     uint256 totalAmountFunded = crowdFunding.getTotalAmtFunded();
    //     assertEq(totalAmountFunded, 6e8);

    // }

    function testFunded() public timeNotPassed{
       
         uint256 startingAddressBalance = address(crowdFunding).balance;
        vm.prank(User);
        crowdFunding.fundMe{value: 6e8}();
         uint256 endingAddressBalance = address(crowdFunding).balance;
         assertEq(startingAddressBalance + 6e8, endingAddressBalance + startingAddressBalance);

    }

    modifier funded () {
         uint256 startingAddressBalance = address(crowdFunding).balance;
        vm.prank(User);
        crowdFunding.fundMe{value: 6e8}();
         uint256 endingAddressBalance = address(crowdFunding).balance;
         assertEq(startingAddressBalance + 6e8, endingAddressBalance + startingAddressBalance);
         _;
    }

    function testFunderIsInFundersArray() public funded {
       address funder = crowdFunding.getFunders(0);
       assertEq(User, funder);    
    }

    function testFunderIsInDataStructure() public funded {

        uint256 funderToAmtFunded = crowdFunding.getFunderToAmtFunded(User);
        console.log(funderToAmtFunded);
        assertEq(funderToAmtFunded, 6e8);


    }

    function testTotalAmtFunded() public funded {
        uint256 totalAmtFunded = crowdFunding.getTotalAmtFunded();
        
        assertEq(totalAmtFunded, 6e8);

    }

    function testWithdraw() public funded {

        address owner = crowdFunding.owner();
        uint256 startingOwnerBalance = owner.balance;
        uint256 startingContractBalance = address(crowdFunding).balance;
        
        vm.prank(owner);
        crowdFunding.withdraw();
        
        uint256 endingOwnerBalance = owner.balance;
          uint256 endingContractBalance = address(crowdFunding).balance;
         
        assertEq(endingContractBalance, 0);
        assertEq(startingOwnerBalance + startingContractBalance,endingOwnerBalance);

    }
}
   
// 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419