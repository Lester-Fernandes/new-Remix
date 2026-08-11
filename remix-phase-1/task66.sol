// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract defaultStruct {
    struct User {
        string name;
        uint age;
        bool active;
    }

    User public user; // Struct is created but no values are assigned
}