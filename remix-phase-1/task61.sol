// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract structexample {
    struct user { // Struct groups different types of data together
        string Lester;
        uint age;
        bool active;
    }

    user public User; // Create a user variable
}