// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
    const Ftg = await ethers.getContractFactory("FantomonTrainer");
    let ftg = await Ftg.deploy('0x406e0a6d2dfd526c2b44628990ebf98535890606');

    await ftg.deployed();
    console.log("FTG : " + ftg.address)
    const Journey = await ethers.getContractFactory("Journey");
    let journey = await Journey.deploy(ftg.address);
    await journey.deployed()
    console.log("Journey : " + journey.address)


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
