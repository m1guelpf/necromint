import { ethers, run } from "hardhat";

async function main() {
  const Necromint = await ethers.getContractFactory("Necromint");
  const contract = await Necromint.deploy();

  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
  run("verify:verify", { address: contract.address, constructorArguments: [] });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
