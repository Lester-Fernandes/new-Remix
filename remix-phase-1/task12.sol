// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract privatefunction { // private function can be used inside this contract
    function word() private pure returns(string memory) {
        return "Hello World";
    }

    function showword() public pure returns(string memory) { // public function calls the provate function
        return word();
    }
}