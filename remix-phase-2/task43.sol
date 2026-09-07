// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract FunctionExecutionChainingVul {

//     /*
//         STORAGE VARIABLES
//     */
//     mapping(address => uint256) public balances;

//     uint256 public totalDeposits;

//     /*
//     =====================================================
//     MAIN ENTRY FUNCTION
//     =====================================================
//     */

//     function deposit(
//         uint256 _amount
//     )
//         external
//     {

//         /*
//             STEP 1:
//             Validate input.
//         */
//         validateAmount(_amount);

//         /*
//             STEP 2:
//             Add balance.
//         */
//         addBalance(
//             msg.sender,
//             _amount
//         );

//         /*
//             STEP 3:
//             Update global total.
//         */
//         updateTotal(_amount);
//     }

//     /*
//     =====================================================
//     VALIDATION FUNCTION
//     =====================================================
//     */

//     function validateAmount(
//         uint256 _amount
//     )
//         internal
//         pure
//     {

//         require(
//             _amount > 0,
//             "Amount must be > 0"
//         );

//         require(
//             _amount <= 100,
//             "Amount too large"
//         );
//     }

//     /*
//     =====================================================
//     BALANCE UPDATE FUNCTION
//     =====================================================
//     */

//     function addBalance(
//         address _user,
//         uint256 _amount
//     )
//         internal
//     {

//         /*
//             Storage update.
//         */
//         balances[_user] += _amount;
//     }

//     /*
//     =====================================================
//     TOTAL UPDATE FUNCTION
//     =====================================================
//     */

//     function updateTotal(
//         uint256 _amount
//     )
//         internal
//     {

//         totalDeposits += _amount;
//     }

//     /*
//     =====================================================
//     CHAINED BONUS FLOW
//     =====================================================
//     */

//     function depositWithBonus(
//         uint256 _amount
//     )
//         external
//     {
        
//         /*
//             Function calling another function.
//         */
//         depositInternal(_amount);

//         /*
//             Additional bonus logic.
//         */
//         addBalance(
//             msg.sender,
//             10
//         );
//     }

//     /*
//     =====================================================
//     INTERNAL DEPOSIT FLOW
//     =====================================================
//     */

//     function depositInternal(
//         uint256 _amount
//     )
//         internal
//     {

//         /*
//             Chained execution continues.
//         */
//         validateAmount(_amount);

//         addBalance(
//             msg.sender,
//             _amount
//         );
//         updateTotal(_amount);
//     }
// }

contract FunctionExecutionChaining {
    mapping(address => uint256) public balances;

    uint256 public totalDeposits;

    mapping(address => bool) public blacklisted;

    address public owner;

    uint256 public constant MAX_DEPOSIT = 100;

    uint256 public constant FEE_PERCENT = 2;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"Only the Owner");
        _;
    }

    function deposit(uint256 _amount) external {
        validateAmount(_amount);

        checkBlacklist(msg.sender);

        addBalance(msg.sender,_amount);

        updateTotal(_amount);
    }

    function validateAmount(uint256 _amount) internal pure {
        require(_amount > 0,"amount must be > 0");

        require(_amount <= MAX_DEPOSIT,"Amount too large");
    }

    function checkBlacklist(address _user) internal view {
        require(!blacklisted[_user],"User is blacklisted");
    }

    function addBalance(address _user, uint256 _amount) internal {
        balances[_user] += _amount;
    }

    function updateTotal(uint256 _amount) internal {
        totalDeposits += _amount;
    }

    function depositInternal(uint256 _amount) internal {
        validateAmount(_amount);

        checkBlacklist(msg.sender);

        addBalance(msg.sender,_amount);

        updateTotal(_amount);
    }

    function depositWithBonus(uint256 _amount) external {
        depositInternal(_amount);

        addBalance(msg.sender,10);

        updateTotal(10);
    }

    function calcalateFee(uint256 _amount) internal pure returns (uint256) {
        return(_amount * FEE_PERCENT) / 100;
    }

    function withdrawInternal(uint256 _amount) internal {
        checkBlacklist(msg.sender);

        require(_amount > 0,"Amount must be > 0");

        require(balances[msg.sender] >= _amount,"insufficient balance");

        uint256 fee = calcalateFee(_amount);

        uint256 amountAfterFee = _amount - fee;

        balances[msg.sender] -_amount;

        totalDeposits -= _amount;

        amountAfterFee;
    }

    function withdraw(uint256 _amount) external {
        withdrawInternal(_amount);
    }

    function blacklistUser(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] = true;
    }

    function removeBlacklist(address _user) external onlyOwner {
        require(_user != address(0),"Invalid address");

        blacklisted[_user] = false;
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getBalance(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function getFee(uint256 _amount) external pure returns (uint256) {
        return calcalateFee(_amount);
    }
}