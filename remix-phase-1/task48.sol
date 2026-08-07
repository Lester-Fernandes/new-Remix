// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract requireMessage {
    function login(string memory password) public pure returns(string memory) {
        require(bytes(password).length > 5, "Password is too short"); // Password length must be greater than 5
        
        return "Login Successful";
    }
}