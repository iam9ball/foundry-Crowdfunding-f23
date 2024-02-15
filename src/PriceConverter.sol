// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {AggregatorV3Interface} from '@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol';

library PriceConverter {
    
     function getPrice(address _priceFeed) internal view  returns(uint256)  {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(_priceFeed);
         (,int256 price,,,) = PriceFeed.latestRoundData();
         return uint256(price * 1e18); 
         
     }

     function getDecimal(address _priceFeed) internal view returns (uint8) {
         AggregatorV3Interface Decimal = AggregatorV3Interface(_priceFeed);
          return Decimal.decimals();
     }



     function getConversionRate(uint256 ETH_Amount, address _priceFeed) internal  view returns (uint256) {
         uint256 ETH_TO_USD = getPrice(_priceFeed);
         uint conversionRate = (ETH_Amount * ETH_TO_USD) / 1e18;
         return conversionRate; 
     }

     

}
