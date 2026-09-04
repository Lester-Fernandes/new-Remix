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

/*

Audit Report

Title: State Overwrite without previous value preservation

Severity: Low

Location: Contract: StateOverwriteVul
	    Function: updateNumber()

Vulnerability Description: The updateNumber() function directly assigns _newNumber to the number state variable without storing the existing value first

Impact: The contract loses the previous state value after every update

Proof of Concept: 
1.	Deploy the vulnerable contract
2.	Call: updateNumber(100)
3.	Number becomes 100
4.	Call: updateNumber(200)
5.	Number becomes 200
6.	The previous value 100 is no longer stored by the contract

Root Cause: The root cause is that updateNumber() overwrites the number state variable directly

Recommendation: Store the current value in a separate state variable before updating number

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