// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TokenBridgeX {
    address public admin;
    mapping(bytes32 => bool) public processedTxs;

    event TokensLocked(address indexed user, address token, uint256 amount, string targetChain, bytes32 txHash);
    event TokensReleased(address indexed user, address token, uint256 amount, bytes32 sourceTxHash);

    constructor() {
        admin = msg.sender;
    }

    // Function 1: Lock tokens on the source chain
    function lockTokens(address token, uint256 amount, string calldata targetChain, bytes32 txHash) external {
        require(!processedTxs[txHash], "Transaction already processed");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");

        processedTxs[txHash] = true;
        emit TokensLocked(msg.sender, token, amount, targetChain, txHash);
    }

    // Function 2: Release tokens on the destination chain
    function releaseTokens(address token, address to, uint256 amount, bytes32 sourceTxHash) external {
        require(msg.sender == admin, "Only admin can release tokens");
        require(!processedTxs[sourceTxHash], "Transaction already processed");

        processedTxs[sourceTxHash] = true;
        require(IERC20(token).transfer(to, amount), "Transfer failed");

        emit TokensReleased(to, token, amount, sourceTxHash);
    }

    // Function 3: Check if a txHash has been processed
    function isProcessed(bytes32 txHash) external view returns (bool) {
        return processedTxs[txHash];
    }

    // Function 4: Update bridge admin
    function updateAdmin(address newAdmin) external {
        require(msg.sender == admin, "Only admin can update");
        admin = newAdmin;
    }
}
