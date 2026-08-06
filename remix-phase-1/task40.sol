// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract balanceChange {
    function deposit() public payable {} // allows user to send ETH

    function getBalance() public view returns(uint) { // return the current balance of the contract
        return address(this).balance;
    }

    function withdraw() public { // transfers the entire contract balance to the caller
        payable(msg.sender).transfer(address(this).balance);
    }
}