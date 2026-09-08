// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract EthTransferMechanicsVul {

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//     =====================================================
//     DEPOSIT ETH
//     =====================================================

//     payable:
//     function can receive ETH.
//     */

//     function deposit()external payable{
//         /*
//             msg.value:
//             ETH sent with transaction.
//         */
//         require(msg.value > 0,"No ETH sent");

//         /*
//             Store deposited ETH amount.
//         */
//         balances[msg.sender] += msg.value;
//     }

//     /*
//     =====================================================
//     SEND ETH USING transfer()
//     =====================================================
//     */

//     function withdraw(uint256 _amount ) external{
//         /*
//             CHECK:
//             user must have balance.
//         */
//         require(balances[msg.sender] >= _amount,"Insufficient balance");

//         /*
//             EFFECTS:
//             update storage BEFORE transfer.

//             CEI pattern:
//             Checks -> Effects -> Interactions
//         */
//         balances[msg.sender] -= _amount;

//         /*
//             INTERACTION:
//             send ETH externally.

//             transfer():
//             - sends ETH
//             - forwards 2300 gas
//             - reverts automatically if failed
//         */
//         payable(msg.sender).transfer(_amount);
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT ETH BALANCE
//     =====================================================
//     */

//     function contractBalance()external view returns (uint256){
//         /*
//             address(this).balance

//             Native ETH stored
//             inside this contract.
//         */
//         return address(this).balance;
//     }
// }

contract EthTransferMechanics {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0,"No ETH sent");

        balances[msg.sender] += msg.value;
    }

    function vulnerableWithdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insifficient balance");

        payable(msg.sender).transfer(_amount);

        balances[msg.sender] -= _amount;
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0,"Amount must be greater than zero");

        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;

        payable(msg.sender).transfer(_amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getMyBalance() external view returns(uint256) {
        return balances[msg.sender];
    }

    receive() external payable {}
}