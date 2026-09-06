// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract TransactionAtomicityVul {

//     /*
//         STORAGE VARIABLES

//         Persist only if transaction succeeds.
//     */
//     uint256 public globalCounter;

//     mapping(address => uint256) public balances;

//     /*
//     =====================================================
//     FAIL REQUIRE AFTER STATE UPDATE
//     =====================================================
//     */

//     function brokenExecution(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             UPDATE GLOBAL COUNTER

//             Temporary state update.
//         */
//         globalCounter =
//             globalCounter + _amount;

//         /*
//             STEP 2:
//             UPDATE USER BALANCE

//             Temporary state update.
//         */
//         balances[msg.sender] =
//             balances[msg.sender] + _amount;

//         /*
//             STEP 3:
//             REQUIRE FAILURE

//             If _amount > 5:
//             transaction reverts completely.
//         */
//         require(
//             _amount <= 5,
//             "Amount too large"
//         );
//     }

//     /*
//     =====================================================
//     SAFE EXECUTION
//     =====================================================

//     Validation first.
//     */

//     function safeExecution(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             VALIDATE BEFORE CHANGES
//         */
//         require(
//             _amount <= 5,
//             "Amount too large"
//         );

//         /*
//             UPDATE STATE AFTER VALIDATION
//         */
//         globalCounter =
//             globalCounter + _amount;

//         balances[msg.sender] =
//             balances[msg.sender] + _amount;
//     }
// }

contract testToken {
    mapping(address => uint256) public balanceOf;

    function mint(address _to, uint256 _amount) external {
        balanceOf[_to] = balanceOf[_to] + _amount;
    }

    function transfer(address _to, uint256 _amount) external returns (bool) {
        require(balanceOf[msg.sender] >= _amount,"Insufficient token balance");

        balanceOf[msg.sender] = balanceOf[msg.sender] - _amount;

        balanceOf[_to] = balanceOf[_to] + _amount;

        return true;
    }
}

contract TransactionAtomicity {
    uint256 public globalCounter;

    mapping(address => uint256) public balances;

    testToken public token;

    constructor(address _token) {
        token = testToken(_token);
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0,"Invalid amount");

        balances[msg.sender] = balances[msg.sender] + _amount;

        globalCounter = globalCounter + _amount;
    }

    function riskyTokenTransfer(address _to, uint256 _amount) external {
        globalCounter = globalCounter + _amount;

        bool success = token.transfer(_to, _amount);

        require(success,"Token transfer failed");

        require(_amount <= 5,"Amount too large");
    }

    function safeTokenTransfer(address _to, uint256 _amount) external {
        require(_amount > 0,"Invalid amount");

        require(_amount <= 5,"Amount too large");

        globalCounter = globalCounter + _amount;

        bool success = token.transfer(_to, _amount);

        require(success,"token transfer failed");
    }

    function getMybalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getTokenBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}