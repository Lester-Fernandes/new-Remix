// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract nestedIf {
    function check(uint age, uint marks) public pure returns(string memory) {
        if(age >= 18) {
            if (marks >= 50) {
                return "Selected";
            } else {
                return "Failed in Marks";
            }
        }else {
            return "Under Age";
        }
    }
}