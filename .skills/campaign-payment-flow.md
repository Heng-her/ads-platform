---

# `skills/campaign-payment-flow.md`

```md
# Skill: Advertising Campaign Payment Flow


## Purpose

Implement Web3 advertising payments.


---

# Campaign Lifecycle

Create Campaign

↓

Deposit Budget

↓

Run Ads

↓

Track Impression

↓

Calculate Payment

↓

Release Publisher Payment

---

# Example

Advertiser:

100 USDC budget

Campaign:

10,000 impressions

Cost:

0.01 USDC / impression

---

# Smart Contract

Store:

```solidity
campaignId

owner

budget

spent

status
```
