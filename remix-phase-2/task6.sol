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