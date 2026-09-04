// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StoreBooleanVul {

    bool public isActive;

    function setStatus(bool _status) public {
        isActive = _status;
    }

    function getStatus() public view returns (bool) {
        return isActive;
    }
}
*/
/*
Audit Report

Title: Missing Access Control in setStatus()

Severity: Medium

Location: Contract: StoreBooleanVul
          Function: setStatus()

Vulnerability Description: The setStatus() function allows any external user to change the isActive state variable

Impact: An attacker can arbitarily change the isActive status

Proof of Concept:
    1. Deploy the vulnerable StoreBooleanVul contract
    2. Initially, isActive if false
    3. User a calls: setStatuus(true)
    4. isActive becomes true
    5. An attacker calls: setStatus(false)
    6. The contract accepts the transaction
    7. isActive becomes false without authoization

Root Cause: The root cause is that setStatus() is declared public without any authorization check

Recommendation: Restrict status updates so that only the owner can change isActive

*/

contract StoreBoolean {
    bool public isActive;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setStatue(bool _status) public {
        require(msg.sender == owner,"Only the owner can change status");

        isActive = _status;
    }

    function toggleStatus() public {
        require(msg.sender == owner,"Only the owner can toggle status");

        isActive =!isActive;
    }

    function getStatus() public view returns (bool) {
        return isActive;
    }
}