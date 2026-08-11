// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract modifierOrder {
    address public owner;
    bool public active = true;

    constructor() {
        owner = msg.sender;
    }

    modifier first() { // This happens first
        require(active, "Contract is inactive");
        _;
    }

    modifier secound() { // This happens second
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function test() public first secound {} // first runs before second
}