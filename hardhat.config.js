require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = module.exports = {
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      gas:3000000
    },
    hardhat: {},
    testnet: {
      url: "https://rpc.testnet.fantom.network/",
      accounts: ['7a3eddf745f45d6d8828bc07df72e4f4431d99081aec537e5d811852cca27ca2'],
      chainId: 4002
    },
    mainnet: {
      url: "https://rpc.ftm.tools",
      accounts: ['7a3eddf745f45d6d8828bc07df72e4f4431d99081aec537e5d811852cca27ca2'],
      chainId: 250
    }
  },
  solidity: {
    version: "0.8.7",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 60000
  }
}

