
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FundMe {

    uint256 public minimumUsd = 5;
    function fund() public payable{
        require(msg.value >= minimumUsd, "Enter minimum value");
    }
}