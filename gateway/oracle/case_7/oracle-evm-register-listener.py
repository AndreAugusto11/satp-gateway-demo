
import requests
import json
from time import sleep

# Configuration
FABRIC_NETWORK_ID = {"id": "FabricLedgerTestNetwork", "ledgerType": "FABRIC_2"}
CONTRACT_NAME = "basic"


def register_oracle(params):
    """
    Calls the /api/v1/@hyperledger/cactus-plugin-satp-hermes/oracle/register endpoint
    with the given params as JSON body.

    Args:
        params (dict): The JSON payload to send.

    Returns:
        dict: The JSON response from the endpoint.
    """
    url = "http://localhost:4010/api/v1/@hyperledger/cactus-plugin-satp-hermes/oracle/register"
    headers = {"Content-Type": "application/json"}
    response = requests.post(url, json=params, headers=headers)
    response.raise_for_status()
    return response.json()


def register_listener():
    req_params = {
        'sourceNetworkId': FABRIC_NETWORK_ID,
        'sourceContract': {
            'contractName': CONTRACT_NAME,
        },
        'destinationNetworkId': FABRIC_NETWORK_ID,
        'destinationContract': {
            'contractName': CONTRACT_NAME,
            'methodName': 'WriteDataNoEvent',
            # not needed because we will write the data read from the source contract
            # we can still pass it but it will overwrite the data read from the source contract
        },
        'listeningOptions': {
            "eventSignature": "WriteData",
            "filterParams": ["data"],
        },
        'taskType': 'READ_AND_UPDATE',
        'taskMode': 'EVENT_LISTENING',
    }

    return register_oracle(req_params)


if __name__ == "__main__":
    print(f"First request will register the task in the oracle...the task will be executed whenever there is a new event emitted from the source contract")
    sleep(5)

    read_response = register_listener()
    print("Response:", read_response)

    print(f"Task ID: {read_response['taskID']}")
