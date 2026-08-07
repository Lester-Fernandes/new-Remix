// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract requireexample {
    function checkNumber(uint _number) public pure returns(string memory) { // user must enter a number greater than 10
        require(_number > 10);

        return "valid number";
    }
}