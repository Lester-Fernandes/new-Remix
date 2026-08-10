// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract multipleUser {
    struct User {
        string name;
        uint age;
    }

    mapping(address => User) public user; // Each address gets its own user struct

    function register( string memory _name, uint _age) public {
        user[msg.sender] = User(_name, _age); // Store data for the caller
    }
}