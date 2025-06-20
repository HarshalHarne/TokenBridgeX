const { ethers } = require("hardhat");

async function main() {
  const TokenBridgeX = await ethers.getContractFactory("TokenBridgeX");
  const tokenBridge = await TokenBridgeX.deploy();

  await tokenBridge.deployed();

  console.log("TokenBridgeX deployed to:", tokenBridge.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
