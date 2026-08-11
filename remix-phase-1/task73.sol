// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract multipleModifiers {
    address public owner;
    bool public active = true;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() { // First modifier
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier whenActive() { // Second modifier
        require(active == true, "Contract is not active");
        _;
    }

    function secret() public view onlyOwner whenActive returns(string memory) { // Both modifiers are used
        return "Function executed";
    }
}