// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StateOverwriteVul {

    uint256 public number;

    function updateNumber(uint256 _newNumber) public {
        number = _newNumber;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
*/

contract StateOverwrite {
    uint256 public number; // Current Value

    uint256 public previousNumber; // Stores the value before the most recent update

    function updateNumber(uint256 _newNumber) public { 
        previousNumber = number;

        number = _newNumber;
    }

    function getNumber() public view returns (uint256) {
        return previousNumber;  
    }
}