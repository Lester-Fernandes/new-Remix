// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract storesender {
    address public sender; // store the address of the person who call the function

    function save() public {
        sender = msg.sender; // msg.sender address of the caller
    }
}