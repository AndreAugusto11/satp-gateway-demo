require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    hardhat1: {
      url: "http://0.0.0.0:8545",
    },
    hardhat2: {
      url: "http://0.0.0.0:8546",
      accounts: ["0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"],
    }
  },
};
