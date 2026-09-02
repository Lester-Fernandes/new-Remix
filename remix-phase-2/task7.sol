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