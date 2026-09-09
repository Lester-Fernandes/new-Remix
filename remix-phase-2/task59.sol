// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract RejectorVul {

//     /*
//         TRACK CALL COUNT
//     */
//     uint256 public callCounter;

//     /*
//     =====================================================
//     NORMAL FUNCTION
//     =====================================================
//     */

//     function normalFunction()
//         external
//     {

//         callCounter++;
//     }

//     /*
//     =====================================================
//     ALWAYS FAIL
//     =====================================================

//     Intentionally reverts.
//     */

//     function alwaysFail()
//         external
//         pure
//     {

//         revert("Intentional failure");
//     }

//     /*
//     =====================================================
//     REJECT ETH
//     =====================================================

//     Reject plain ETH transfers.
//     */

//     receive()
//         external
//         payable
//     {

//         revert("ETH rejected");
//     }
// }

// /*
// =========================================================
// CALLER CONTRACT
// =========================================================
// */

// contract ExternalCallHandlerVul {

//     /*
//         TRACK RESULTS
//     */
//     bool public lastSuccess;
//     bytes public lastData;
//     uint256 public localCounter;

//     /*
//     =====================================================
//     SAFE EXTERNAL CALL
//     =====================================================
//     */

//     function safeExternalCall(
//         address _target
//     )
//         external
//     {

//         /*
//             Local state update BEFORE call.
//         */
//         localCounter++;

//         /*
//             Low-level external call.
//         */
//         (bool success, bytes memory data) =
//             _target.call(
//                 abi.encodeWithSignature(
//                     "normalFunction()"
//                 )
//             );

//         /*
//             Store results.
//         */
//         lastSuccess = success;

//         lastData = data;

//         /*
//             Require success.
//         */
//         require(
//             success,
//             "External call failed"
//         );
//     }

//     /*
//     =====================================================
//     CALL FAILING FUNCTION
//     =====================================================
//     */

//     function triggerFailure(
//         address _target
//     )
//         external
//     {

//         /*
//             Local state update FIRST.
//         */
//         localCounter++;

//         /*
//             Call reverting function.
//         */
//         (bool success, bytes memory data) =
//             _target.call(
//                 abi.encodeWithSignature(
//                     "alwaysFail()"
//                 )
//             );

//         /*
//             Save results.
//         */
//         lastSuccess = success;

//         lastData = data;

//         /*
//             IMPORTANT:
//             success = false

//             Manual failure handling required.
//         */
//         require(
//             success,
//             "Low-level call failed"
//         );
//     }

//     /*
//     =====================================================
//     SEND ETH TO REJECTOR
//     =====================================================
//     */

//     function sendETH(
//         address payable _target
//     )
//         external
//         payable
//     {

//         /*
//             Attempt ETH transfer.
//         */
//         (bool success, bytes memory data) =
//             _target.call{
//                 value: msg.value
//             }("");

//         /*
//             Save result.
//         */
//         lastSuccess = success;

//         lastData = data;

//         /*
//             Revert if transfer failed.
//         */
//         require(
//             success,
//             "ETH transfer rejected"
//         );
//     }
// }

contract Rejector {
    uint256 public callCounter;

    function normalFunction() external {
        callCounter++;
    }

    function alowaysFail() external pure {
        revert("Intertional failure");
    }

    error CustomFailure(uint256 code);

    function failWithCustomError() external pure {
        revert CustomFailure(404);
    }

    receive() external payable {
        revert("ETH rejected");
    }
}

interface IRejector { 
    function normalFunction() external; 
    
    function alwaysFail() external; 
    
    function failWithCustomError() external; 
    }

    contract ExternalCallHandler {
        bool public lastSuccess;

        bytes public lastData;

        uint256 public localCounter;

        string public lastError;

        event CallSuccessed(address indexed target);

        event CallFailed(address indexed target, string reason);

        event ETHTransferFailed(address indexed target, uint256 amount);

        function callWithoutRevert(address _target) external returns(bool success, bytes memory data) {
            localCounter++; 
            
            ( success, data ) = _target.call( abi.encodeWithSignature( "alwaysFail()" ) ); 
            
            lastSuccess = success; 
            
            lastData = data;

            if (success) { emit CallSuccessed( _target ); 
            } else { 
            string memory reason = decodeRevertMessage(data); 
            
            lastError = reason; 
            
            emit CallFailed( _target, reason );
        }
    }

    function tryCatch(address _target) external {
        localCounter++;

        try IRejector(_target).alwaysFail() {
            lastSuccess = true; lastError = ""; 
            
            emit CallSuccessed( _target );
        }

        catch Error(string memory reason) {
            lastSuccess = false; 
            
            lastError = reason; 
            
            emit CallFailed( _target, reason );
        }

        catch Panic(uint256 errorCode) {
            lastSuccess = false; 
            
            lastError = "Panic error"; 
            
            emit CallFailed( _target, lastError );
        }

        catch(bytes memory) {
           lastSuccess = false; 
           
           lastError = "Unknown external error"; 
           
           emit CallFailed( _target, lastError ); 
        }
    }

    function decodeRevertMessage(bytes memory _data) public pure returns (string memory) {
        if(_data.length >= 4) {
            bytes4 selector;

            assembly {
                selector := mload(add(_data, 2))
            }

            if(selector == bytes4(0x08c379a0))
            {
                bytes memory reasonData = new bytes( _data.length - 4 ); 
                
                for ( uint256 i = 4; i < _data.length; i++ ) 
                
                { reasonData[i - 4] = _data[i]; } 
                
                return abi.decode( reasonData, (string) );
            }
        }

        return "Unknow revert reason";
    }

    function LowLevelSuccessFulCall(address _target) external {
        ( bool success, bytes memory data ) = _target.call( abi.encodeWithSignature( "normalFunction()" ) ); 
        
        lastSuccess = success; lastData = data; 
        
        if (success) { emit CallSuccessed( _target ); 
        
        } else { lastError = decodeRevertMessage( data ); 
        
        emit CallFailed( _target, lastError ); 

        }
    }

    function interfaceCall(address _target) external {
        try IRejector(_target).normalFunction() 
        { 
            lastSuccess = true; lastError = "";
        
        emit CallSuccessed( _target ); 
        
        } catch Error( string memory reason ) 
        { lastSuccess = false; lastError = reason; 
        
        emit CallFailed( _target, reason ); 
        
        } catch { lastSuccess = false; 
        
        lastError = "Interface call failed"; 
        
        emit CallFailed( _target, lastError ); 
        }
    }

    function sendETHWithoutRevert(address payable _target) external payable returns (bool success) {
        ( success, ) = _target.call{ value: msg.value }(""); 
        
        lastSuccess = success; 
        
        if (!success) { lastError = "ETH transfer failed"; 
        
        emit ETHTransferFailed( _target, msg.value );
        }
    }

    function getLastError() external view returns (string memory) {
        return lastError;
    }
}
    