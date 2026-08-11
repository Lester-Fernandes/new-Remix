// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract nestedStruct {
    struct AddressInfo { // Address information
        string city;
        uint pin;
    }

    struct User { // User contrains AddressInfo
        string name;
        uint age;
        AddressInfo addressInfo;
    }

    User public user;

    function setUser(string memory _name, uint _age, string memory _city, uint _pin) public {
        user = User(_name, _age, AddressInfo(_city, _pin));
    }
}