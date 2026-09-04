// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/*
contract StructStorageVul {

    struct User {

        string name;

        uint256 age;

        address wallet;

        bool isActive;
    }

    User public user;

    function storeUser(
        string memory _name,
        uint256 _age,
        address _wallet,
        bool _isActive
    ) public {

        user = User(_name, _age, _wallet, _isActive);
    }

    function getUser()
        public
        view
        returns (
            string memory,
            uint256,
            address,
            bool
        )
    {
        return (
            user.name,
            user.age,
            user.wallet,
            user.isActive
        );
    }
}
*/
/*
Audit Report

Title: Shared Struct Storage and Unrestricted User Data Overwrite

Severity: Medium

Location: Contract: StructStorageVul
          Function: storeUser()

Vulnerability Description: The vulnerable contract store user inormation is a single global struct

Impact: An attacker can overwrite the profile information stored by another user

Proof of Concept: 
    1. Deploy the vulnerable StructStorageVul contract
    2. User a calls: storeUser("Lester", "21", addressA, true)
    3. The global user struct contains Lester information
    4. User B calls: storeUser("Bob", 100, addressB, false)
    5. The contract overwrites the existing struct
    6. The stored profile now contains Bob's information
    7. Lester's previously stored profile is no longer available

    Root Cause: The root cause is the user of a single global user storage variable

    Recommendation: Store each user's profile using a mapping keyed by the user's address

*/


contract StructStorage { // Stores profile information
    struct User {
        string name;
        uint256 age;
        address wallet;
        bool isActive;
    }

    mapping(address => User) public profiles;

    function storeUser(string memory _name, uint256 _age, bool _isActive) public { // msg.sender automatically identifies the user
        profiles[msg.sender] = User(_name, _age, msg.sender, _isActive);
    }

    function getUser(address _user) public view returns (string memory, uint256, address, bool) { // Anyone can read a profile
        User memory profile = profiles[_user];

        return(profile.name, profile.age, profile.wallet, profile.isActive);
    }

    function getProfile() public view returns (string memory, uint256, address, bool) { // Returns the profile belonging to msg.sender
        User memory profile = profiles[msg.sender];

        return(profile.name, profile.age, profile.wallet, profile.isActive);
    }
}