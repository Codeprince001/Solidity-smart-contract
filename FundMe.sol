
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

    function withdraw() public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            amountsFunded[funder] = 0;
        }
        funders = new address[](0);
        // actually withdraw fund:
        // transfer
        payable (msg.sender).transfer(address(this).balance);
        // send
        bool sendSuccess = payable (msg.sender).send(address(this).balance);
        require(sendSuccess, "Send Failed");
        // call
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");

    }
}