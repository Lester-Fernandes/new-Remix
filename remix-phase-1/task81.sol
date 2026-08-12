// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReceiveExample {
    receive() external payable { // receive() runs when ETH is sent and there is No calldata

     }

     function getBalance() public view returns (uint) { // Check contract balance
        return address(this).balance;
     }
}