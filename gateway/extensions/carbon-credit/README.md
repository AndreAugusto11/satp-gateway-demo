# Carbon Credit Extension (Toucan) — run carbon-credit-extension.py

This file shows how to run the carbon-credit-extension.py test flow that buys and retires TCO2s using the Gateway. Before running the main script you must fund the test account with USDC using Hardhat impersonation.

The main script performs these high-level actions:
- Requests available TCO2s ordered by supply.
- Selects 3 TCO2 tokens with at least 400 units (18 decimals) of liquidity in the NCT contract.
- Performs a specific buy of 3 TCO2s (400 units each) paying with USDC and checks asset amounts (expected 360 units after fees).
- Retires 200 units of each purchased TCO2 and verifies retirement certificates on-chain via the NFT contract.

---

## Flow Summary

1. Start the Gateway (if required for your test environment).
2. Start a Hardhat node configured to fork Polygon (so impersonation and on-chain queries work).
3. Use fund-usdc-to-address.py to impersonate and fund the testing account with USDC.
4. Run carbon-credit-extension.py — it will:
    - call get-available-tco2s,
    - choose three qualifying TCO2s,
    - call specific_buy_request,
    - call retire_request,
    - verify on-chain retirement certificate amounts.
5. Inspect printed output and any Gateway / node logs for transaction hashes and verification messages.

---

## Terminal Overview

- Terminal 1: Gateway (Docker Compose) — optional, if Gateway endpoints are required by the script.
- Terminal 2: Hardhat (local fork of Polygon with impersonation enabled)
- Terminal 3: Run fund-usdc-to-address.py to fund the test account
- Terminal 4: Run carbon-credit-extension.py and observe outputs (or use same terminal as Terminal 3 if you prefer)

---

## Setup Instructions

### 1. Start the Gateway (Docker) — if applicable

If your test requires the local Gateway, from this directory:

```bash
docker compose up
```

This will start the Gateway using your environment config.

---

### 2. Start Hardhat with Polygon fork and impersonation enabled

Start a Hardhat node configured to fork Polygon (RPC URL and block number configured in hardhat.config.js). Ensure the node is reachable from Docker if the Gateway is used (use --hostname 0.0.0.0).

Example (from https://github.com/AndreAugusto11/polygon-fork-77660000):

```bash
npx hardhat node --network hardhat
```

Note: for impersonation to work, configure forking in hardhat.config.js (point to a Polygon RPC) or start the node in a way that forks Polygon state.

---

### 3. Fund the testing account with USDC (impersonation)

Before running the carbon-credit script you must fund the USER/test address with USDC on the fork. Use the provided script:

```bash
python3 fund-usdc-to-address.py
```

**Expected Result**:
- The script impersonates a rich USDC holder (via Hardhat) and transfers sufficient USDC to the test address.
- You should see logs confirming the USDC transfer and the recipient address balance.

---

### 4. Run the carbon credit extension script

From this directory, run:

```bash
python3 carbon-credit-extension.py
```

**Expected Result**:

What to expect (key printed lines from the script):
- "Requesting TCO2s ordered by supply..."
- Logs showing selected TCO2 addresses and projectId values.
- "Performing specific buy..." and details including txHashSwap, buyTxHash, assetAmounts.
- "Performing retire..." followed by certificate creation messages, e.g. "Retirement certificate <id> created."
- "Verifying retirement certificate amounts on-chain..." with on-chain retired amounts and a final success message.

The script will raise exceptions and exit if:
- No TCO2s are returned.
- Fewer than 3 TCO2s have sufficient NCT liquidity.
- specificBuy response lacks expected fields or amounts.
- retire response lacks expected tx hashes or certificate ids.
- On-chain retired amounts do not match expected values (200 * 1e18).

---

## Troubleshooting & Logs

- Check Hardhat terminal for impersonation and transaction logs.
- If the script fails when querying balances, ensure the provider URL is correct and the token addresses are in checksum format.
- Gateway logs (if used) are in ./satp-hermes-gateway/logs/ relative to this directory for request/response details.
