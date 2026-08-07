// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ifelseExample {
    function checknumber(uint num) public pure returns(string memory) {
        if(num >= 50) {
            return "pass";
        }else{
            return "fail";
        }

    }
}