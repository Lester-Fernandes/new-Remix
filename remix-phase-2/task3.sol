// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StoreAddressVul {

    address public userAddress;

    function storeAddress(address _newAddress) public {
        userAddress = _newAddress;
    }

    function getAddress() public view returns (address) {
        return userAddress;
    }
}

*/

contract StoreAddress {
    address public userAddress;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function storeAddress(address _newAddress) public {
        require(msg.sender == owner,"Only the owner can update the address"); // only the owner can update

        require(_newAddress != address(0),"Zero address not allowed"); // Zero address is rejected 

        userAddress = _newAddress;
    }

    function getAddress() public view returns (address) {
        return userAddress;
    }
}