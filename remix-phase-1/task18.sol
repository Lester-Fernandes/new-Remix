// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract multiplevalue {
    function data() public pure returns(uint, bool, string memory) {
        return(100, true, "Lester");
    }
}