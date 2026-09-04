// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract UserStorageVul {

    mapping(address => uint256) public balances;

    function storeValue(uint256 _amount) public {
        balances[msg.sender] = _amount;
    }

    function getMyValue() public view returns (uint256) {
        return balances[msg.sender];
    }
}
*/

/*
Audit Report

Title: Unrestricted Overwrite of User Balance

Severity: Medium

Location: Contract: UserStorageVal
        Function: storeValue()

Vulnerability Description: The storeValue() function directly assigns the supplied _amount to balances[msg.sender]

Impact: A user can arbitrarily decrease or overwrite their stored balance

Proof of Concept:
    1. Deploy the vulnerable userStorageVul contract
    2. User calls: storeValue(100)
    3. balances[msg.sender] become 100
    4. User calls: storeValue(20)
    5. balances[msg.sender] becomes 20
    6. The previous value 100 is overwritten

Root Cause: The root cause is that storeValue() directly assigns _amount to the user's mapping entry without validating
            the new value aganst the existing balance


Recommendation: Validate that the new balance is greater than the user's existing balance before updating the mapping


*/

contract userBalance {
    mapping(address => uint256) public balance;

    function increaseBalance(uint256 amount) external {
        require(amount > balance[msg.sender],"value must increase");

        balance[msg.sender] = amount;
    }

    function getBalance(address user) external view returns (uint256) {
        return balance[user];
    }
}