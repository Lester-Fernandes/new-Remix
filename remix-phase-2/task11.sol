// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract SparseArrayBehaviorVul {

    uint256[] public numbers;

    function addNumber(uint256 _number) public {
        numbers.push(_number);
    }

    function deleteItem(uint256 _index) public {
        delete numbers[_index];
    }

    function getArray()public view returns (uint256[] memory){
        return numbers;
    }

    function getLength() public view returns (uint256) {
        return numbers.length;
    }
}
*/

contract SparseArrayBehavior {
    uint256[] public number;

    function addNumber(uint256 _number) public {
        number.push(_number);
    }

    function deleteItem(uint256 _index) public {
        require(_index < number.length,"Index out of bounds");

        for(uint256 i = _index; i < number.length - 1; i++) {
            number[i] = number[i + 1];
        }

        number.pop();
    }

    function getArray() public view returns (uint256[] memory) {
        return number;
    }

    function getLength() public view returns (uint256) {
        return number.length;
    }
}