// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract receiveether {
    uint public amount; // store the amount send

    function deposit() public payable {
        amount = msg.value; // msg.value tell us how much ether the user send
    }
}