# Skill: ERC20 Approval Pattern

## Purpose

Understand and implement ERC-20 token approval flows.

The agent must understand:

- approve()
- allowance()
- transfer()
- transferFrom()

---

# Core Concept

ERC20 tokens do not allow contracts to directly take user funds.

The user must first approve a spender.

Flow:

User Wallet

↓

approve(spender, amount)

↓

ERC20 Contract stores allowance

↓

spender calls transferFrom()

↓

Tokens move

---

# Functions

## approve()

Purpose:

Give permission to another address to spend tokens.

Example:

```solidity
token.approve(
    spender,
    amount
);
```
