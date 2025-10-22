# Fabric Oracle Register: POLLING READ and UPDATE Operations on Hyperledger Fabric

This README describes how to run the oracle polling tests that use the SATP Hermes Gateway as middleware to register, poll and unregister tasks against Hyperledger Fabric. The tests exercise the standard `token-erc-20` chaincode through the Gateway plugin endpoints:

- POST /api/v1/@hyperledger/cactus-plugin-satp-hermes/oracle/execute
- POST /api/v1/@hyperledger/cactus-plugin-satp-hermes/oracle/register
- POST /api/v1/@hyperledger/cactus-plugin-satp-hermes/oracle/unregister
- GET  /api/v1/@hyperledger/cactus-plugin-satp-hermes/oracle/status

The provided test script `oracle-execute-fabric.py` performs three polling scenarios:
- polling_update_fabric: creates an asset, registers a POLLING UPDATE task that updates the asset every 5s, waits, then unregisters and asserts multiple successful UPDATE operations were executed.
- polling_read_fabric: registers a POLLING READ task that calls `GetAllAssets` every 5s, waits, then unregisters and asserts multiple successful READ operations were executed.
- polling_specific_read_fabric: creates a single asset, registers a POLLING READ task that calls `ReadAsset(<id>)` every 5s, waits, then unregisters and asserts the specific asset was read successfully multiple times.

## Requirements

To simulate a Hyperledger Fabric network and run this example, ensure you have cloned the [Hyperledger Fabric Samples repository](https://github.com/hyperledger/fabric-samples).

```bash
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
```

Then, install the Fabric binaries and Docker images by running:

```bash
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh
./install-fabric.sh d s b
```

This will download the necessary Fabric binaries and Docker images.

## Terminal Overview

Before starting, here is a summary of what each terminal will be used for:

- **Terminal 1:** Start Hyperledger Fabric test network and Deploy the token-erc-20 chaincode
- **Terminal 2:** Retrieve all keys and certificates from Fabric
- **Terminal 3:** Run the Gateway (Docker Compose)
- **Terminal 4:** Run the Oracle execute script

## Setup Instructions

### 1. Start Hyperledger Fabric Network

In terminal 1, navigate to your Fabric samples directory and start the network:
```bash
cd fabric-samples/test-network
./network.sh down  # Clean up any existing network if needed
./network.sh up createChannel -c mychannel -ca
```

This creates a Fabric network with two organizations (Org1 and Org2) and a channel named `mychannel`.

---

### 2. Deploy the token-erc-20 Chaincode

In terminal 1, from the same directory:
```bash
./network.sh deployCC -ccn basic -ccp ../token-erc-20/chaincode-javascript -ccl javascript
```

This deploys the `token-erc-20` chaincode to the `mychannel` channel with the contract name `basic`.

---

### 3. Copy Required Certificates and Keys to the Gateway Configuration file (config/gateway-fabric-config.json)

#### Option 1: Script-based Retrieval

In terminal 2, in this directory, run:

```bash
cd utils
chmod +x getcert.sh && ./getcert.sh > certs.txt
```
And a txt file will be created (`./utils/certs.txt`) where you can just copy the keys to the placeholders in [`config/gateway-fabric-config.json`](config/gateway-fabric-config.json).

#### Option 2: Manual Retrieval

In terminal 2, navigate to your Fabric samples directory:

Admin Certificate     -> userIdentity.credentials.certificate
```bash
cat organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/*.pem
```

Admin Private Key     -> userIdentity.credentials.privateKey
```bash
cat organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/*_sk
```

Peer0 Org1 CA Cert    -> connectionProfile.peers.peer0.org1.example.com.tlsCACerts.pem
```bash
cat organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
```

CA Org1 Certificate   -> connectionProfile.certificateAuthorities.ca.org1.example.com.tlsCACerts.pem[0]
```bash
cat organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem
```

Orderer CA Certificate -> connectionProfile.orderers.orderer.example.com.tlsCACerts.pem
```bash
cat organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```

---

### 4. Start the Gateway (Docker)

In terminal 3:
```bash
docker compose up
```
This will start the Gateway with the Fabric configuration file.

```bash
docker ps
```
And check if kubaya/cacti-satp-hermes-gateway is healthy, if it procceed

---

### 5. Run the Oracle Polling Test Script

1. Check allowance first and there will be no allowance set yet.