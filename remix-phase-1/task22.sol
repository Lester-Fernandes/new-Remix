// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract comparsender {
    address public caller; // store the address of the person who call the function

    function update() public {
        caller = msg.sender; // save the caller address
    }
}