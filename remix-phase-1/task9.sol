// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract immutability {

    uint public constant Max = 100; // Constant variable cannot be changed after declaration

    /*

    This function world cause a comilation error because constant variables cannot be modified

        function change() public {
            MAX = 200;
        }

    */
}