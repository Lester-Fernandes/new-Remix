// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract CallTargetVul {
//     /*
//         TRACK EXECUTIONS
//     */
//     uint256 public counter;

//     /*
//     =====================================================
//     SUCCESS FUNCTION
//     =====================================================
//     */

//     function successFunction()external{
//         /*
//             Increment counter.
//         */
//         counter++;
//     }

//     /*
//     =====================================================
//     FAILING FUNCTION
//     =====================================================
//     */

//     function failFunction()   external   pure{
//         /*
//             Intentionally revert.
//         */
//         revert("Intentional failure");
//     }

//     /*
//     =====================================================
//     REJECT ETH
//     =====================================================
//     */

//     receive() external  payable{
//         /*
//             Reject ETH transfers.
//         */
//         revert("ETH rejected");
//     }
// }

// /*
// =========================================================
// SAFE CALLER CONTRACT
// =========================================================
// */

// contract SafeCallHandlerVul {
//     /*
//         TRACK RESULTS
//     */
//     bool public lastSuccess;

//     bytes public lastData;

//     uint256 public executionCounter;

//     /*
//     =====================================================
//     SAFE FUNCTION CALL
//     =====================================================
//     */

//     function safeFunctionCall(  address _target ) external{
//         /*
//             Local state update.
//         */
//         executionCounter++;

//         /*
//             Low-level external call.
//         */
//         (bool success, bytes memory data) = _target.call(abi.encodeWithSignature( "successFunction()"));
//         /*
//             Store results.
//         */
//         lastSuccess = success;

//         lastData = data;

//         /*
//         =================================================
//         SAFE HANDLING
//         =================================================

//         If external call failed:
//         transaction fully reverts.
//         */
//         require( success,  "External function call failed" );
//     }

//     /*
//     =====================================================
//     SAFE FAILING CALL
//     =====================================================
//     */

//     function safeFailingCall(  address _target)  external{
//         /*
//             Local state update.
//         */
//         executionCounter++;

//         /*
//             External call that fails.
//         */
//         (bool success, bytes memory data) = _target.call(abi.encodeWithSignature("failFunction()"));
//         /*
//             Save results.
//         */
//         lastSuccess = success;

//         lastData = data;

//         /*
//             SAFE FAILURE HANDLING.

//             Revert if call failed.
//         */
//         require(success, "External call reverted");
//     }
//     /*
//     =====================================================
//     SAFE ETH TRANSFER
//     =====================================================
//     */

//     function safeETHTransfer(address payable _target)  external payable {
//         /*
//             Attempt ETH transfer.
//         */
//         (bool success, bytes memory data) = _target.call{ value: msg.value }("");
//         /*
//             Store results.
//         */
//         lastSuccess = success;
//         lastData = data;

//         /*
//             SAFE CHECK.

//             Prevent silent ETH-transfer failure.
//         */
//         require(success,  "ETH transfer failed");
//     }
// }

contract CallTarget {
    uint256 public counter;

    function successFunction() external { 
        counter++; 
    }

    function failFunction() external pure { 
        revert("Intentional failure"); 
    }

    receive() external payable { 
        revert("ETH rejected"); 
    }
}

interface ICallTarget { 
    
    function successFunction() external; 

    function failFunction() external; 
}

contract SafeCallHand {
    bool public lastSuccess;

    bytes public lastdata;

    string public lastError;

    uint256 public executionCounter;

    event CallSucceeded( address indexed target, string functionName ); 
    
    event CallFailed( address indexed target, string functionName, string reason ); 
    
    event ETHTransferSucceeded( address indexed target, uint256 amount ); 
    
    event ETHTransferFailed( address indexed target, uint256 amount, string reason );

    function safeFunctionCall(address _target) external {
        executionCounter++; 
        
        ( bool success, bytes memory data ) = _target.call( abi.encodeWithSignature( "successFunction()" ) ); 
        
        lastSuccess = success; 
        
        lastdata = data;

        if (!success) { 
            
            string memory reason = decodeRevertMessage(data); 
            
            lastError = reason; emit CallFailed( _target, "successFunction", reason ); 
            
            revert(reason); } lastError = ""; 
            
            emit CallSucceeded( _target, "successFunction" ); 
    }  

    function safeFailingCall(address _target) external {
        executionCounter++; 
        
        ( bool success, bytes memory data ) = _target.call( abi.encodeWithSignature( "failFunction()" ) ); 
        
        lastSuccess = success; 
        
        lastdata = data;

        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        lastError = reason; emit CallFailed( _target, "failFunction", reason ); 
        
         revert(reason); } lastError = ""; 
         
         emit CallSucceeded( _target, "failFunction" );
    }

    function uncheckedFailingCall( address _target ) external { 
        
        executionCounter++; 
        
         _target.call( abi.encodeWithSignature( "failFunction()" ) ); 
         
         emit CallSucceeded( _target, "unchecked failFunction" ); 
    }

    function tryCatchFailure( address _target ) external { 
        
        executionCounter++; 
        
        try ICallTarget(_target).failFunction() 
        {lastSuccess = true; 
        
        lastError = ""; 
        
        emit CallSucceeded( _target, "failFunction" ); 
        } catch Error( string memory reason ) {
             lastSuccess = false; 
             
             lastError = reason; 
             
             emit CallFailed( _target, "failFunction", reason );
             
               } catch Panic( uint256 ) { 
                
                lastSuccess = false; 
                
                lastError = "Panic occurred"; 
                
                emit CallFailed( _target, "failFunction", "Panic occurred" ); 
                } catch { lastSuccess = false; 
                
                lastError = "Unknown failure"; 
                
                emit CallFailed( _target, "failFunction", "Unknown failure" ); 
            } 
        }

    function tryCatchSuccess( address _target ) external { 
        
        executionCounter++; 
        
        try ICallTarget(_target).successFunction() { lastSuccess = true; 
        
        lastError = ""; 
        
        emit CallSucceeded( _target, "successFunction" ); } catch Error( string memory reason ) { 
            
            lastSuccess = false; 
            
            lastError = reason; 
            
            emit CallFailed( _target, "successFunction", reason ); } catch { lastSuccess = false; 
            
            lastError = "Unknown failure"; 
            
            emit CallFailed( _target, "successFunction", "Unknown failure" ); 
        } 
    }

    function safeETHTransfer( address payable _target ) external payable { 
        
        require( msg.value > 0, "No ETH sent" ); 
        
        ( bool success, bytes memory data ) = _target.call{ value: msg.value }(""); 
        
        lastSuccess = success; lastdata = data; 
        
        if (!success) { string memory reason = decodeRevertMessage(data); 
        
        lastError = reason; 
        
        emit ETHTransferFailed( _target, msg.value, reason ); 
        
        revert(reason); } lastError = ""; 
        
        emit ETHTransferSucceeded( _target, msg.value ); 
    }

    function decodeRevertMessage( bytes memory _data ) public pure returns (string memory) {
        if (_data.length < 4) { return "Unknown revert reason"; } 
        
        bytes4 selector; 
        
        assembly { selector := mload( add(_data, 32) ) }
        
        if ( selector == bytes4(0x08c379a0) ) { bytes memory reasonData = new bytes( _data.length - 4 ); 
        
        for ( uint256 i = 4; i < _data.length; i++ ) { reasonData[i - 4] = _data[i]; } 
        
        return abi.decode( reasonData, (string) ); } 
        
        return "Unknown revert reason"; 
    }

    function contractBalance() external view returns (uint256) { 
        
        return address(this).balance; 
        
    }
}