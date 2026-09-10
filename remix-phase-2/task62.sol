// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract ContractCVul {

//     /*
//         TRACK EXECUTION
//     */
//     uint256 public counter;

//     /*
//     =====================================================
//     FINAL EXECUTION
//     =====================================================
//     */

//     function finalStep() external {
//         /*
//             Increment execution counter.
//         */
//         counter++;
//     }

//     /*
//     =====================================================
//     FAILING FUNCTION
//     =====================================================
//     */

//     function failStep() external  pure {
//         revert("Contract C failure");
//     }
// }

// /*
// =========================================================
// CONTRACT B
// MIDDLE CONTRACT
// =========================================================
// */

// contract ContractBVul {
//     /*
//         STORE CONTRACT C
//     */
//     ContractCVul public contractC;

//     /*
//         TRACK EXECUTION
//     */
//     uint256 public middleCounter;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _contractC){
//         contractC = ContractCVul(_contractC);
//     }

//     /*
//     =====================================================
//     CALL CONTRACT C
//     =====================================================
//     */

//     function callFinalStep() external{
//         /*
//             Local state update.
//         */
//         middleCounter++;

//         /*
//             EXTERNAL CALL:
//             Contract B -> Contract C
//         */
//         contractC.finalStep();
//     }

//     /*
//     =====================================================
//     CALL FAILING FUNCTION
//     =====================================================
//     */

//     function callFailingStep()  external {
//         /*
//             State update.
//         */
//         middleCounter++;

//         /*
//             External call that reverts.
//         */
//         contractC.failStep();
//     }
// }

// /*
// =========================================================
// CONTRACT A
// ENTRY CONTRACT
// =========================================================
// */

// contract ContractAVul {
//     /*
//         STORE CONTRACT B
//     */
//     ContractBVul public contractB;

//     /*
//         TRACK EXECUTION
//     */
//     uint256 public entryCounter;

//     /*
//         CONSTRUCTOR
//     */
//     constructor(address _contractB) {
//         contractB = ContractBVul(_contractB);
//     }

//     /*
//     =====================================================
//     START EXECUTION CHAIN
//     =====================================================
//     */

//     function startChain() external{
//         /*
//             Local state update.
//         */
//         entryCounter++;
//         /*
//             EXTERNAL CALL:
//             Contract A -> Contract B
//         */
//         contractB.callFinalStep();
//     }

//     /*
//     =====================================================
//     START FAILING CHAIN
//     =====================================================
//     */

//     function startFailingChain() external{
//         /*
//             State update.
//         */
//         entryCounter++;
//         /*
//             Nested call chain eventually fails.
//         */
//         contractB.callFailingStep();
//     }
// }

contract ContractnewC{
    uint256 public counter; 
    
    event FinalStepExecuted( address indexed caller ); 
    
    event ETHReceived( address indexed sender, uint256 amount );

    function finalStep() external { 
        
        counter++; 
        
        emit FinalStepExecuted( msg.sender ); 
    }

    function failStep() external pure { 
        
        revert("Contract C failure"); 
    }

    receive() external payable { 
        
        emit ETHReceived( msg.sender, msg.value ); 
    }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
    }
}

