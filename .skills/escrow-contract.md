---

# `skills/escrow-contract.md`

```md
# Skill: Escrow Smart Contract

## Purpose

Build secure payment escrow systems.

Used for:

- Advertising payments
- Marketplace
- Freelance payments
- Subscription


---

# Escrow Architecture

User

↓

Deposit

↓

Escrow Contract

↓

Condition Met

↓

Release Payment

or

Refund User

---

# Required Functions

## deposit()

Purpose:

Lock user funds.

Example:

```solidity
function deposit(
    uint256 amount
)
external
{
    token.transferFrom(
        msg.sender,
        address(this),
        amount
    );
}
```
