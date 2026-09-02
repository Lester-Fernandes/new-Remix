// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract deleteMapping {
    mapping(address => bool) public listed;

    function add(address user) external {
        require(user != address(0),"Invalid address");

        listed[user] = true;
    }

    function remove(address user) external {
        require(user != address(0),"Invalid address");

        delete listed[user];
    }

}