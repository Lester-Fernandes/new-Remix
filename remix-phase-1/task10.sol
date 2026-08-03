// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract constructorstate {
    address public immutable owner; // Immutable variable can only be assigned once

    constructor(){
        owner = msg.sender; // Store the deployers's address
    }
}