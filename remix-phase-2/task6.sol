// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract profileStorage {
    struct profile {
        string name;
        uint256 age;
        bool verified;
    }

    mapping(address => profile) public profiles;

    function saveProfile(string calldata name, uint256 age, bool verified) external {
        profiles[msg.sender] = profile({
            name: name,
            age: age, 
            verified: verified
        });
    }

    function getProfile(address user) external view returns (string memory, uint256, bool) {
        profile memory profile = profiles[user];

        return(profile.name, profile.age, profile.verified);
    }
}