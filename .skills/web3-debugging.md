---

# `skills/web3-debugging.md`

```md
# Skill: Web3 Debugging


## Purpose

Debug blockchain transaction problems.


---

# Transaction States

Pending

↓

Confirmed

↓

Success

or

Failed

↓

Reverted

---

# Common Errors

## User Reject

Code:
4001

Meaning:

User cancelled wallet popup.

---

## Insufficient Funds

Reasons:

- no ETH gas
- low token balance

---

## Allowance Error

Check:

```solidity
allowance(
user,
spender
)
```
