// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ExternalTargetVul {
//     /*
//         STORE LAST CALLER
//     */
//     address public lastCaller;

//     /*
//         TRACK EXECUTIONS
//     */
//     uint256 public executionCounter;

//     /*
//     =====================================================
//     TARGET FUNCTION
//     =====================================================
//     */

//     function targetFunction() external {
//         /*
//         =================================================
//         EXECUTION CONTEXT NOW INSIDE TARGET CONTRACT
//         =================================================

//         msg.sender becomes:
//         calling contract address.
//         */

//         lastCaller = msg.sender;

//         /*
//             Increment execution count.
//         */
//         executionCounter++;
//     }
// }

// /*
// =========================================================
// CALLER CONTRACT
// =========================================================
// */

// contract ExecutionTracerVul {

//     /*
//         TARGET CONTRACT REFERENCE
//     */
//     ExternalTargetVul public target;

//     /*
//         LOCAL EXECUTION TRACKING
//     */
//     uint256 public localCounter;

//     /*
//         TRACK EXECUTION STEPS
//     */
//     string public executionStage;

//     /*
//         TRACK LAST msg.sender
//     */
//     address public lastObservedSender;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _target)
//     {

//         /*
//             Save target contract.
//         */
//         target = ExternalTargetVul(_target);
//     }

//     /*
//     =====================================================
//     TRACE EXTERNAL EXECUTION
//     =====================================================
//     */

//     function traceExecution()external{
//         /*
//         =================================================
//         STEP 1
//         =================================================

//         Execution currently inside:
//         ExecutionTracer contract.
//         */

//         executionStage =
//             "Before external call";

//         /*
//             msg.sender here:
//             ORIGINAL USER.
//         */
//         lastObservedSender =
//             msg.sender;

//         /*
//             Local state update.
//         */
//         localCounter++;

//         /*
//         =================================================
//         STEP 2
//         =================================================

//         EXTERNAL CALL HAPPENS HERE.

//         CONTROL LEAVES:
//         ExecutionTracer

//         CONTROL ENTERS:
//         ExternalTarget
//         */

//         target.targetFunction();

//         /*
//         =================================================
//         STEP 3
//         =================================================

//         External execution finished.

//         CONTROL RETURNS:
//         back to ExecutionTracer.
//         */

//         executionStage ="After external call";
//     }
// }

contract ExternalTarget {
    address public lastCaller; 
    
    uint256 public executionCounter;
    
      uint256 public receivedETH; 
      
      event TargetCalled( address indexed caller, uint256 value );
      
      function targetFunction() external payable { 
        
        lastCaller = msg.sender; 
        
        executionCounter++; 
        
        receivedETH += msg.value; 
        
        emit TargetCalled(msg.sender, msg.value); 
    }
    receive() external payable { 
        receivedETH += msg.value; 
    }
}
    contract ExecutionTracer {
        ExternalTarget public target; 
        
        uint256 public localCounter; 
        
        string public executionStage; 
        
        address public lastObservedSender;

        bool private locked; 
        
        event ExecutionStep( string stage, address indexed caller, uint256 value );

        constructor(address payable _target) { 
            
            target = ExternalTarget(_target); 
        }

        modifier nonReentrant() { 
            
            require(!locked, "Reentrancy detected"); 
            
            locked = true; 
            
            _; 
            
            locked = false; 
        }

        function traceExecution() external { 
            
            executionStage = "Before external call"; 
            
            lastObservedSender = msg.sender; 
            
            localCounter++; 
            
            emit ExecutionStep( "Before external call", msg.sender, 0 ); 
            
             target.targetFunction(); 
             
             executionStage = "After external call"; 
             
             emit ExecutionStep( "After external call", msg.sender, 0 ); 
        }
    
    function sendETHToTarget() external payable nonReentrant { 
        
        require(msg.value > 0, "Send ETH");
        
        (bool success, ) = address(target).call{value: msg.value}( abi.encodeWithSelector( ExternalTarget.targetFunction.selector ) ); 
        
        require(success, "ETH transfer failed"); 
        
        emit ExecutionStep( "ETH sent to target", msg.sender, msg.value ); } 
        
       receive() external payable {} 
}

contract MaliciousCallback { 
    
    ExecutionTracer public target; 
    
    bool public attackStarted; 
    
    event CallbackExecuted( address indexed caller ); 
    
    constructor(address payable _target) { 
        
        target = ExecutionTracer(_target); 
    }

    function attack() external { 
        
        attackStarted = true; 
        
        emit CallbackExecuted(msg.sender);

        try target.traceExecution() {
            } catch {
        }
    }

    receive() external payable{}
}

contract ReentrancyVictim {
    
     mapping(address => uint256) public balances; 
     
     bool private locked; 
     
     event Deposit( address indexed user, uint256 amount ); 
     
     event Withdrawal( address indexed user, uint256 amount );

    function deposit() external payable {
        
         require(msg.value > 0, "Send ETH"); 
         
         balances[msg.sender] += msg.value; 
         
         emit Deposit( msg.sender, msg.value ); 
    }

    function withdraw(uint256 amount) external nonReentrant { 
        
        require( balances[msg.sender] >= amount, "Insufficient balance" ); 
        
         balances[msg.sender] -= amount; 
         
          (bool success, ) = payable(msg.sender).call{value: amount}(""); 
          
          require( success, "ETH transfer failed" ); emit Withdrawal( msg.sender, amount ); } 
          
          modifier nonReentrant() { require( !locked, "Reentrancy detected" ); 
          
          locked = true; 
          _; 
          
          locked = false; }
          
           receive() external payable {}
}

    contract ReentrancyAttacker { 
        
        ReentrancyVictim public victim; 
        
        uint256 public attackAmount; 
        
        bool public attacking; 
        
        event AttackStarted( uint256 amount ); 
        
        event CallbackReceived( uint256 amount ); 
        
        constructor(address payable _victim) { 
            
            victim = ReentrancyVictim(_victim); 
    }

    function attack() external payable { 
        
        require(msg.value > 0, "Send ETH"); 
        
        attackAmount = msg.value;

        victim.deposit{value: msg.value}(); 
        
        attacking = true; 
        
        emit AttackStarted(msg.value);

        victim.withdraw(msg.value); 
        
        attacking = false;
    }

        receive() external payable { 
            
        emit CallbackReceived(msg.value);

        if (attacking) { try victim.withdraw(attackAmount) {
        } catch {  } 
        } 
    }
}

contract ChainC { 
    
    uint256 public counter; 
    
    address public lastCaller; 
    
    event ChainStep( string contractName, address caller ); 
    
    function stepC() external { lastCaller = msg.sender; 
    
    counter++; 
    
    emit ChainStep( "Contract C", msg.sender ); 
    } 
}

contract ChainB { 
    
    ChainC public contractC; 
    
    uint256 public counter; 
    
    address public lastCaller; 
    
    constructor(address _c) { contractC = ChainC(_c); 
    }

    function stepB() external {
        lastCaller = msg.sender; counter++; emit ChainStep( "Contract B", msg.sender );
        contractC.stepC(); 
    }

    event ChainStep( string contractName, address caller );
}

contract ChainA { 
    
    ChainB public contractB; 
    
    uint256 public counter; 
    
    address public lastCaller; 
    
    constructor(address _b) { contractB = ChainB(_b); 
    }

    function stepA() external {
        lastCaller = msg.sender; 
        
        counter++; 
        
        emit ChainStep( "Contract A", msg.sender );

        contractB.stepB(); 
    } 
    
    event ChainStep( string contractName, address caller );
}