// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract StatePersistenceVul {

    uint256 public counter;

    function increment() public {
        counter = counter + 1;
    }

    function setCounter(uint256 _value) public {
        counter = _value;
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }
}
*/

contract StatePersistence {

    uint256 public counter;

    uint256 public previousCounter;

    function increment() public {
        previousCounter = counter; // Save the current value before changing it

        counter = counter + 1; // Update the state
    }

    function setCounter(uint256 _value) public {
        previousCounter = counter; // Save old value before updating

        counter = _value; // Set new value
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }

    function getPreviousCounter() public view returns (uint256) {
        return previousCounter;
    }
}