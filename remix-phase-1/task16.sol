// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract purefunction { // pure function does not read or modify data
    function multiply(uint a, uint b) public pure returns(uint) {
        return a * b;
    }
}