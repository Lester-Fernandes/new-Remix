// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract onlyowner {
    address public owner;

    constructor() { // constructor only runs once when the smart contract is deployed
        owner = msg.sender;
    }

    function call() public view returns(string memory) {
        require(msg.sender == owner,"Not the owner"); // only owner can call this function

        return "Welcome Owner";
    }
}