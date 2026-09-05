// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract MentalExecutionTracingVul {

//     /*
//         STORAGE VARIABLES

//         Persist permanently on blockchain.
//     */
//     uint256 public totalBalance;

//     mapping(address => uint256) public balances;

//     /*
//     =====================================================
//     DEPOSIT FUNCTION
//     =====================================================
//     */

//     function deposit(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             Validate amount.
//         */
//         require(
//             _amount > 0,
//             "Invalid amount"
//         );

//         /*
//             STEP 2:
//             Read current balance from storage.

//             balances[msg.sender]
//             initially may be 0.
//         */
//         uint256 currentBalance =
//             balances[msg.sender];

//         /*
//             STEP 3:
//             Add deposit amount.
//         */
//         uint256 newBalance =
//             currentBalance + _amount;

//         /*
//             STEP 4:
//             Update storage mapping.
//         */
//         balances[msg.sender] =
//             newBalance;

//         /*
//             STEP 5:
//             Update total system balance.
//         */
//         totalBalance =
//             totalBalance + _amount;
//     }

//     /*
//     =====================================================
//     WITHDRAW FUNCTION
//     =====================================================
//     */

//     function withdraw(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             Read user balance from storage.
//         */
//         uint256 userBalance =
//             balances[msg.sender];

//         /*
//             STEP 2:
//             Ensure enough balance exists.
//         */
//         require(
//             userBalance >= _amount,
//             "Insufficient balance"
//         );

//         /*
//             STEP 3:
//             Subtract withdrawal amount.
//         */
//         uint256 updatedBalance =
//             userBalance - _amount;

//         /*
//             STEP 4:
//             Save updated balance.
//         */
//         balances[msg.sender] =
//             updatedBalance;

//         /*
//             STEP 5:
//             Reduce total system balance.
//         */
//         totalBalance =
//             totalBalance - _amount;
//     }
// }

contract MentalExecutionTracing {
    uint256 public totalBalance;

    mapping(address => uint256) public balances;

    function deposit(uint256 _amount) public {
        require(_amount > 0,"Invalid amount");

        uint256 currentBalance = balances[msg.sender];

        uint256 newBalance = currentBalance + _amount;

        balances[msg.sender] = newBalance;

        totalBalance = totalBalance + _amount;
    }

    function withdraw(uint256 _amount) public {
        uint256 userBalance = balances[msg.sender];

        require(userBalance >= _amount,"Insufficient balance");

        uint256 updateBalance = userBalance - _amount;

        balances[msg.sender] = updateBalance;

        totalBalance = totalBalance - _amount;

    }

    function executeTrace() public {
        deposit(500);

        withdraw(200);

        deposit(50);
    }

    function getTraceResult() public view returns (uint256 userBalance, uint256 systemBalance) {
        userBalance = balances[msg.sender];
        systemBalance = totalBalance;
    }
}