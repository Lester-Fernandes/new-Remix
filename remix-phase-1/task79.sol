// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ModifierFlow {
    address public owner;
    uint public number;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() { // Check Owner
        require(msg.sender == owner, "Not the Owner");

        _; // Function executes here

        number = number + 10; // This runs after the function
    }

    function increase() public onlyOwner {
        number = number + 5;
    }
}