// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
/* global BigInt */


const hre = require("hardhat");

async function main() {
  const MaxNumberOfWhitelistedAddresses = 250
  const SevenDaysInSeconds = 7 * 24 * 60 * 60
  // 0.1 ether in wei = 0.1 * 10 ** 18
  const FloorPrice = 0.1 * 10 ** 18

  const LostHopeSocietyNft = await hre.ethers.getContractFactory("LostHopeSocietyNft");
  const contract = await LostHopeSocietyNft.deploy(BigInt(MaxNumberOfWhitelistedAddresses), BigInt(SevenDaysInSeconds), BigInt(FloorPrice));

  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
  console.log(`Max number of whitelisted addresses = ${MaxNumberOfWhitelistedAddresses}`)
  console.log(`Whitelist time = ${SevenDaysInSeconds}`)
  console.log(`FLoor price = ${FloorPrice}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
