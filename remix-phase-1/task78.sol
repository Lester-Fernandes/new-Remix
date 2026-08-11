// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract parameterModifier {
    uint public minimum;

    constructor () {
        minimum = 10;
    }

    modifier greaterThan(uint _number) { // Modifier accepts a number
        require(_number >= minimum, "Number is too small");

        _;
    }

    function checkNumber(uint _number) public greaterThan(_number) returns(string memory)
    {
        return "Number is vaid";
    }
}