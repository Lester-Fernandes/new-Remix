// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DeleteStruct {
struct User{
    string name;
    uint age;
    bool active;
}

User public user;

function setUser(string memory _name, uint _age) public {
    user = User(_name, _age, true);
}

function deleteUser() public { // delete the entire struct
    delete user;
}
}