// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract OutOfGasDemoVul {
//     /*
//         STORAGE ARRAY
//     */
//     uint256[] public data;

//     /*
//     =====================================================
//     INFINITE LOOP RISK FUNCTION
//     =====================================================
//     */

//     function dangerousLoop() external  {
//         /*
//         =================================================
//         WARNING PATTERN
//         =================================================
//         This function loops over ALL stored data.

//         If array becomes large:
//         GAS LIMIT WILL BE EXCEEDED.
//         */
//         uint256 sum = 0;

//         for ( uint256 i = 0; i < data.length;i++) {
//             /*
//                 Storage read (expensive).
//             */
//             sum += data[i];
//             /*
//                 Additional storage write (very expensive).
//             */
//             data[i] = sum;
//         }
//     }
//     /*
//     =====================================================
//     ADD MANY VALUES
//     =====================================================
//     */

//     function addMany(uint256 n)external {
//         for ( uint256 i = 0; i < n; i++) {
//             data.push(i);
//         }
//     }

//     /*
//     =====================================================
//     SAFE BATCH VERSION
//     =====================================================
//     */

//     function safeProcess(uint256 limit) view  external{
//         /*
//             Limit loop size to avoid OOG.
//         */
//         require(limit <= 100, "Too large batch");
//         uint256 sum = 0;
//         for ( uint256 i = 0;i < limit;i++) {
//             sum += data[i];
//         }
//     }

//     /*
//     =====================================================
//     GET LENGTH
//     =====================================================
//     */

//     function getLength() external  view returns (uint256) {
//         return data.length;
//     }
// }

contract OutOfGasDemo {
    uint256[] public data;

    uint256 public nextIndex;

    uint256 public totalSum;

    uint256 public constant MAX_CHUNK_SIZE = 100;

    uint256 public constant MAX_ADD_SIZE = 1000;

    event ChunkProcessed(uint256 startIndex, uint256 endIndex, uint256 sum);

    event DataAdded(uint256 amount);

    function addMany(uint256 n) external {
        require(n <= MAX_ADD_SIZE, "Too many values");

        for(uint256 i = 0; i < n; i++) {
            data.push(i);
        }

        emit DataAdded(n);
    }    

    function unsafeProcessAll() external {
        uint256 sum = 0;

        for(uint256 i = 0; i < data.length; i++) {
            sum += data[i];

            data[i] = sum;

        }

        totalSum = sum;
    }

    function processChunk(uint256 chunkSize) external {
        require(chunkSize > 0, "Chunk cannot be zero");

        require(chunkSize <= MAX_CHUNK_SIZE,"Chunk too large");
        
        require(nextIndex < data.length,"Nothing left to process");

        uint256 startIndex = nextIndex;

        uint256 endIndex = nextIndex + chunkSize;

        if(endIndex > data.length) {
            endIndex = data.length;
        }

        uint256 chunkSum = 0;

        for(uint256 i = startIndex; i < endIndex; i++) {
            totalSum += chunkSum;

            nextIndex = endIndex;

            emit ChunkProcessed(startIndex, endIndex, chunkSum);
        }

    }

    function processDefaultChunk() external {
            require(nextIndex < data.length,"Nothing left to process");

            uint256 startIndex = nextIndex;

            uint256 endIndex = nextIndex + MAX_CHUNK_SIZE;

            if(endIndex > data.length) {
                endIndex = data.length;
            }

            uint256 chunkSum = 0;

            for(uint256 i = startIndex; i<endIndex; i++){
                chunkSum += data[i];
            }

            totalSum += chunkSum;

            nextIndex = endIndex;

            emit ChunkProcessed(startIndex, endIndex, chunkSum);
        }

        function estimateChunkGas(uint256 chunkSize) external view returns (uint256 estimatedGas) {
            require(chunkSize > 0, "Chunk cannot be zero");

            require(chunkSize <= MAX_CHUNK_SIZE,"chunk too large");

            uint256 beaseGas = 21000;

            uint256 gasPerIteration = 3000;

            estimatedGas = beaseGas + (chunkSize * gasPerIteration);

        }

        function remainingElements() external view returns (uint256) {
            if(nextIndex >= data.length) {
                return 0;
            }

            return data.length - nextIndex;
        }

        function getProcessingStatus() external view returns (uint256 arrayLength, uint256 processedIndex, uint256 remaining, uint currentSum) {
            arrayLength = data.length;
            processedIndex = nextIndex;

            if(nextIndex >= data.length) {
                remaining = 0;
            } else {
                remaining = data.length - nextIndex;
            }

            currentSum = totalSum;
        }

    function resetProcessing() external {
        nextIndex = 0;
        totalSum = 0;
    }

    function getLength() external view returns (uint256) {
        return data.length;
    }
}