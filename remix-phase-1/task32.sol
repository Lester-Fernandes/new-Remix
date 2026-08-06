// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract balance {
    function deposit() public payable {} // Deposit ETH

    function getbalance() public view returns(uint) { // Check contract balance
        return address(this).balance;
    }
}