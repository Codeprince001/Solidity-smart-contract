
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 2e18;

    address[] public funders;
    mapping(address funders => uint256 amountFunded) public amountsFunded;

    function fund() public payable{
        require(msg.value.getConversionRate() >= minimumUsd, "Enter minimum value");
        funders.push(msg.sender);
        amountsFunded[msg.sender] = amountsFunded[msg.sender] + msg.value;
    }
}