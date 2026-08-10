// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract StructMapping {
    struct User {
        string name;
        uint age;
        bool active;
    }

    mapping(address => User) public user; // Address -> User data

    function setUser( string memory _name, uint _age) public { // store the using the caller's address
        user[msg.sender] = User(_name, _age, true);
    }
}