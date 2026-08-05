// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract time {
 uint public currenttime; // store the current block time

 function savetime() public {
    currenttime = block.timestamp; // current block timestamp
 }   
}