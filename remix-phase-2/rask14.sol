// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StateMutationVul {

    uint256 public value;

    function updateValue(uint256 _newValue) public {

        value = _newValue;
    }

    function increaseValue(uint256 _amount) public {

        value = value + _amount;
    }

    function getValue() public view returns (uint256) {

        return value;
    }
}

*/

contract StateMutation {

    address public owner;

    uint256 public value;

    event ValueUpdate(address indexed updater, uint256 oldvalue, uint256 newValue);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyowner() {
        require(msg.sender == owner,"Only owner can modify state");
        _;
    }

    function updateValue(uint256 _newValue) public onlyowner {
        uint256 oldvalue = value; // Save the old value before changing storage

        value = _newValue;

        emit ValueUpdate(msg.sender, oldvalue, _newValue);
    }

    function increaseValue(uint256 _amount) public onlyowner {
        uint256 oldvalue = value; // Save the old value

        value = value + _amount; // Modify storage

        emit ValueUpdate(msg.sender, oldvalue, value); 
    }

    function getvalue() public view returns (uint256) {
        return value;
    }
}