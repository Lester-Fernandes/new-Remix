// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract constructorstate {
    address public immutable owner;

    constructor(){
        owner = msg.sender;
    }
}