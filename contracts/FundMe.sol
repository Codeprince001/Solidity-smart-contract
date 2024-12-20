
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    error NewOwner();

    uint256 public constant MINIMUM_USD = 2e18;

    address public immutable i_owner;
    address[] public funders;
    mapping(address funders => uint256 amountFunded) public amountsFunded;

    constructor(){
        i_owner = msg.sender;
    }
    function fund() public payable{
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Enter minimum value");
        funders.push(msg.sender);
        amountsFunded[msg.sender] = amountsFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner{

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            amountsFunded[funder] = 0;
        }
        funders = new address[](0);
        // actually withdraw fund:
        // transfer
        // payable (msg.sender).transfer(address(this).balance);
        // send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");
        // call
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner){revert NewOwner();}
        _;
    }

    // someone send eth without calling the fund function
    receive() external payable {
        fund();
     }

    // someone sends eth with data, without calling the fund function
     fallback() external payable { 
        fund();
     }
}