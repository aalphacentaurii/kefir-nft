import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from 'dotenv';
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  etherscan: {
    apiKey: {
      bscTestnet: process.env.NODE_API_KEY as string
    }
  },
  networks: {
    binance: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: [process.env.PRIVATE_KEY as string],
      chainId: 97,
    }
  }
};

export default config;
