// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract DynamicArrayGrowthVul {

    uint256[] public numbers;

    function addMultipleValues(uint256 _value1,uint256 _value2,uint256 _value3) public {
        numbers.push(_value1);
        numbers.push(_value2);
        numbers.push(_value3);
    }

    function getNumber(uint256 _index)public
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

contract DynamicArrayGrowth {
    uint256[] public number;

    uint256 public constant MAX_LENGTH = 10;

    function MultipleValues(uint256 _value1, uint256 _value2, uint256 _value3) public { // Adds three values to the array
        require(number.length + 3 <= MAX_LENGTH,"Array maximum length exceeded");

        number.push(_value1);

        number.push(_value2);

        number.push(_value3);
    }

    function getNumber(uint256 _index) public view returns (uint256) {
        return number[_index];
    }

    function getLength() public view returns (uint256) {
        return number.length;
    }
}