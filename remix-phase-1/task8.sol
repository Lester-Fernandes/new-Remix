// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract storagevsmemory {

    uint public statevalue = 10; // State variable stored permanently

    function compare() public view returns(uint, uint) { // Returns both state and local variables
        uint localvalue = 100; // Local variable exists only while function executes
        
        return(statevalue, localvalue);
    }
}