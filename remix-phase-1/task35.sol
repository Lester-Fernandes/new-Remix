// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract sendETH {
    function deposit() public payable {} // deposit ETH

    function sendeth(address payable receiver, uint amount) public { // This function sends ETH from one contract to another address
        receiver.transfer(amount);
    }
}