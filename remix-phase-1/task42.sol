// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract requireFail {
    function checkage(uint _age) public pure returns(string memory) {
        require(_age >= 18); // age must be at least 18

        return "Access Granted";
    }
}