// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract DebugExecutionTracing {

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//         GLOBAL TOTAL
//     */
//     uint256 public totalDeposits;

//     /*
//         BONUS TRACKER
//     */
//     mapping(address => uint256) public bonuses;

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
//             LINE A:
//             Validation
//         */
//         require(
//             _amount > 0,
//             "Invalid amount"
//         );

//         /*
//             LINE B:
//             Balance update
//         */
//         balances[msg.sender] += _amount;

//         /*
//             LINE C:
//             Bonus calculation
//         */
//         bonuses[msg.sender] =
//             balances[msg.sender] / 10;

//         /*
//             LINE D:
//             Global accounting
//         */
//         totalDeposits += _amount;
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
//             LINE E:
//             Balance check
//         */
//         require(
//             balances[msg.sender] >= _amount,
//             "Insufficient balance"
//         );

//         /*
//             LINE F:
//             Balance reduction
//         */
//         balances[msg.sender] -= _amount;

//         /*
//             LINE G:
//             Global accounting update
//         */
//         totalDeposits -= _amount;
//     }

//     /*
//     =====================================================
//     VULNERABLE FUNCTION
//     =====================================================
//     */

//     function vulnerableReward(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             LINE H:
//             Reward uses OLD balance
//         */
//         bonuses[msg.sender] =
//             balances[msg.sender] / 10;

//         /*
//             LINE I:
//             Balance updated later
//         */
//         balances[msg.sender] += _amount;
//     }
// }

