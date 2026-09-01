// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract storeuint {
    uint private number; // number is the state variable

    function save(uint256 value) external { // save modifies the value
        number = value;
    }

    function read() external view returns (uint256) { // read retrives the stored value
        return number;
    }

}