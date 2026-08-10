// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract UpdateStruct {
    struct User {
        string name;
        uint age;
    }

    User public user;

    function setUser(string memory _name, uint _age) public {
        user = User(_name, _age);
    }

    function updateAge(uint _newAge) public { // only change the age of the user
        user.age = _newAge;
    }
}
