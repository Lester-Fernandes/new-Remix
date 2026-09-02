// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StoreUintVul {

    uint256 public number;

    function storeNumber(uint256 _newNumber) public {
        number = _newNumber;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}

*/

contract StoreUint {
    uint256 public number; // Store the number permanenty

    address public owner; // Address that is allowed to modifer the number

    constructor() { // Runs only once when the contract is deployed
        owner = msg.sender;
    }

    function storeNumber(uint256 _newNumber) public { 
        require(msg.sender == owner,"Only the owner can update"); // Only the owner can update the number;

        number = _newNumber;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}