# Getting Started with SATP (Secure Asset Transfer Protocol)

## Table of Contents
- [Getting Started with SATP (Secure Asset Transfer Protocol)](#getting-started-with-satp-secure-asset-transfer-protocol)
  - [Table of Contents](#table-of-contents)
  - [Setting Up Your Gateway](#setting-up-your-gateway)
    - [Gateway Configuration](#gateway-configuration)
    - [Gateway Configuration](#gateway-configuration-1)
    - [Repositories Configuration](#repositories-configuration)
    - [Network Configuration](#network-configuration)
      - [For Fabric Networks:](#for-fabric-networks)
      - [For EVM Networks:](#for-evm-networks)
  - [Running Your Gateway](#running-your-gateway)
    - [Using Docker](#using-docker)
      - [Option 1: Using Pre-built Image](#option-1-using-pre-built-image)
      - [Option 2: Building the Image Locally](#option-2-building-the-image-locally)
    - [Using Docker Compose](#using-docker-compose)
  - [Interacting with Your Gateway](#interacting-with-your-gateway)
    - [API Usage](#api-usage)
      - [Check Gateway Health](#check-gateway-health)

## Setting Up Your Gateway

### Gateway Configuration

Create a configuration file `config.json` for your SATP gateway with the following schema:

```json
{
  // configuration for the gateway to be created
  "gid": {
    <GATEWAY_CONFIG>
  },
  "logLevel": "TRACE",
  "counterPartyGateways": [
    // configuration for other existing gateways, such that they can communicate with one another
    <COUNTERPARTY_GATEWAY_1_CONFIG>,
    <COUNTERPARTY_GATEWAY_2_CONFIG>,
    ...
  ],
  "localRepository": {
    // configuration for the local database used to store logs from the execution of SATP
    <DB_CONNECTION_1>,
    }
  },
  "remoteRepository": {
    // configuration for the remote database used to store logs from the execution of SATP
    <DB_CONNECTION_2>,
  },
  "ccConfig": {
    "bridgeConfig": [
      // configuration for the usage of SATP related endpoints
      <NETWORK_CONFIG_1>,
      <NETWORK_CONFIG_2>,
      ...
    ],
    "oracleConfig": [
      // configuration for the usage of Oracle related endpoints
      <NETWORK_CONFIG_1>,
      <NETWORK_CONFIG_2>,
      ...
    ]
  },
  "environment": "development",
  "enableCrashRecovery": false,
  "ontologyPath": "/opt/cacti/satp-hermes/ontologies"
}
```

### Gateway Configuration

You'll need to configure the gateway to be created and fill in <GATEWAY_CONFIG> and <COUNTERPARTY_GATEWAY_X_CONFIG>.

```json
{
  "id": "mockID",
  "name": "CustomGateway",
  "version": [
    {
      "Core": "v02",
      "Architecture": "v02",
      "Crash": "v02"
    }
  ],
  "connectedDLTs": [
    {
      "id": "BesuLedgerTestNetwork",
      "ledgerType": "BESU_2X"
    }
  ],
  "proofID": "mockProofID10",
  "address": "http://gateway1.satp-hermes",
  "gatewayClientPort": 3011,
  "gatewayServerPort": 3010,
  "gatewayOapiPort": 4010,
  "pubKey": "<GATEWAY_PUB_KEY>"
}
```

### Repositories Configuration

You'll need to configure the local and remote repositories to be created and fill in <DB_CONNECTION_X>.

```json
{
  "client": "<DB_CLIENT>",
  "connection": {
    "host": "<DB_HOST>",
    "user": "<DB_USER>",
    "password": "<DB_PASSWORD>",
    "database": "<DB_DATABASE>",
    "port": <DB_PORT>,
    "ssl": <USE_SSL>
  }
}
```

### Network Configuration

You'll need to configure each blockchain you want to connect to and fill in <NETWORK_CONFIG_X>.

#### For Fabric Networks:
```json
{
  "networkIdentification": {
    "id": "FabricLedgerTestNetwork",
    "ledgerType": "FABRIC_2"
  },
  "userIdentity": {
    "credentials": {
      "certificate": "-----BEGIN CERTIFICATE-----\nMIICfTCCAiSgAwIBAgIUD5ndW2aZ7pb7n9e/KY2i91kUe+EwCgYIKoZIzj0EAwIw\nbDELMAkGA1UEBhMCVUsxEjAQBgNVBAgTCUhhbXBzaGlyZTEQMA4GA1UEBxMHSHVy\nc2xleTEZMBcGA1UEChMQb3JnMi5leGFtcGxlLmNvbTEcMBoGA1UEAxMTY2Eub3Jn\nMi5leGFtcGxlLmNvbTAeFw0yNTA1MjIwOTE1MDBaFw0yNjA1MjIwOTIzMDBaMEMx\nMDALBgNVBAsTBG9yZzIwDQYDVQQLEwZjbGllbnQwEgYDVQQLEwtkZXBhcnRtZW50\nMTEPMA0GA1UEAxMGYnJpZGdlMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEasl7\n5Veo6x3OK619bhdJMg1vVkG+8Khkx0WQlbJxqn7d5QBc2PINFI62adHihULdeaQ5\nwv95I3mLg9n3LB6iGKOBzDCByTAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIw\nADAdBgNVHQ4EFgQUO88pUgK8ZCiURr98XitOzvnqZfswHwYDVR0jBBgwFoAUcwqK\n3zFGaZXrCaQZXUJZlh5jt4UwaQYIKgMEBQYHCAEEXXsiYXR0cnMiOnsiaGYuQWZm\naWxpYXRpb24iOiJvcmcyLmRlcGFydG1lbnQxIiwiaGYuRW5yb2xsbWVudElEIjoi\nYnJpZGdlIiwiaGYuVHlwZSI6ImNsaWVudCJ9fTAKBggqhkjOPQQDAgNHADBEAiBd\nZW7gThW2HByCepzG9yRBLsV/wSocPz5KiWRzHyYQfwIgdsw0yLPeIhgx6OSXOhbK\nxm1YNWFlMicC5HZGMFV2x0s=\n-----END CERTIFICATE-----\n",
      "privateKey": "-----BEGIN PRIVATE KEY-----\r\nMIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgK5TCz5K/qYcTKQX5\r\nhHF3kJtQK93DKnimcmGwzkQ1JSChRANCAARqyXvlV6jrHc4rrX1uF0kyDW9WQb7w\r\nqGTHRZCVsnGqft3lAFzY8g0UjrZp0eKFQt15pDnC/3kjeYuD2fcsHqIY\r\n-----END PRIVATE KEY-----\r\n"
    },
    "mspId": "Org2MSP",
    "type": "X.509"
  },
  "channelName": "mychannel",
  "targetOrganizations": [
    {
      "CORE_PEER_TLS_ENABLED": "true",
      "CORE_PEER_LOCALMSPID": "Org1MSP",
      "CORE_PEER_TLS_CERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt",
      "CORE_PEER_TLS_KEY_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key",
      "CORE_PEER_ADDRESS": "peer0.org1.example.com:7051",
      "CORE_PEER_MSPCONFIGPATH": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp",
      "CORE_PEER_TLS_ROOTCERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt",
      "ORDERER_TLS_ROOTCERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem"
    },
    {
      "CORE_PEER_TLS_ENABLED": "true",
      "CORE_PEER_LOCALMSPID": "Org2MSP",
      "CORE_PEER_TLS_CERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt",
      "CORE_PEER_TLS_KEY_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key",
      "CORE_PEER_ADDRESS": "peer0.org2.example.com:9051",
      "CORE_PEER_MSPCONFIGPATH": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp",
      "CORE_PEER_TLS_ROOTCERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt",
      "ORDERER_TLS_ROOTCERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem"
    }
  ],
  "caFile": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem",
  "ccSequence": 1,
  "orderer": "orderer.example.com:7050",
  "ordererTLSHostnameOverride": "orderer.example.com",
  "connTimeout": 60,
  "mspId": "Org2MSP",
  "connectorOptions": {
    "dockerBinary": "/usr/local/bin/docker",
    "peerBinary": "/fabric-samples/bin/peer",
    "goBinary": "/usr/local/go/bin/go",
    "cliContainerEnv": {
      "CORE_PEER_TLS_ENABLED": "true",
      "CORE_PEER_LOCALMSPID": "Org1MSP",
      "CORE_PEER_TLS_CERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt",
      "CORE_PEER_TLS_KEY_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key",
      "CORE_PEER_ADDRESS": "peer0.org1.example.com:7051",
      "CORE_PEER_MSPCONFIGPATH": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp",
      "CORE_PEER_TLS_ROOTCERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt",
      "ORDERER_TLS_ROOTCERT_FILE": "/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem"
    },
    "sshConfig": {
      "host": "172.23.0.6",
      "privateKey": "-----BEGIN OPENSSH PRIVATE KEY-----\n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\n-----END OPENSSH PRIVATE KEY-----\n",
      "username": "root",
      "port": 22
    },
    "connectionProfile": {
      "name": "test-network-org2",
      "version": "1.0.0",
      "client": {
        "organization": "Org2",
        "connection": {
          "timeout": {
            "peer": {
              "endorser": "300"
            }
          }
        }
      },
      "organizations": {
        "Org2": {
          "mspid": "Org2MSP",
          "peers": [
            "peer0.org2.example.com"
          ],
          "certificateAuthorities": [
            "ca.org2.example.com"
          ]
        }
      },
      "peers": {
        "peer0.org2.example.com": {
          "url": "grpcs://peer0.org2.example.com:9051",
          "tlsCACerts": {
            "pem": "-----BEGIN CERTIFICATE-----\nMIICHjCCAcWgAwIBAgIUcJUmsP4aK2ICQnK8wCCBcCQUn64wCgYIKoZIzj0EAwIw\nbDELMAkGA1UEBhMCVUsxEjAQBgNVBAgTCUhhbXBzaGlyZTEQMA4GA1UEBxMHSHVy\nc2xleTEZMBcGA1UEChMQb3JnMi5leGFtcGxlLmNvbTEcMBoGA1UEAxMTY2Eub3Jn\nMi5leGFtcGxlLmNvbTAeFw0yNTA1MjIwOTE1MDBaFw00MDA1MTgwOTE1MDBaMGwx\nCzAJBgNVBAYTAlVLMRIwEAYDVQQIEwlIYW1wc2hpcmUxEDAOBgNVBAcTB0h1cnNs\nZXkxGTAXBgNVBAoTEG9yZzIuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2NhLm9yZzIu\nZXhhbXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATeg9K267QJhuzn\njIYURbyCGqccQTGOoy0VMTaojZ18q14vsvkMU9tlURUsPBRuV9z8cIGt6cqiDPxm\nRuOuzDSSo0UwQzAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBATAd\nBgNVHQ4EFgQUcwqK3zFGaZXrCaQZXUJZlh5jt4UwCgYIKoZIzj0EAwIDRwAwRAIg\nU2k9CNuZjyIfEgWSsWJT/mHHQlUvW40P4gt9qB3G+AYCIFJb60D1SK1g769nm8vE\nglsNBX4/u7H7pC8AMSI+PIyu\n-----END CERTIFICATE-----\n"
          },
          "grpcOptions": {
            "ssl-target-name-override": "peer0.org2.example.com",
            "hostnameOverride": "peer0.org2.example.com"
          }
        }
      },
      "certificateAuthorities": {
        "ca.org2.example.com": {
          "url": "https://ca.org2.example.com:8054",
          "caName": "ca-org2",
          "tlsCACerts": {
            "pem": [
              "-----BEGIN CERTIFICATE-----\nMIICHjCCAcWgAwIBAgIUcJUmsP4aK2ICQnK8wCCBcCQUn64wCgYIKoZIzj0EAwIw\nbDELMAkGA1UEBhMCVUsxEjAQBgNVBAgTCUhhbXBzaGlyZTEQMA4GA1UEBxMHSHVy\nc2xleTEZMBcGA1UEChMQb3JnMi5leGFtcGxlLmNvbTEcMBoGA1UEAxMTY2Eub3Jn\nMi5leGFtcGxlLmNvbTAeFw0yNTA1MjIwOTE1MDBaFw00MDA1MTgwOTE1MDBaMGwx\nCzAJBgNVBAYTAlVLMRIwEAYDVQQIEwlIYW1wc2hpcmUxEDAOBgNVBAcTB0h1cnNs\nZXkxGTAXBgNVBAoTEG9yZzIuZXhhbXBsZS5jb20xHDAaBgNVBAMTE2NhLm9yZzIu\nZXhhbXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATeg9K267QJhuzn\njIYURbyCGqccQTGOoy0VMTaojZ18q14vsvkMU9tlURUsPBRuV9z8cIGt6cqiDPxm\nRuOuzDSSo0UwQzAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBATAd\nBgNVHQ4EFgQUcwqK3zFGaZXrCaQZXUJZlh5jt4UwCgYIKoZIzj0EAwIDRwAwRAIg\nU2k9CNuZjyIfEgWSsWJT/mHHQlUvW40P4gt9qB3G+AYCIFJb60D1SK1g769nm8vE\nglsNBX4/u7H7pC8AMSI+PIyu\n-----END CERTIFICATE-----\n"
            ]
          },
          "httpOptions": {
            "verify": false
          }
        }
      },
      "orderers": {
        "orderer.example.com": {
          "url": "grpcs://orderer.example.com:7050",
          "grpcOptions": {
            "ssl-target-name-override": "orderer.example.com"
          },
          "tlsCACerts": {
            "pem": "-----BEGIN CERTIFICATE-----\nMIICCjCCAbGgAwIBAgIUcCzH43V7IOGSx1Fwb00YR+xR40owCgYIKoZIzj0EAwIw\nYjELMAkGA1UEBhMCVVMxETAPBgNVBAgTCE5ldyBZb3JrMREwDwYDVQQHEwhOZXcg\nWW9yazEUMBIGA1UEChMLZXhhbXBsZS5jb20xFzAVBgNVBAMTDmNhLmV4YW1wbGUu\nY29tMB4XDTI1MDUyMjA5MTUwMFoXDTQwMDUxODA5MTUwMFowYjELMAkGA1UEBhMC\nVVMxETAPBgNVBAgTCE5ldyBZb3JrMREwDwYDVQQHEwhOZXcgWW9yazEUMBIGA1UE\nChMLZXhhbXBsZS5jb20xFzAVBgNVBAMTDmNhLmV4YW1wbGUuY29tMFkwEwYHKoZI\nzj0CAQYIKoZIzj0DAQcDQgAEM7kb8by33lNU8o1uj2Tp0RctufwhdK6SuboAV8vU\nbsLdzvuFHqvETBrUizA4RHs/othJct0hjxtb3HGsrxaPCqNFMEMwDgYDVR0PAQH/\nBAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFAgyZWwSWMbDHRfV\nwf1hmrxIbMZ8MAoGCCqGSM49BAMCA0cAMEQCIGGd9+x9flF4UW30qdI4FpA5S+uC\nKLlHm0dasHgk9Iq6AiBZSAglTIQrLPl5xsAA3HlDzi5Yvtj+uBYFw8zAjYfd6g==\n-----END CERTIFICATE-----\n"
          }
        }
      },
      "channels": {
        "mychannel": {
          "orderers": [
            "orderer.example.com"
          ],
          "peers": {
            "peer0.org2.example.com": {
              "endorsingPeer": true,
              "chaincodeQuery": true,
              "ledgerQuery": true,
              "eventSource": true,
              "discover": true
            }
          }
        }
      }
    },
    "discoveryOptions": {
      "enabled": true,
      "asLocalhost": false
    },
    "eventHandlerOptions": {
      "strategy": "NETWORK_SCOPE_ALLFORTX",
      "commitTimeout": 300
    }
  },
  "claimFormats": [
    2
  ]
}
```

#### For EVM Networks:
```json
{
  "networkIdentification": {
    "id": "EthereumLedgerTestNetwork",
    "ledgerType": "ETHEREUM"
  },
  "signingCredential": {
    "ethAccount": "<YOUR_ETHEREUM_ADDRESS>",
    "secret": "<YOUR PRIVATE KEY>",
    "type": "GETH_KEYCHAIN_PASSWORD"
  },
  "gasConfig": {
    "gas": "<GAS>",
    "gasPrice": "<GAS_PRICE>"
  },
  "connectorOptions": {
    "rpcApiHttpHost": "http://<HTTP_HOST>:<HTTP_PORT>",
    "rpcApiWsHost": "ws://<WS_HOST>:<WS_PORT>"
  },
  "claimFormats": [
    1
  ]
}
```

## Running Your Gateway

### Using Docker

The simplest way to run your gateway is using our pre-built Docker image.

#### Option 1: Using Pre-built Image

1. Create a new directory:
```bash

```

2. Pull and run the image:
```bash
docker pull rafaelapb/satp-hermes-gateway:latest

docker run -it \
  -p 3010:3010 \
  -p 3011:3011 \
  -p 4010:4010 \
  -v $(pwd)/config:/opt/cacti/satp-hermes/config \
  -v $(pwd)/database:/opt/cacti/satp-hermes/database \
  rafaelapb/satp-hermes-gateway:latest
```

By default, the gateway exposes these ports:
- 4010: API Port (for your applications to interact with)
- 3010: Internal communication port
- 3011: Management port

#### Option 2: Building the Image Locally

If you need to customize the gateway:

1. Build the image:
```bash
# For generating a production build
yarn build:bundle

# For creating a docker image
yarn docker:build:dev
```

2. Run your custom build:
```bash
docker run -it \
  -p 3010:3010 \
  -p 3011:3011 \
  -p 4010:4010 \
  -v $(pwd)/config:/opt/cacti/satp-hermes/config \
  -v $(pwd)/database:/opt/cacti/satp-hermes/database \
  satp-hermes-gateway
```

### Using Docker Compose

For more complex setups, use Docker Compose:

1. Create a `docker-compose.yml`:
```yaml
version: '3.8'
services:
  satp-gateway:
    image: rafaelapb/satp-hermes-gateway:latest
    ports:
      - "4010:4010"
      - "3010:3010"
      - "3011:3011"
    volumes:
      - ./config:/opt/cacti/satp-hermes/config
      - ./database:/opt/cacti/satp-hermes/database
    environment:
      - NODE_ENV=development
```

2. Start the services:
```bash
# Interactive mode
docker-compose up

# Detached mode
docker-compose up -d
```

3. Stop the services:
```bash
docker-compose down
```

## Interacting with Your Gateway

### API Usage

The SATP Gateway provides a comprehensive REST API (API1) for managing asset transfers. All endpoints are available at `http://localhost:4010/api/v1/@hyperledger/cactus-plugin-satp-hermes/`. The specification of the endpoints can be found in the [OpenAPI Specification](https://github.com/hyperledger-cacti/cacti/blob/1c1d9021d631d08740683e17513d532b60b5ef66/packages/cactus-plugin-satp-hermes/src/main/json/openapi-blo-bundled.json).

#### Check Gateway Health

```bash
curl -X GET http://localhost:4010/api/v1/@hyperledger/cactus-plugin-satp-hermes/healthcheck
```
