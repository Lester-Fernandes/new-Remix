// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract multiplerequire {
    function register(uint age, uint marks) public pure returns(string memory) {
        require(age >= 18,"Age must be above 18"); // checks if the age is 18 or above

        require(marks >= 50,"Marks must be at least 50"); // checks if the marks are 50 or above

        return "Registration Successful";
    }
}