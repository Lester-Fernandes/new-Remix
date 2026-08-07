// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract returnEarly {
    function test(uint num) public pure returns(string memory) {
        if(num == 0){
            return "Number is Zero"; // Function stop here
        }
        return "Number is not zero"; // Function runs only if the number is not zero
    }
}