// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract LowLevelCallExampleVul {
//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;
//     /*
//     =====================================================
//     DEPOSIT ETH
//     =====================================================
//     */

//     function deposit() external payable{
//         /*
//             Store ETH balance.
//         */
//         balances[msg.sender] += msg.value;
//     }

//     /*
//     =====================================================
//     SAFE WITHDRAW USING call()
//     =====================================================
//     */

//     function safeWithdraw( uint256 _amount)external{
//         /*
//             CHECK:
//             Ensure sufficient balance.
//         */
//         require(balances[msg.sender] >= _amount,"Insufficient balance");
//         /*
//             EFFECTS:
//             Update storage BEFORE interaction.

//             CEI pattern.
//         */
//         balances[msg.sender] -= _amount;
//         /*
//             INTERACTION:
//             Send ETH using low-level call.

//             Syntax:
//             address.call{value: amount}("")
//         */
//         (bool success, ) =payable(msg.sender).call{value: _amount}("");
//         /*
//             IMPORTANT:
//             call() does NOT auto-revert.

//             Must manually check success.
//         */
//         require(success,"ETH transfer failed");
//     }

//     /*
//     =====================================================
//     DANGEROUS WITHDRAW
//     =====================================================

//     INTENTIONALLY VULNERABLE
//     */

//     function vulnerableWithdraw(uint256 _amount) external{
//         /*
//             Validation.
//         */
//         require( balances[msg.sender] >= _amount,"Insufficient balance");
//         /*
//             DANGEROUS ORDER
//             External call BEFORE
//             state update.
//         */
//         (bool success, ) =payable(msg.sender).call{value: _amount}("");
//         require(success,"Transfer failed");
//         /*
//             STATE UPDATED TOO LATE.
//             Reentrancy risk.
//         */
//         balances[msg.sender] -= _amount;
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT ETH BALANCE
//     =====================================================
//     */

//     function contractBalance() external view returns (uint256){
//         return address(this).balance;
//     }
// }

contract LowLevelCall {
    mapping(address => uint256) public balances;

    bool private locked;

    event Deposited(address indexed user, uint256 amount);

    event Withdrawn(address indexed user, uint256 amount);

    event TransferFailed(address indexed user, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "No ETH sent");

        balances[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    modifier nonReetrant() {
        require(!locked,"Reentrancy detected");

        locked = true;

        _;

        locked = false;
    }

    function safeWithdraw(uint256 _amount) external nonReetrant {
        require(_amount > 0, "Invalid amount");

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        if(!success) {
            balances[msg.sender] += _amount;

            emit TransferFailed(msg.sender, _amount);
        }

        emit Withdrawn(msg.sender, _amount);
    }

    function vulnerableWithdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insufficient balance");

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        require(success, "ETH transfer failed");

        balances[msg.sender] -= _amount;
    }

    function protectedWithdraw(uint256 _amount) external nonReetrant {

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        (bool success, ) = payable(msg.sender).call{
            value: _amount
        }("");

        require(success, "ETH transfer failed");

        balances[msg.sender] -= _amount;

        emit Withdrawn(msg.sender, _amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    receive() external payable {}
}