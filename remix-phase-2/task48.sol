// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract OrderDependencyExampleVul {

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//         GLOBAL TOTAL
//     */
//     uint256 public totalSupply;

//     /*
//         REWARD TRACKER
//     */
//     mapping(address => uint256) public rewards;

//     /*
//     =====================================================
//     CORRECT ORDER EXAMPLE
//     =====================================================
//     */

//     function depositCorrect(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             Validate input FIRST.
//         */
//         require(
//             _amount > 0,
//             "Invalid amount"
//         );

//         /*
//             STEP 2:
//             Update user balance.
//         */
//         balances[msg.sender] += _amount;

//         /*
//             STEP 3:
//             Update total supply.

//             Depends on balance update.
//         */
//         totalSupply += _amount;

//         /*
//             STEP 4:
//             Reward based on NEW balance.
//         */
//         rewards[msg.sender] =
//             balances[msg.sender] / 10;
//     }

//     /*
//     =====================================================
//     BAD ORDER EXAMPLE
//     =====================================================
//     */

//     function depositWrong(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             Reward calculated BEFORE
//             balance update.
//         */
//         rewards[msg.sender] =
//             balances[msg.sender] / 10;

//         /*
//             STEP 2:
//             Balance updated later.
//         */
//         balances[msg.sender] += _amount;

//         /*
//             STEP 3:
//             Total updated.
//         */
//         totalSupply += _amount;
//     }

//     /*
//     =====================================================
//     TRANSFER EXAMPLE
//     =====================================================
//     */

//     function transfer(
//         address _to,
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             Validate sender balance FIRST.
//         */
//         require(
//             balances[msg.sender] >= _amount,
//             "Insufficient balance"
//         );

//         /*
//             CORRECT ORDER:
//             subtract sender first.
//         */
//         balances[msg.sender] -= _amount;

//         /*
//             Then add receiver.
//         */
//         balances[_to] += _amount;
//     }
// }

contract OrderDependency {
    mapping(address => uint256) public balances;

    uint256 public totalSupply;

    mapping(address => uint256) public rewards;

    function depositCorrect(uint256 _amount) external {
        require(_amount > 0, "Invalid amount");

        balances[msg.sender] += _amount;

        totalSupply += _amount;

        rewards[msg.sender] = balances[msg.sender] / 10;
    }

    function depositWrong(uint256 _amount) external {
        require(_amount > 0,"Invalid amount");

        rewards[msg.sender] = balances[msg.sender] /10;

        balances[msg.sender] += _amount;

        totalSupply += _amount;
    }

    function depositETH() external payable {
        require(msg.value > 0,"Send ETH");

        balances[msg.sender] += msg.value;

        totalSupply += msg.value;
    }

    function withdrawWrong(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insufficient balance");

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        require(success, "Transfer failed");

        balances[msg.sender] -= _amount;

        totalSupply -= _amount;
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0,"Invalid amount");

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount;
        
        totalSupply -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        require(success, "Transfer failed");
    }

    function transfer(address _to, uint256 _amount) external {
        require(_to != address(0),"Invalid receiver");

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount;

        balances[_to] += _amount;
    }

    function getMyBalance() external view returns(uint256) {
        return balances[msg.sender];
    }

    function getCounterETH() external view returns (uint256) {
        return address(this).balance;
    }
}