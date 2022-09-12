import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const INFURA_PROJECT_ID: string = process.env.INFURA_PROJECT_ID || "";
const PRIVATE_KEY: string = process.env.PRIVATE_KEY || "";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    local: {
      url: `http://127.0.0.1:8545`,
      accounts: ['960f4e665d820f5195b31b99476f1b44ef296612d2f1b4e7bfad91003784ec3b'],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [PRIVATE_KEY],
    },
  },
};

export default config;
