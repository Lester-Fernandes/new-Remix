// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract withdrawmore {
 function deposit() public payable {}

 function withdraw(uint amount) public {
    require(amount <= address(this).balance," Not enough balance"); // chack enough ETH is available

    payable(msg.sender).transfer(amount);
 }
}