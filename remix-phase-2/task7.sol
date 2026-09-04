// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract ArrayStorageVul {

    uint256[] public numbers;

    function addNumber(uint256 _number) public {
        numbers.push(_number);
    }

    function getNumber(uint256 _index)
        public
        view
        returns (uint256)
    {
        return numbers[_index];
    }

    function getLength() public view returns (uint256) {
        return numbers.length;
    }
}
*/

/*
Audit Report

Title: Unrestricted Array Growth in addNumber()

Severity: Low

Location: Contract: ArrayStorageVul
          Function: addNumber()

Vulnerability Description: The vulnerable contract allows any external user to call addNumber() and append a new value to the number array

Impact: An attacker can repeatedly call addNumber() and continuously increase the size of the storage array

Proof of Concept:
    1. Deploy the vulnerable ArrayStorageVul contract
    2. Call: addNumber(10)
    3. The array becomes:[10]
    4. Call: addNumber(20)
    5. The array becomes: [10, 20]
    6. An attacker can continuw calling addNumber() repeatedly
    7. The array length coninues to increases without resriction

Root Cause: The root cause is that addNumber() is declared public and contains no access-control or array-size validation

Recommendation: If the array should only be modified by authorized users, implement access control before allowing new value to be added



*/


contract ArrayStorage {
    uint256[] public numbers;

    function addNumber(uint256 _number) public {
        numbers.push(_number); // Adds a new value to the end of the array
    }

    function removeNumber() public {
        require(numbers.length > 0, "Array is empty"); // The array should contain at least one element

        numbers.pop(); // Remove the last element
    }

    function getNumber(uint256 _index) public view returns (uint256) {
        return numbers[_index];
    }

    function getLength() public view returns (uint256) {
        return numbers.length;
    }
}