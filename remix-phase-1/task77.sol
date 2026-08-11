// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract protected {
    address public owner;
    uint public secretNumber;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");

        _;
    }

    function secSecret(uint _number) public onlyOwner { // Protected function
        secretNumber = _number;
    }
}