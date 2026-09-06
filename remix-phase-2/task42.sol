// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract InternalFunctionFlowVul {
//     /*
//         STORAGE VARIABLES
//     */
//     mapping(address => uint256) public balances;

//     uint256 public totalDeposits;
//     /*
//     =====================================================
//     EXTERNAL ENTRY FUNCTION
//     =====================================================
//     */
//     function deposit(uint256 _amount)external{
//         /*
//             STEP 1:
//             Validate input using internal function.
//         */
//         _validateAmount(_amount);

//         /*
//             STEP 2:
//             Update balance using internal function.
//         */
//         _updateBalance(msg.sender,_amount);

//         /*
//             STEP 3:
//             Update global state.
//         */
//         totalDeposits += _amount;
//     }

//     /*
//     =====================================================
//     INTERNAL VALIDATION FUNCTION
//     =====================================================
//     */

//     function _validateAmount(uint256 _amount)internal pure {
//         /*
//             Internal require check.
//         */
//         require(_amount > 0,"Amount must be > 0");
//         require(_amount <= 100,"Amount too large");
//     }

//     /*
//     =====================================================
//     INTERNAL STATE UPDATE FUNCTION
//     =====================================================
//     */

//     function _updateBalance(address _user,uint256 _amount)internal{
//         /*
//             Internal storage update.
//         */
//         balances[_user] += _amount;
//     }

//     /*
//     =====================================================
//     INTERNAL CALCULATION FUNCTION
//     =====================================================
//     */

//     function _calculateBonus(uint256 _amount)internal pure returns (uint256){
//         /*
//             Bonus = 10%
//         */
//         return (_amount * 10) / 100;
//     }

//     /*
//     =====================================================
//     EXTERNAL FUNCTION USING INTERNAL HELPER
//     =====================================================
//     */

//     function depositWithBonus(uint256 _amount)external{
//         /*
//             Internal validation call.
//         */
//         _validateAmount(_amount);
//         /*
//             Internal calculation.
//         */
//         uint256 bonus =_calculateBonus(_amount);

//         /*
//             Internal balance update.
//         */
//         _updateBalance( msg.sender, _amount + bonus);

//         totalDeposits +=(_amount + bonus);
//     }
// }

contract InternalFunctionFlow {
    mapping(address => uint256) public balances;

    uint256 public totalDeposits;

    address public owner;

    uint256 public constant MAX_DEPOSIT = 100;

    uint public constant FEE_PERCENT = 2;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyAdmin()  {
        require(msg.sender == owner,"only admin cal call this function");
        _;
    }

    function deposit(uint256 _amount) external {
        _validateAmount(_amount);

        _updateBalance(msg.sender, _amount);

        totalDeposits += _amount;
    }

    function _validateAmount(uint256 _amount) internal pure {
        require(_amount > 0,"Amount must be > 0");

        require(_amount <= MAX_DEPOSIT,"Amount too large");
    }

    function _updateBalance(address _user, uint256 _amount) internal {
        balances[_user] += _amount;
    }

    function _calculateBonus(uint256 _amount) internal pure returns (uint256) {
        return (_amount * 10) / 100;
    }

    function _calculateFee(uint256 _amount) internal pure returns (uint256) {
        return (_amount * FEE_PERCENT) / 100;
    }

    function _withdraw(address _user, uint256 _amount) internal {
        require(_amount > 0,"Amount must be > 0");

        require(balances[_user] >= _amount,"Insufficient balance");

        uint256 fee = _calculateFee(_amount);

        uint256 amountAfterFee = _amount - fee;

        balances[_user] -= _amount;

        totalDeposits -= _amount;

        amountAfterFee;
    }

    function withdraw(uint256 _amount) external {
        _withdraw(msg.sender, _amount);
    }

    function depositWithBonus(uint256 _amount) external {
        _validateAmount(_amount);

        uint256 bonus = _calculateBonus(_amount);

        _updateBalance(msg.sender,_amount + bonus);

        totalDeposits += _amount + bonus;
    }

    function adminDeposit(address _user, uint256 _amount) external onlyAdmin {
        require(_user != address(0),"Invalid user");

        _validateAmount(_amount);

        _updateBalance(_user, _amount);

        totalDeposits += _amount;
    }

    function adminWithdraw(address _user, uint256 _amount) external onlyAdmin {
        require(_user != address(0),"Invalid user");

        _withdraw(_user, _amount);
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getBalance(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function calculateWithdrawalFee(uint256 _amount) external pure returns (uint256) {
        return _calculateFee(_amount);
    }
}