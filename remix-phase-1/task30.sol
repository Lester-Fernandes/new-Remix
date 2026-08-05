// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract log {
    event payment(address sender, uint amount); // events stores information in the transaction log

    function sendEther() public payable {
        emit payment(msg.sender, msg.value); // save sender and ETH amount in the event log
    }
}