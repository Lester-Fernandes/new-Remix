// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract updateuint {

uint public number;
uint public previousNumber;

function update(uint newNumber) public { // The old value is stored before the new value replaces it
    previousNumber = number;

    number = newNumber;
}

}