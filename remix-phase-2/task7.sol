// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract numberArray {
    uint256[] public number;

    function addNumber(uint256 value) external {
        number.push(value);
    }

    function removeNumber() external {
        require(number.length > 0, "Array is empty");

        number.pop();
    }

    function getLength() external view returns (uint256) {
        return number.length;
    }

    function getNumber(uint256 index) external view returns (uint256) {
        require(index < number.length, "Invalid index");

        return number[index];
    }
}