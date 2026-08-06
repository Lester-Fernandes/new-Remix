// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract multipleDeposits {
    function deposit() public payable {} // deoisit ETH

    function balance() public view returns(uint){ // display the current ETH balance
        return address(this).balance;
    }
}