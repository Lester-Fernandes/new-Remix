// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract userStruct {
    struct User {
        string name;
        uint age;
    }

    User public user; // store one user

    function setUser(string memory _name, uint _age) public {
        user = User(_name, _age); // store the data
    }
}