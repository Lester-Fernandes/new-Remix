// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract anyoneWithdraw {
    function deposit() public payable{} // deposit ETH

    function withdraw() public { // anyone can steal all ETH
        payable(msg.sender).transfer(address(this).balance);
    }

    function getbalance() public view returns(uint){
        return address(this).balance;
    }
}