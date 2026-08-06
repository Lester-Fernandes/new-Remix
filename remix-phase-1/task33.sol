// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract withdrawETH {
    function deposit() public payable {} // Deposit ETH

    function withdraw() public { // Withdraw all ETH to the caller
        payable(msg.sender).transfer(address(this).balance);
    }
}