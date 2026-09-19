// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract VulnerableBankVul {

//     mapping(address => uint256) public balance;

//     /*
//     =====================================================
//     DEPOSIT ETH
//     =====================================================
//     */

//     function deposit() external payable {
//         balance[msg.sender] += msg.value;
//     }

//     /*
//     =====================================================
//     WITHDRAW ETH (VULNERABLE)
//     =====================================================
//     */

//     function withdraw(uint256 amount) external {

//         /*
//         STEP 1:
//         Check balance
//         */
//         require(balance[msg.sender] >= amount, "Not enough balance");

//         /*
//         STEP 2:
//         EXTERNAL CALL FIRST ❌ (DANGER)
//         */
//         (bool success, ) = msg.sender.call{value: amount}("");
//         require(success, "Transfer failed");

//         /*
//         STEP 3:
//         STATE UPDATE AFTER CALL ❌ (ROOT ISSUE)
//         */
//         balance[msg.sender] -= amount;
//     }

//     /*
//     =====================================================
//     VIEW BALANCE
//     =====================================================
//     */

//     function getBalance(address user)
//         external
//         view
//         returns (uint256)
//     {
//         return balance[user];
//     }
// }

