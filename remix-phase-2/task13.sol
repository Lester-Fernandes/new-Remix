// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
contract DeploymentResetVul {

    uint256 public number;

    function setNumber(uint256 _number) public {

        number = _number;
    }

    function getNumber() public view returns (uint256) {

        return number;
    }
}
*/

contract DeploymentReset {
    uint256 public number;

    address public deployer;

    uint256 public deploymentTimestamp;

    constructor() {
        deployer = msg.sender; // Store the deployer's address

        deploymentTimestamp = block.timestamp; // Store the depoyment timestamp
    }

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function getDeploymentInfo() public view returns (address, uint256) {
        return(deployer, deploymentTimestamp);
    }
}