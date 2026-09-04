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

/*

Audit Report

Title: Missing Access Control and Zero Address Validation in storeAddress()

Severity: Medium 

Location: Contract: StoreAddressval
          Function: storeAddress()
        
Vulnerability Description: The storeAddress() function directly assigns the supplied _newAddress to the userAddress state variable

Impact: An attacker can overwrite the stored address with an address of their choice

Proof of Concept: 
    1. Deploy the vulnerable storeAddressVal contract
    2. User A calls: storeAddress(0x12345...)
    3. The address is stored successfully
    4. Attacker calls: storeAddress(0x6789....)
    5. The contract accepts the transaction
    6. userAddress is changed to the attacker's supplied address

Root Cause: The root cause is that storeAddress() is declared public without any authorization check

Recommendation: Restrict the function so that only the contract owner can update userAddress


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