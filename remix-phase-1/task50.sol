// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract skipLogic {
    uint public total;

    function addnum(uint num) public {
        if(num == 0){ // If number is 0 then the function will stop
            return;
        }
        total = total + num; // This will run only if the number is not 0
    }
}