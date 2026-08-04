import { ref } from "vue";

export const activeSandboxTab = ref<"campaigns" | "analytics" | "escrow">(
  "campaigns",
);

export const tabs = [
  { id: "campaigns", label: "Active Campaigns" },
  { id: "analytics", label: "CPM & Reach Telemetry" },
  { id: "escrow", label: "Escrow Audit Log" },
] as const;

export const campaigns = ref([
  {
    id: 1,
    name: "DeFi Protocol Launch Campaign",
    status: "Escrow Active",
    budget: "$10,000 USDC",
    impressions: "1,240,000",
    cpm: "$4.20",
    progress: 65,
  },
  {
    id: 2,
    name: "Web3 Gaming NFT Sponsor",
    status: "Escrow Active",
    budget: "$15,000 USDC",
    impressions: "2,890,500",
    cpm: "$3.90",
    progress: 82,
  },
  {
    id: 3,
    name: "AI Trading Platform Awareness",
    status: "Escrow Active",
    budget: "$25,000 USDC",
    impressions: "5,120,000",
    cpm: "$4.85",
    progress: 43,
  },
]);

export const telemetry = ref([
  40, 65, 80, 55, 90, 75, 95, 110, 85, 120, 100, 130,
]);

export const escrowLogs = ref([
  {
    tx: "0x91a...44f2",
    action: "Released $12.50 USDC to 0x71C...39A1",
    status: "Proof Verified",
    block: "#21940120",
    color: "text-emerald-400",
  },
  {
    tx: "0x88c...10b9",
    action: "Released $45.00 USDC to 0x12D...90FE",
    status: "Proof Verified",
    block: "#21940118",
    color: "text-emerald-400",
  },
  {
    tx: "0x33e...99a0",
    action: "Campaign Escrow Deposited $10,000 USDC",
    status: "Escrow Locked",
    block: "#21940080",
    color: "text-teal-400",
  },
  {
    tx: "0xaa8...72ef",
    action: "Publisher Reward Claimed $85.25 USDC",
    status: "Settlement Complete",
    block: "#21939990",
    color: "text-cyan-400",
  },
]);