contract ContractB {
    ContractnewC public contractC; 
    
    uint256 public middleCounter; 
    
    bool private locked;

    event MiddleStepExecuted( address indexed caller ); 
    
    event ETHSent( address indexed receiver, uint256 amount ); 
    
    event CallFailed( string reason );

    constructor( address payable _contractC ) { 
        
        require( _contractC != address(0), "Invalid C address" ); 
    
        contractC = ContractnewC(_contractC); 
    }

    modifier nonReentrant() { 
        
        require( !locked, "Reentrancy blocked" ); 
        
        locked = true; _; 
        
        locked = false; 
    }

    function callFinalStep() external nonReentrant { 
        
        middleCounter++; 
        
        contractC.finalStep(); 
        
        emit MiddleStepExecuted( msg.sender ); 
    }

    function callFailingStep() external nonReentrant { 
        
        middleCounter++; 
        
        contractC.failStep(); 
        
        emit MiddleStepExecuted( msg.sender ); 
    }

    function lowLevelFinalStep() external nonReentrant { 
        
        middleCounter++; 
        
        ( bool success, bytes memory data ) = address(contractC).call( abi.encodeWithSignature( "finalStep()" ) );
        
        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        emit CallFailed(reason); 
        
        revert(reason); } 
        
        emit MiddleStepExecuted( msg.sender ); 
    }

    function tryCatchFinalStep() external nonReentrant { 
        
        middleCounter++; 
        
        try contractC.finalStep() { 
            
            emit MiddleStepExecuted( msg.sender ); 
        } catch Error( string memory reason ) { 
            
            emit CallFailed(reason); revert(reason); 
        } catch { 
            
            emit CallFailed( "Unknown failure" ); revert( "Unknown failure" ); 
        } 
    }

    function tryCatchFailingStep() external nonReentrant { 
        
        middleCounter++; 
        
        try contractC.failStep() { 
            
            emit MiddleStepExecuted( msg.sender ); 
        } catch Error( string memory reason ) { 
            emit CallFailed(reason); revert(reason); 
        } catch { emit CallFailed( "Unknown failure" ); 
        
        revert( "Unknown failure" ); 
        } 
    }

    function sendETHToC() external payable nonReentrant { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, ) = payable(address(contractC)).call{ value: msg.value }(""); 
        
        require( success, "ETH transfer failed" ); 
        
        emit ETHSent( address(contractC), msg.value ); 
    }

    function decodeRevertMessage( bytes memory _data ) public pure returns (string memory) { 
        
        if (_data.length < 4) { return "Unknown revert reason"; } 
        
        bytes4 selector; assembly { selector := mload( add(_data, 32) ) } 
        
        if ( selector == bytes4(0x08c379a0) ) { 
            
            bytes memory reasonData = new bytes( _data.length - 4 ); 
            
            for ( uint256 i = 4; i < _data.length; i++ ) { reasonData[i - 4] = _data[i]; } return abi.decode( reasonData, (string) ); 
            

            } 
            
            return "Unknown revert reason";
    }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
    }    

    receive() external payable {}
}

contract contractA {
    ContractB public contractB; 
    
    uint256 public entryCounter; 
    
    event EntryStarted( address indexed caller ); 
    
    event ChainCompleted();

    constructor( address payable _contractB ) { 
        
        require( _contractB != address(0), "Invalid B address" ); 
        
        contractB = ContractB(_contractB); 
    }

    function startChain() external { 
        
        entryCounter++; 
        
        emit EntryStarted( msg.sender ); 
        
        contractB.callFinalStep(); 
        
        emit ChainCompleted(); 
    }

    function startFailingChain() external { 
        
        entryCounter++; 
        
        emit EntryStarted( msg.sender ); 
        
        contractB.callFailingStep(); 
        
        emit ChainCompleted(); 
    }

    function startLowLevelChain() external { 
        
        entryCounter++; 
        
        ( bool success, ) = address(contractB).call( abi.encodeWithSignature( "lowLevelFinalStep()" ) ); 
        
        require( success, "B call failed" ); 
    }

    function startTryCatchChain() external { 
        
        entryCounter++; 
        
        try contractB.tryCatchFinalStep() { 
            
            emit ChainCompleted(); } catch Error( string memory reason ) { 
                
                revert(reason); } catch { revert( "Chain failed" ); 
            } 
    }

    function sendETHToC() external payable { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, ) = address(contractB).call{ value: msg.value }( abi.encodeWithSignature( "sendETHToC()" ) );
        
         require( success, "ETH chain failed" ); 
         
        }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
    }

    receive() external payable {}     
}

contract MaliciousReentrant { 
    
    ContractB public target; 
    
    uint256 public attackCount; 
    
    uint256 public maxAttacks = 3; 
    
    bool public attacking; event Reentered( uint256 count );

    constructor( address payable _target ) { 
        
        require( _target != address(0), "Invalid target" ); 
        
        target = ContractB(_target); 
    }

    function attack() external { 
        
        attackCount = 0; attacking = true; 
        
        target.callFinalStep(); 
        
        attacking = false; 
        
    }

    fallback() external { 
        
        if ( attacking && attackCount < maxAttacks ) { 
            
            attackCount++; 
            
            emit Reentered( attackCount ); 
            
            target.callFinalStep(); 
        } 
    }

    receive() external payable { 
        
        if ( attacking && attackCount < maxAttacks ) { 
            
            attackCount++; 
            
            emit Reentered( attackCount ); 
            
            target.callFinalStep(); 
            
        }     
    }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
    }    
}
