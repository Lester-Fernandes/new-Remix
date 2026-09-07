// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ModifierExecutionFlowVul {
//     /*
//         OWNER ADDRESS
//     */
//     address public owner;

//     /*
//         PAUSE STATUS
//     */
//     bool public paused;

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//         CONSTRUCTOR

//         Runs once during deployment.
//     */
//     constructor() {

//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     MODIFIER: ONLY OWNER
//     =====================================================
//     */

//     modifier onlyOwner() {

//         /*
//             PRE-EXECUTION CHECK

//             Runs BEFORE function body.
//         */
//         require(
//             msg.sender == owner,
//             "Not owner"
//         );

//         /*
//             SPECIAL SYMBOL: _;

//             Represents:
//             function body execution point.
//         */
//         _;
//     }

//     /*
//     =====================================================
//     MODIFIER: WHEN NOT PAUSED
//     =====================================================
//     */

//     modifier whenNotPaused() {

//         /*
//             PRE-EXECUTION VALIDATION
//         */
//         require(
//             paused == false,
//             "Contract paused"
//         );

//         /*
//             Continue to function body.
//         */
//         _;
//     }

//     /*
//     =====================================================
//     OWNER-ONLY FUNCTION
//     =====================================================
//     */

//     function setPaused(
//         bool _status
//     )
//         external
//         onlyOwner
//     {

//         /*
//             Function body executes ONLY
//             after modifier passes.
//         */
//         paused = _status;
//     }

//     /*
//     =====================================================
//     DEPOSIT FUNCTION
//     =====================================================
//     */

//     function deposit(
//         uint256 _amount
//     )
//         external
//         whenNotPaused
//     {

//         /*
//             Function body executes ONLY
//             if modifier allows execution.
//         */
//         require(
//             _amount > 0,
//             "Invalid amount"
//         );

//         balances[msg.sender] += _amount;
//     }

//     /*
//     =====================================================
//     MULTIPLE MODIFIERS
//     =====================================================
//     */

//     function emergencyReset(
//         address _user
//     )
//         external
//         onlyOwner
//         whenNotPaused
//     {

//         /*
//             Executes ONLY if:
//             - caller is owner
//             - contract not paused
//         */
//         balances[_user] = 0;
//     }
// }

contract ModifierExecutionFlow {
    address public owner;

    bool public paused;

    mapping(address => uint256) public balances;

    mapping(address => bool) public blacklisted;

    uint256 public constant MAX_TRANSACTION = 100;

    event DepositCompleted(address indexed user, uint256 amount, uint256 newBalance);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Not the Owner");

        _;
    }

    modifier whenNotPaused() {
        require(!paused,"Contract paused");
        _;
    }

    modifier notBlacklisted() {
        require(!blacklisted[msg.sender],"User is blacklisted");
        _;
    }

    modifier withinTransactionLimit(uint256 _amount) {
        require(_amount > 0," amount must be > 0");

        require(_amount <= MAX_TRANSACTION,"Transaction limit exceeded");
        _;
    }

    modifier emiteAfterDeposit(uint256 _amount) {
        _;

        emit DepositCompleted(msg.sender, _amount, balances[msg.sender]);
    }

    function setPaused(bool _status) external onlyOwner {
        paused = _status;
    }

    function setBlacklist(address _user, bool _status) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] = _status;
    }

    function deposit(uint256 _amount) external whenNotPaused notBlacklisted withinTransactionLimit(_amount) emiteAfterDeposit(_amount) {
        balances[msg.sender] += _amount;
    }

    function emergencyReset(address _user) external onlyOwner whenNotPaused {
        require(_user != address(0),"Invalida address");

        balances[_user] = 0;
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function isBlacklisted(address _user) external view returns (bool) {
        return blacklisted[_user];
    }
}