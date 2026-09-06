// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract MultipleRequireChecksVul {
//     /*
//         OWNER ADDRESS
//         Set during deployment.
//     */
//     address public owner;
//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;
//     /*
//         MAX LIMIT
//     */
//     uint256 public constant MAX_DEPOSIT = 100 ether;
//     /*
//         CONSTRUCTOR
//         Runs once during deployment.
//     */
//     constructor() {
//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     DEPOSIT FUNCTION
//     =====================================================
//     */

//     function deposit(uint256 _amount)external{
//         /*
//             REQUIRE #1
//             Amount must be positive.
//         */
//         require(_amount > 0,"Amount must be > 0");
//         /*
//             REQUIRE #2
//             Amount must not exceed max limit.
//         */
//         require(
//             _amount <= MAX_DEPOSIT,"Deposit too large");
//         /*
//             REQUIRE #3
//             Prevent overflow-like balance growth.
//         */
//         require(balances[msg.sender] + _amount<= 1000 ether,"Balance limit exceeded");
//         /*
//             EXECUTION REACHES HERE
//             ONLY IF ALL CHECKS PASS.
//         */
//         balances[msg.sender] += _amount;
//     }

//     /*
//     =====================================================
//     OWNER-ONLY RESET
//     =====================================================
//     */

//     function resetBalance(
//         address _user
//     )
//         external
//     {

//         /*
//             REQUIRE #1

//             Access control.
//         */
//         require(
//             msg.sender == owner,
//             "Not owner"
//         );

//         /*
//             REQUIRE #2

//             Reject zero address.
//         */
//         require(
//             _user != address(0),
//             "Invalid address"
//         );

//         /*
//             REQUIRE #3

//             User must have balance.
//         */
//         require(
//             balances[_user] > 0,
//             "No balance"
//         );

//         /*
//             RESET USER BALANCE
//         */
//         balances[_user] = 0;
//     }
// }

contract MultipleRequireChecks {

    address public owner;

    bool public paused;

    mapping(address => uint256) public balances;

    mapping(address => bool) public blacklisted;

    uint256 public constant MAX_DEPOSIT = 100 ether;

    uint256 public constant MAX_BALANCE = 1000 ether;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Not the Owner");
        _;
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0,"Amount must be > 0");

        require(_amount <= MAX_DEPOSIT,"Depost too large");

        require(_amount <= MAX_BALANCE - balances[msg.sender],"Balance limit exceeded");

        balances[msg.sender]= balances[msg.sender] + _amount;
    }

    function withdraw(uint256 _amount) external {
        require(!paused,"Contract is paused");

        require(!blacklisted[msg.sender],"User is blacklisted");

        require(_amount > 0,"Amount must be > 0");

        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] = balances[msg.sender] - _amount;
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    function blacklist(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] = true;
    }

    function unblacklist(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] =false;
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

}