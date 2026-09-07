// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ReorderLogicVulnerabilityVul {

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//         TOTAL SYSTEM BALANCE
//     */
//     uint256 public totalBalance;

//     /*
//     =====================================================
//     SAFE DEPOSIT
//     =====================================================
//     */

//     function safeDeposit()
//         external
//         payable
//     {

//         /*
//             STEP 1:
//             Validate FIRST.
//         */
//         require(
//             msg.value > 0,
//             "No ETH sent"
//         );

//         /*
//             STEP 2:
//             Update user balance.
//         */
//         balances[msg.sender] += msg.value;

//         /*
//             STEP 3:
//             Update global accounting.
//         */
//         totalBalance += msg.value;
//     }

//     /*
//     =====================================================
//     SAFE WITHDRAW
//     =====================================================

//     Uses:
//     Checks -> Effects -> Interactions
//     */

//     function safeWithdraw(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             CHECKS
//         */
//         require(
//             balances[msg.sender] >= _amount,
//             "Insufficient balance"
//         );

//         /*
//             EFFECTS

//             Update storage BEFORE external call.
//         */
//         balances[msg.sender] -= _amount;

//         totalBalance -= _amount;

//         /*
//             INTERACTION

//             External ETH transfer LAST.
//         */
//         payable(msg.sender).transfer(_amount);
//     }

//     /*
//     =====================================================
//     VULNERABLE WITHDRAW
//     =====================================================

//     INTENTIONALLY BAD ORDER
//     */

//     function vulnerableWithdraw(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             CHECK:
//             User balance validation.
//         */
//         require(
//             balances[msg.sender] >= _amount,
//             "Insufficient balance"
//         );

//         /*
//             DANGEROUS ORDER:

//             External call BEFORE state update.
//         */
//         payable(msg.sender).call{ value: _amount}("");

//         /*
//             STATE UPDATED TOO LATE
//         */
//         balances[msg.sender] -= _amount;

//         totalBalance -= _amount;
//     }

//     /*
//     =====================================================
//     BAD REWARD ORDER
//     =====================================================
//     */

//     mapping(address => uint256) public rewards;

//     function badRewardUpdate(
//         uint256 _deposit
//     )
//         external
//     {

//         /*
//             WRONG ORDER:

//             Reward calculated BEFORE
//             balance update.
//         */
//         rewards[msg.sender] =
//             balances[msg.sender] / 10;

//         /*
//             Balance updated later.
//         */
//         balances[msg.sender] += _deposit;
//     }

//     /*
//     =====================================================
//     SAFE REWARD ORDER
//     =====================================================
//     */

//     function safeRewardUpdate(
//         uint256 _deposit
//     )
//         external
//     {

//         /*
//             Correct order:
//             update balance first.
//         */
//         balances[msg.sender] += _deposit;

//         /*
//             Reward uses NEW balance.
//         */
//         rewards[msg.sender] =
//             balances[msg.sender] / 10;
//     }
// }

contract TestToken {
    mapping(address => uint256) public balanceOf;

    function mint(address _to, uint256 _amount) external {
        require(_to != address(0),"Invalid address");

        balanceOf[_to] += _amount;
    }

    function transfer(address _to, uint256 _amount) external returns(bool) {
        require(balanceOf[msg.sender] >= _amount,"Token balance is too low");

        balanceOf[msg.sender] -= _amount;

        balanceOf[_to] += _amount;

        return true;
    } 
}

contract ReorderLogicVulnerability {
    mapping(address => uint256) public balances;

    uint256 public totalBalance;

    mapping(address => uint256) public rewards;

    TestToken public token;

    constructor(address _token) {
        require(_token != address(0),"Invalid token");

        token = TestToken(_token);
    }

    function safeDeposit() external payable {
        require(msg.value > 0,"No ETH sent");

        balances[msg.sender] += msg.value;

        totalBalance += msg.value;
    }

    function vulnerableTokenWithdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insufficient balance");

        bool success = token.transfer(msg.sender, _amount);

        require(success,"Token transfer failed");

        balances[msg.sender] -= _amount;

        totalBalance -= _amount;
    }

    function safeTokenWithdraw(uint256 _amount) external {
        require(_amount > 0,"Invalid amount");

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount;

        totalBalance -= _amount;

        bool success = token.transfer(msg.sender, _amount);

        require(success,"Token transfer failed");
    }

    function badRewardUpdate(uint256 _deposit) external {
        rewards[msg.sender] = balances[msg.sender] / 10;

        balances[msg.sender] += _deposit;
    }

    function safeRewardUdate(uint256 _deposit) external {
        balances[msg.sender] += _deposit;

        rewards[msg.sender] = balances[msg.sender] / 10;
    }

    function getContractTokenBalance() external view returns (uint256) {

        return token.balanceOf(address(this));

    }
    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}