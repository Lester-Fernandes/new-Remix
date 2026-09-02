// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract deleteArray {
    uint256[] public number;

    function addnumber(uint256 value) external {
        number.push(value);
    }

    function deleteItem(uint256 index) external {
        require(index < number.length,"Invalid index");

        delete number[index];
    }

    function getLength() external view returns (uint256) {
        return number.length;
    }
}