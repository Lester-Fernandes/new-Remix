// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract BankVul {
//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;
//     /*
//     =====================================================
//     DEPOSIT FUNCTION
//     =====================================================
//     */
//     function deposit(uint256 _amount)external{
//         /*
//             Update storage.
//         */
//         balances[msg.sender] += _amount;
//     }

//     /*
//     =====================================================
//     READ BALANCE
//     =====================================================
//     */
//     function getBalance( address _user)external view returns (uint256){
//         return balances[_user];
//     }
// }

// /*
// =========================================================
// CONTRACT 2:
// CALLER CONTRACT
// =========================================================
// */
// contract InterContractCallerVul {
//     /*
//         STORE TARGET CONTRACT ADDRESS
//     */
//     address public bankAddress;
//     /*
//         LAST READ VALUE
//     */
//     uint256 public lastBalance;

//     /*
//         CONSTRUCTOR
//         Save target contract address.
//     */
//     constructor(
//         address _bankAddress
//     )
//     {
//         bankAddress = _bankAddress;
//     }
//     /*
//     =====================================================
//     CALL DEPOSIT FUNCTION
//     =====================================================
//     */

//     function callDeposit(uint256 _amount)external{
//         /*
//             Create contract reference.

//             Tells Solidity:
//             "bankAddress is a Bank contract"
//         */
//         BankVul bank = BankVul(bankAddress);
//         /*
//             EXTERNAL CONTRACT CALL

//             Execution jumps into:
//             Bank.deposit()
//         */
//         bank.deposit(_amount);
//     }

//     /*
//     =====================================================
//     READ ANOTHER CONTRACT STATE
//     =====================================================
//     */

//     function readBalance( address _user)external{
//         /*
//             Create contract reference.
//         */
//         BankVul bank = BankVul(bankAddress);

//         /*
//             External view call.

//             Reads state from another contract.
//         */
//         uint256 balance = bank.getBalance(_user);

//         /*
//             Save locally.
//         */
//         lastBalance = balance;
//     }
// }

interface IBank {
    function deposit(uint256 _amount) external;

    function withdraw(uint256 _amount) external;

    function getBalance(address _user) external view returns (uint256);
}

contract BankFixed {
    mapping(address => uint256) public balances;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable{}

    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than Zero");

        balances[msg.sender] += _amount;
    }

    function depositETH() external payable {
        require(msg.value > 0, "Sender ETH");

        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = payable(msg.sender).call{
            value: _amount
        }("");

        require(success, "ETH transfer failed");
    }

    function getBalance(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract InterContractCaller {
    address public bankAddress;

    uint256 public lastBalance;

    constructor(address _bankAddress) {
        require(_bankAddress !=address(0),"Invalid bank address");

        bankAddress = _bankAddress;
    }

    function getBank() internal view returns (IBank) {
        return IBank(bankAddress);
    }

    function callDeposit(uint256 _amount) external {
        IBank bank = IBank(bankAddress);

        bank.deposit(_amount);
    }

    function callDepositETH() external payable {
        require(msg.value > 0,"Send ETH");

        (bool success, ) = bankAddress.call{
            value: msg.value
        }(abi.encodeWithSignature("depositETH()"));

        require(success, "Bank ETH deposit failed");
    }

    function readBalance(address _user) external {
        IBank bank = IBank(bankAddress);

        uint256 balance = bank.getBalance(_user);

        lastBalance = balance;
    }

    function callWithdraw(uint256 _amount) external {
        IBank bank = IBank(bankAddress);

        bank.withdraw(_amount);
    }

    receive() external payable {}
}

