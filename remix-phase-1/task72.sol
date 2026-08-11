// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract restrictedFunction {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed"); // Only owner can continue
        _;
    }

    function secretFunction() public onlyOwner returns(string memory) {
        return "You are the owner";
    }
}