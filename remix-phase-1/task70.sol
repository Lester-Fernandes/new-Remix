// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SttructFields {
    struct User {
        string name;
        uint age;
        bool active;
    }

    User public user;

    function setUser(string memory _name, uint _age) public {
        user = User(_name, _age, true);
    }

    function getName() public view returns(string memory) { // Access only the name field
        return user.name;
    }

    function getAge() public view returns(uint) { // Access only the age field
        return user.age;
    }

    function getActive() public view returns(bool) { // Access only the active field
        return user.active;
    }
}