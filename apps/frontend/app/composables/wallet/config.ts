import type { ChainConfigMapping, TronChainDetails } from "./types";

// Chain Configuration Mapping (Arbitrum One, Sepolia, Mainnet)
export const CHAIN_CONFIG: ChainConfigMapping = {
  // Arbitrum One (0xa4b1 / 42161)
  "0xa4b1": {
    chainName: "Arbitrum One",
    USDC: "0xaf88d065e77c8cC2239327C5EDb3A432268e5831",
    USDT: "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9",
    WETH: "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1",
    escrowSpender: "0x8F4A1209e99211B6554e209867b140730A584412",
  },
  "42161": {
    chainName: "Arbitrum One",
    USDC: "0xaf88d065e77c8cC2239327C5EDb3A432268e5831",
    USDT: "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9",
    WETH: "0x82aF49447D8a07e3bd95BD0d56f35241523fBab1",
    escrowSpender: "0x8F4A1209e99211B6554e209867b140730A584412",
  },
  // Sepolia Testnet (0xaa36a7 / 11155111)
  "0xaa36a7": {
    chainName: "Sepolia Testnet",
    USDC: "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
    USDT: "0x7169D388206751599E10E5B70824b219D3F376d5",
    WETH: "0x7b79995e5f793a07bc00c21412e50ecae098e7f9",
    escrowSpender: "0x8F4A1209e99211B6554e209867b140730A584412",
  },
  "11155111": {
    chainName: "Sepolia Testnet",
    USDC: "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
    USDT: "0x7169D388206751599E10E5B70824b219D3F376d5",
    WETH: "0x7b79995e5f793a07bc00c21412e50ecae098e7f9",
    escrowSpender: "0x8F4A1209e99211B6554e209867b140730A584412",
  },
  // Ethereum Mainnet (0x1 / 1)
  "0x1": {
    chainName: "Ethereum Mainnet",
    USDC: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
    USDT: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
    WETH: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    escrowSpender: "0x8F4A1209e99211B6554e209867b140730A584412",
  },
  "1": {
    chainName: "Ethereum Mainnet",
    USDC: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
    USDT: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
    WETH: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    escrowSpender: "0x8F4A1209e99211B6554e209867b140730A584412",
  },
};

export const TRON_CONFIG = {
  mainnet: {
    chainName: "TRON Mainnet",
    USDT: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t",
    escrowSpender: "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // Configured designated TRON spender
  },
};

// Standard ERC-20 Approval & Balance ABI
export const ERC20_ABI = [
  "function approve(address spender, uint256 amount) public returns (bool)",
  "function allowance(address owner, address spender) public view returns (uint256)",
  "function balanceOf(address account) public view returns (uint256)",
  "function transfer(address to, uint256 amount) public returns (bool)",
  "function transferFrom(address from, address to, uint256 amount) public returns (bool)",
  "function symbol() public view returns (string)",
  "function decimals() public view returns (uint8)",
];

// Default Mock/Escrow Spender Address
export const AD_ESCROW_CONTRACT_ADDRESS = "0x8F4A1209e99211B6554e209867b140730A584412";

export const USDC_ADDRESSES = [
  "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // Mainnet
  "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238", // Sepolia
  "0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8", // Sepolia 2
  "0xaf88d065e77c8cC2239327C5EDb3A432268e5831", // Arbitrum
  "0x176211869cA2b568f2A7D4EE941E073a821EE1ff", // Linea
  "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913", // Base
  "0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359", // Polygon
];

export const USDT_ADDRESSES = [
  "0xdAC17F958D2ee523a2206206994597C13D831ec7", // Mainnet
  "0xFd086bC7cd5C481DCC9C85ebE478A1C0b69FCbb9", // Arbitrum
  "0xc2132D05D31c914a87C6611C10748AEb04B58e8F", // Polygon
];
