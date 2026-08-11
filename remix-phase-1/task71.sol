// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract OnlyOwner {
    address public owner;

    constructor() { // Set the deployer as the owner
        owner = msg.sender;
    }

    modifier onlyOwner() { // Modifier checks if caller is the owner
        require(msg.sender == owner, "Not the owner"); 
        _; // Function runs here
    }

    function changeOwner(address _newOwner) public onlyOwner { // Only the owner can call this function
        owner = _newOwner;
    }
}