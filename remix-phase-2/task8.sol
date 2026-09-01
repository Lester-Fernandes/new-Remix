// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LimitedArray {
    uint256[] public number;

    uint256 public constant MAX_LENGTH = 10;

    function MultipleValues(uint256 first, uint256 secound, uint256 third) external {
        require(number.length + 3 <= MAX_LENGTH, "Array limit reached");

        number.push(first);
        number.push(secound);
        number.push(third);
    }

    function getLength() external view returns (uint256) {
        return number.length;
    }

    function getvalue(uint256 index) external view returns (uint256) {
        require(index < number.length, "Invalid index");

        return number[index];
    }
}