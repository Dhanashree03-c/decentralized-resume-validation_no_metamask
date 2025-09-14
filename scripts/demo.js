// scripts/demo.js
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with:", deployer.address);

  // Compile + Deploy
  const ResumeRegistry = await hre.ethers.getContractFactory("ResumeRegistry");
  const registry = await ResumeRegistry.deploy();

  // ✅ Ethers v6: no need for registry.deployed()
  await registry.waitForDeployment();

  console.log("Contract deployed at:", await registry.getAddress());

  // Register deployer as issuer
  let tx = await registry.registerIssuer(deployer.address);
  await tx.wait();
  console.log("Issuer registered");

  // Issue resume for some subject (using second account)
  const [_, subject] = await hre.ethers.getSigners();
  tx = await registry.issueResume(subject.address, "sample-cid-or-url");
  await tx.wait();
  console.log("Resume issued for subject:", subject.address);

  // Lookup latest resume
  const latest = await registry.getLatestResume(subject.address);
  console.log("Latest Resume Lookup:");
  console.log("Issuer:", latest[0]);
  console.log("CID:", latest[1]);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
