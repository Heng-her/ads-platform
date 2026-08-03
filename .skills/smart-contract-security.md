---

# `skills/smart-contract-security.md`

```md
# Skill: Smart Contract Security


## Purpose

Identify vulnerabilities in Solidity contracts.


---

# Reentrancy

Danger:

External call before state update.

Bad:

```solidity
sendMoney();

balance = 0;
```
