# SATP Gateway Demo

This repository contains a demo implementation of a **SATP (Secure Asset Transfer Protocol) Gateway**, designed to act as middleware between EVM-based blockchains. It supports various interoperability use cases explained below.

## Table of Contents
- [SATP Gateway Demo](#satp-gateway-demo)
  - [Table of Contents](#table-of-contents)
  - [Repository Structure](#repository-structure)
  - [Case Descriptions](#case-descriptions)
    - [Oracle Cases (gateway/oracle)](#oracle-cases-gatewayoracle)
    - [SATP Cases (satp/)](#satp-cases-satp)
  - [EVM Test Environment](#evm-test-environment)
  - [Important Instructions](#important-instructions)
  - [Setup & Running](#setup--running)
  - [Dependencies](#dependencies)
  - [Contact](#contact)

## Repository Structure

```
.
├── EVM/                           # Hardhat project for setting up test EVM blockchains
├── gateway/
│   └── oracle/
│       ├── case_1/               # Middleware: Manual READ and WRITE
│       ├── case_2/               # Middleware: Auto READ and WRITE
│       ├── case_3/               # Register polling for periodic READ
│       ├── case_4/               # Event listening + READ and UPDATE
├── satp/
│   └── case_1/                   # SATP Protocol: Asset transfer between EVM blockchains
```

---

## Case Descriptions

### Oracle Cases (gateway/oracle)

These use cases demonstrate the usage of the gateway as middleware to interact with EVM blockchains:

* **Case 1**: Manual **READ and WRITE** operations using the gateway
* **Case 2**: Automatic **READ and WRITE** operations using the gateway
* **Case 3**: Registering a **polling task** to periodically READ from an EVM blockchain
* **Case 4**: **Cross-chain event listening** with subsequent READ and conditional UPDATE actions

### SATP Cases (satp/)

The SATP folder contains secure asset transfer protocol cases.

* **Case 1**: Coordinated **READ and WRITE** using the gateway across blockchains, following SATP protocol.

---

## EVM Test Environment

The `EVM/` directory contains a **Hardhat** project used to deploy and simulate blockchain networks and contracts for the various gateway and SATP test cases.

* Located under `EVM/ignition/modules`, you will find simple deployment scripts and interaction modules with **hardcoded addresses** for clarity and reproducibility during testing.

---

## Important Instructions

* **Please follow the setup instructions for each case carefully.**
* **Before switching from one case to another**, **always rerun all setup commands** to ensure:

  * The environment is **fully refreshed**
  * **Contract addresses remain consistent**
  * No residual data or processes from other cases affect the results

Failure to reset the environment between cases may lead to unexpected behavior due to mismatched or stale blockchain state/configurations.

---


## Setup & Running

You can use the provided `Makefile` to automate setup and environment preparation for the demo. Run:

```bash
make help
```

to see available targets for building, deploying, and running the demo cases.

Each case also includes its own `README.md` with instructions for how to:

* Start the services via `docker-compose`
* Deploy contracts
* Run gateway/oracle scripts
* Observe outputs and verify behaviors

---

## Dependencies

* [Docker & Docker Compose](https://docs.docker.com/compose/)
* [Hardhat](https://hardhat.org/)
* Python ≥ 3.8

---

## Contact

For questions or collaboration inquiries, feel free to reach out or open an issue on this repository.
