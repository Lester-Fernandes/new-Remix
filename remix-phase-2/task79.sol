// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract TxOriginAuthVul {

//     address public owner;

//     constructor() {
//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     DANGEROUS AUTH CHECK
//     =====================================================
//     */

//     function withdrawAll() external {

//         /*
//          BAD PRACTICE:
//         using tx.origin for authentication
//         */

//         require(tx.origin == owner, "Not owner");

//         payable(owner).transfer(address(this).balance);
//     }
//     /*
//     =====================================================
//     NORMAL DEPOSIT
//     =====================================================
//     */

//     function deposit() external payable {}
// }
