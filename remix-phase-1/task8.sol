// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract storagevsmemory {

    uint public statevalue = 10;

    function compare() public view returns(uint, uint) {
        uint localvalue = 100;
        
        return(statevalue, localvalue);
    }
}