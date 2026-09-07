// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract PostExecutionModifierVul {

//     /*
//         OWNER ADDRESS
//     */
//     address public owner;

//     /*
//         EXECUTION STATUS
//     */
//     bool public locked;

//     /*
//         LAST ACTION TRACKER
//     */
//     string public lastAction;

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//         CONSTRUCTOR
//     */
//     constructor() {

//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     MODIFIER WITH POST-EXECUTION LOGIC
//     =====================================================
//     */

//     modifier trackExecution() {

//         /*
//             PRE-EXECUTION LOGIC
//         */
//         lastAction = "Function started";

//         /*
//             FUNCTION BODY EXECUTES HERE
//         */
//         _;

//         /*
//             POST-EXECUTION LOGIC

//             Executes AFTER function body.
//         */
//         lastAction = "Function completed";
//     }

//     /*
//     =====================================================
//     REENTRANCY-STYLE MODIFIER
//     =====================================================
//     */

//     modifier noReentrant() {

//         /*
//             PRE-EXECUTION CHECK
//         */
//         require(
//             locked == false,
//             "Reentrant call blocked"
//         );

//         /*
//             LOCK BEFORE FUNCTION EXECUTION
//         */
//         locked = true;

//         /*
//             FUNCTION BODY EXECUTES HERE
//         */
//         _;

//         /*
//             UNLOCK AFTER FUNCTION EXECUTION

//             POST-EXECUTION FLOW
//         */
//         locked = false;
//     }

//     /*
//     =====================================================
//     FUNCTION USING POST MODIFIER
//     =====================================================
//     */

//     function deposit(
//         uint256 _amount
//     )
//         external
//         trackExecution
//     {

//         /*
//             Function body.
//         */
//         require(
//             _amount > 0,
//             "Invalid amount"
//         );

//         balances[msg.sender] += _amount;
//     }

//     /*
//     =====================================================
//     FUNCTION USING REENTRANCY-STYLE MODIFIER
//     =====================================================
//     */

//     function secureDeposit(
//         uint256 _amount
//     )
//         external
//         noReentrant
//     {

//         /*
//             Function executes while locked=true.
//         */
//         require(
//             _amount > 0,
//             "Invalid amount"
//         );

//         balances[msg.sender] += _amount;
//     }
// }

contract PostExecutionModifier {
    address public owner;

    bool public locked;

    string public lastAction;

    mapping(address => uint256) public balances;

    uint256 public executionCount;

    mapping(address => uint256) public failedAttempts;

    event FunctionExecuted(address indexed user, string functionname, uint256 amount, uint256 newBalance);

    constructor() {
        owner = msg.sender;
    }

    modifier trackExecution(string memory _functionName, uint256 _amount) {
        lastAction = "Function started";

        _;

        executionCount++;

        lastAction = "Function completed";

        emit FunctionExecuted(msg.sender, _functionName, _amount, balances[msg.sender]);
    }

    modifier noReentrant() {
        require(!locked,"Reentrant call blocked");

        locked = true;

        _;

        locked = false;
    }

    modifier validatedeposit(uint256 _amount) {
        if (_amount == 0) {
            failedAttempts[msg.sender]++;

            lastAction = "Failed deposit attempt";

            return;

            _;
        }
    }

        function deposit(uint256 _amount) external validatedeposit(_amount) noReentrant trackExecution("deposit", _amount) {
            balances[msg.sender] += _amount;
        }
    

        function secureDeposit(uint256 _amount) external noReentrant trackExecution("secureDeposit", _amount) {
            require(_amount > 0,"Invalid amount");

            balances[msg.sender] += _amount;
        }

        function resetBalance(address _user) external noReentrant trackExecution("resetBalance", 0 ) {
            require(msg.sender == owner,"Only the Owner");

            require(_user != address(0),"Invalid address");

            balances[_user] = 0;
        }

        function getMyBalance() external view returns (uint256) {
            return failedAttempts[msg.sender];
        }

        function getExecutionCount() external view returns (uint256) {
            return executionCount;
        }
}
