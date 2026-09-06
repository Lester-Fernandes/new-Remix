// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract EarlyReturnExampleVul {
//     /*
//         STORAGE VARIABLES
//     */
//     mapping(address => uint256) public balances;

//     bool public paused;

//     /*
//     =====================================================
//     TOGGLE PAUSE
//     =====================================================
//     */


//     function setPaused(
//         bool _status
//     )
//         external
//     {

//         paused = _status;
//     }

//     /*
//     =====================================================
//     EARLY RETURN EXAMPLE
//     =====================================================
//     */

//     function deposit(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             Check paused state.
//         */
//         if (paused == true) {

//             /*
//                 EARLY RETURN

//                 Function stops here.
//             */
//             return;
//         }

//         /*
//             STEP 2:
//             Reject zero amount.
//         */
//         if (_amount == 0) {

//             /*
//                 EARLY RETURN

//                 Remaining code skipped.
//             */
//             return;
//         }

//         /*
//             STEP 3:
//             Update balance.

//             Executes ONLY if:
//             - not paused
//             - amount > 0
//         */
//         balances[msg.sender] += _amount;
//     }

//     /*
//     =====================================================
//     RETURN VALUE EARLY
//     =====================================================
//     */

//     function checkLevel(
//         uint256 _score
//     )
//         external
//         pure
//         returns (string memory)
//     {

//         /*
//             FIRST BRANCH
//         */
//         if (_score >= 90) {

//             return "Elite";
//         }

//         /*
//             SECOND BRANCH
//         */
//         if (_score >= 50) {

//             return "Standard";
//         }

//         /*
//             DEFAULT BRANCH
//         */
//         return "Rejected";
//     }

//     /*
//     =====================================================
//     UNREACHABLE CODE DEMO
//     =====================================================
//     */

//     function unreachableExample()
//         external
//         pure
//         returns (uint256)
//     {

//         /*
//             FUNCTION RETURNS HERE
//         */
//         return 100;

//         /*
//             UNREACHABLE CODE

//             Never executes.
//         */

//         // uint256 x = 999;
//     }
// }

contract EarlyRenturnExample {
    mapping(address => uint256) public balances;

    bool public paused;

    mapping(address => bool) public blacklisted;

    address public owner;

    constructor() {
        owner = msg.sender;
        
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Not the owner");
        _;
    }

    function setPaused(bool _status) external onlyOwner {
        paused = _status;
    }

    function setBlacklist(address _user, bool _status) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] = _status;
    }

    function deposit(uint256 _amount) external {
        if(paused) {
            return;
        }

        if(blacklisted[msg.sender]) {
            return;
        }

        if(_amount == 0) {
            return;
        }

        balances[msg.sender] = balances[msg.sender] + _amount;
    }

    function depositWithRequire(uint256 _amount) external {
        require(!paused,"Contract is paused");

        require(!blacklisted[msg.sender],"User is blacklisted");

        require(_amount > 0,"Amount must be > 0");

        balances[msg.sender] = balances[msg.sender] + _amount;
    }

    function checkLevel(uint256 _score) external pure returns (string memory) {
        if(_score >= 90) {
            return "Elite";
        }

        if(_score >= 50) {
            return "Standard";
        }

        return "Rejected";
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}