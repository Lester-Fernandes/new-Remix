// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StorageReferenceVul {

    struct User {

        uint256 age;

        bool active;
    }

    mapping(address => User) public users;

    function createUser(uint256 _age) public {

        users[msg.sender] = User(_age, true);
    }

    function updateAge(uint256 _newAge) public {

        /*
            STORAGE REFERENCE VARIABLE

            This creates POINTER to actual storage.

            user is NOT copy.

            user directly references:
            users[msg.sender]
        
        User storage user = users[msg.sender];

        /*
            DIRECT STORAGE MUTATION

            Since user points to storage,
            this updates blockchain state directly.
        
        user.age = _newAge;
    }

    function deactivateUser() public {

        
            Another storage reference example
        
        User storage user = users[msg.sender];

        user.active = false;
    }

    function getMyData()
        public
        view
        returns (uint256, bool)
    {
        User storage user = users[msg.sender];

        return (user.age, user.active);
    }
}
*/

contract StorageReference {
    struct User {
    uint256 age;
    bool active;
    }

    mapping(address => User) public users;

    function createUser(uint256 _age) public {
        users[msg.sender] = User(_age, true);
    }

    function updateAge(uint256 _newAge) public {
        User storage user = users[msg.sender];

        user.age = _newAge;
    }

    function deactiveUser() public {
        User storage user = users[msg.sender];

        user.active = false;
    }

    function modifyMemoryCopy(uint256 _newAge) public view returns (uint256, bool) {
        User memory User = users[msg.sender]; // create temporary memory copy

        
        User.age = _newAge;
        User.active = false;

        return(User.age,User.active); // Reaturn modified temporary values
    }

    function getMyData() public view returns (uint256, bool) {
        User storage User = users[msg.sender];

        return(User.age, User.active);
    }
}