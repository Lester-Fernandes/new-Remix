// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract StateRollbackBehaviorVul {

//     /*
//         STORAGE VARIABLES

//         Persist permanently unless reverted.
//     */
//     uint256 public totalCounter;

//     mapping(address => uint256) public userCounter;

//     /*
//     =====================================================
//     UPDATE STATE BEFORE REQUIRE
//     =====================================================
//     */

//     function riskyIncrement(
//         uint256 _value
//     )
//         external
//     {

//         /*
//             STEP 1:
//             UPDATE STORAGE

//             State changes happen immediately
//             during execution.
//         */
//         totalCounter =
//             totalCounter + _value;

//         userCounter[msg.sender] =
//             userCounter[msg.sender] + _value;

//         /*
//             STEP 2:
//             REQUIRE CHECK

//             If this fails:
//             ALL earlier storage changes revert.
//         */
//         require(
//             _value <= 10,
//             "Value too large"
//         );
//     }

//     /*
//     =====================================================
//     SAFE VERSION
//     =====================================================

//     Validation first.
//     */

//     function safeIncrement(
//         uint256 _value
//     )
//         external
//     {

//         /*
//             VALIDATE FIRST
//         */
//         require(
//             _value <= 10,
//             "Value too large"
//         );

//         /*
//             UPDATE STATE AFTER VALIDATION
//         */
//         totalCounter =
//             totalCounter + _value;

//         userCounter[msg.sender] =
//             userCounter[msg.sender] + _value;
//     }
// }

contract StateRollbackBehavior {
    uint256 public totalCounter;

    mapping(address => uint256) public userCounter;

    function deposit(uint256 _value) external {
        require(_value > 0,"Invalid deposit");

        totalCounter = totalCounter + _value;

        userCounter[msg.sender] = userCounter[msg.sender] + _value;
    }

    function riskyWithdraw(uint256 _value) external {
        userCounter[msg.sender] - _value;

        totalCounter = totalCounter - _value;

        require(_value <= 10,"Withdrawal too large");
    }

    function safeWithdraw(uint256 _value) external {
        require(_value > 0,"Invalid withdrawal");

        require(_value <= 10,"Withdrawal too large");

        require(userCounter[msg.sender] >= _value,"Insufficient balance");

        userCounter[msg.sender] = userCounter[msg.sender] - _value;

        totalCounter = totalCounter -_value;
    }

    function getyBalance() external view returns (uint256) {
        return userCounter[msg.sender];
    }

    function getSystemBalance() external view returns (uint256) {
        return totalCounter;
    }
}