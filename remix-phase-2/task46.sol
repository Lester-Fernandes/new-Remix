// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ManualRevertExampleVul {
//     /*
//         STORAGE VARIABLES
//     */
//     uint256 public totalCounter;

//     mapping(address => uint256) public balances;

//     /*
//     =====================================================
//     MANUAL REVERT EXAMPLE
//     =====================================================
//     */

//     function dangerousDeposit(
//         uint256 _amount
//     )
//         external
//     {
//         /*
//             STEP 1:
//             Update storage.

//             TEMPORARY until transaction succeeds.
//         */
//         balances[msg.sender] += _amount;
//         totalCounter += _amount;

//         /*
//             STEP 2:
//             Manual revert condition.
//         */
//         if (_amount > 10) {

//             /*
//                 MANUAL REVERT

//                 ALL earlier state changes rollback.
//             */
//             revert("Amount exceeds limit");
//         }

//         /*
//             If execution reaches here:
//             transaction succeeds.
//         */
//     }

//     /*
//     =====================================================
//     CONDITIONAL REVERT EXAMPLE
//     =====================================================
//     */

//     function onlyEven(
//         uint256 _number
//     )
//         external
//         pure
//         returns (string memory)
//     {

//         /*
//             Reject odd numbers.
//         */
//         if (_number % 2 != 0) {

//             revert("Odd number rejected");
//         }

//         return "Even number accepted";
//     }

//     /*
//     =====================================================
//     REVERT WITHOUT MESSAGE
//     =====================================================
//     */

//     function silentRevert(
//         bool _shouldFail
//     )
//         external
//         pure
//     {

//         if (_shouldFail) {

//             /*
//                 Revert without reason string.
//             */
//             revert();
//         }
//     }
// }

contract ManualRevertExample {

    uint256 public totalCounter;

    mapping(address => uint256) public balances;

    error AmountExceedsLimit();

    error InsufficientBalance();

    error InvalidAmount();

    function dangerousDeposit(uint256 _amount) external {
        balances[msg.sender] += _amount;
        totalCounter += _amount;
        
    if(_amount > 10) {
        revert AmountExceedsLimit();
    }
    }

    function safeDeposit(uint256 _amount) external {
        if(_amount == 0) {
            revert InvalidAmount();
        }

        if(_amount > 10) {
            revert AmountExceedsLimit();
        }

        balances[msg.sender] += _amount;
        totalCounter += _amount;
    }

    function withdraw(uint256 _amount) external {
        if(_amount == 0) {
            revert InvalidAmount();
        }

        if(_amount == 0) {
            revert InvalidAmount();
        }

        if(balances[msg.sender] < _amount) {
            revert InsufficientBalance();
        }

        balances[msg.sender] -= _amount;

        totalCounter -= _amount;
    }

    function withdrawWithRequire(uint256 _amount) external {
        require(_amount > 0, "Invalid amount");

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount;

        totalCounter -= _amount;
    }

    function onlyEvent(uint256 _number) external pure returns (string memory) {
        if(_number % 2 != 0) {
            revert("Odd number rejected");
        }

        return "Event number accepted";
    }

    function silentRevert(bool _shouldFail) external pure {
        if(_shouldFail) {
            revert();
        }
    }

    function getMyBalance() external view returns(uint256) {
        return balances[msg.sender];
    }
}