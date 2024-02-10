require("@nomiclabs/hardhat-waffle");
require("ethers");
require("dotenv").config({ path: ".env" });
module.exports = {
  solidity: "0.8.20",
  networks: {
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: {
        mnemonic: process.env.mnemonic, // line 25
        path: "m/44'/60'/0'/0", // line 26
      },
      chainId: 44787,
    },
  },
};