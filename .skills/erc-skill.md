# Skill: ERC-20 Approval & Escrow Payment Flow

## Purpose

This skill helps implement, review, and debug ERC-20 payment flows using the standard approval pattern.

The agent should understand the difference between:

- approve()
- allowance()
- transfer()
- transferFrom()

and know when each should be used.

---

# ERC-20 Payment Flow

The standard payment flow is:

```
User Wallet
    │
    ▼
approve(spender, amount)
    │
    ▼
ERC20 Token Contract
    │
    ▼
Allowance Stored
    │
    ▼
Escrow Contract
    │
transferFrom(user, escrow, amount)
    │
    ▼
Funds Locked
```

Never assume approve() transfers tokens.

approve() ONLY grants spending permission.

Tokens move only when transferFrom() is executed.

---

# Responsibilities

When reviewing code:

1. Detect approve() usage.
2. Verify allowance amount.
3. Detect unlimited approvals.
4. Detect transferFrom().
5. Verify spender address.
6. Verify escrow security.
7. Detect unsafe token handling.
8. Explain approval lifecycle.

---

# Approval Rules

Safe:

```ts
approve(escrowAddress, parseUnits("10", 6));
```

Unsafe:

```ts
approve(escrowAddress, MaxUint256);
```

Unless explicitly required.

Always warn when unlimited approval is detected.

---

# Escrow Flow

Expected architecture:

Frontend

↓

Connect Wallet

↓

Approve Token

↓

Call Escrow.deposit()

↓

Escrow

↓

transferFrom(user, escrow)

↓

Store Deposit

↓

Release / Refund

---

# Frontend Checklist

Verify:

✓ Wallet connected

✓ Correct chain

✓ Correct token

✓ Correct decimals

✓ Correct spender

✓ Correct amount

✓ Wait for confirmation

✓ Handle rejected transaction

---

# Smart Contract Checklist

Escrow should:

- validate amount
- validate allowance
- use SafeERC20
- emit events
- prevent reentrancy
- store deposits
- support refunds
- support release

---

# Security Rules

Warn if:

- MaxUint256 approval
- arbitrary spender
- transferFrom without checks
- missing access control
- missing events
- missing ReentrancyGuard
- missing SafeERC20
- unchecked external calls

---

# Common Mistakes

❌ approve() moves funds

Correction:

approve() only creates allowance.

---

❌ transfer() can pull user funds

Correction:

Only transferFrom() can spend approved tokens.

---

❌ User signs only once

Correction:

Usually there are two transactions:

1. approve()
2. deposit()

Permit (EIP-2612) is an exception.

---

# Agent Behavior

When analyzing code:

- Explain every blockchain interaction.
- Distinguish frontend from smart contract logic.
- Identify security risks.
- Recommend best practices.
- Never assume funds move after approve().
- Always verify whether transferFrom() exists.

---

# Best Practices

Use:

- OpenZeppelin SafeERC20
- ReentrancyGuard
- Ownable or AccessControl
- Events
- Custom Errors
- Pull over Push payments

Avoid:

- Unlimited approvals
- Hardcoded addresses in production
- Silent failures
- Missing transaction confirmation

---

# Learning Goal

The agent should be able to:

- Review ERC20 payment code
- Explain allowance mechanics
- Build escrow payment flow
- Detect security vulnerabilities
- Recommend production-ready architecture
