// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract VulnerableModifier {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier wrongOwner() {
        require(msg.sender != owner, "owner cannot call"); // This checks that the caller is Not the owner

        _;
    }

    function change() public wrongOwner { // This function is now available to non-owner
      
    }
}