
import requests
import json
from time import sleep

def execute_transact(params):
    """
    Calls the /api/v1/@hyperledger/cactus-plugin-satp-hermes/transact endpoint
    with the given params as JSON body.

    Args:
        params (dict): The JSON payload to send.

    Returns:
        dict: The JSON response from the endpoint.
    """
    url = f"http://localhost:4010/api/v1/@hyperledger/cactus-plugin-satp-hermes/transact"
    headers = {"Content-Type": "application/json"}
    response = requests.get(url, json=params, headers=headers)
    response.raise_for_status()
    return response.json()


def get_approve_address_source_chain():
    """
    Calls the /api/v1/@hyperledger/cactus-plugin-satp-hermes/approve-address endpoint
    with the given file as JSON body.

    Returns:
        dict: The JSON response from the endpoint.
    """
    req_params = {
        "contextID": 'mockContext',
        "originatorPubkey": '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
        "beneficiaryPubkey": '0x6a2ec8c50ba1a9ce47c52d1cb5b7136ee9d0ccc0',
        "sourceAsset": {
            "id": "ExampleAsset",
            "referenceId": "SATP-TOKEN-1",
            "owner": "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
            "contractName": "SATPTokenContract",
            "contractAddress": "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512",
            "networkId": {
                "id": "HardhatTestNetwork1",
                "ledgerType": "ETHEREUM",
            },
            "tokenType": "NONSTANDARD_FUNGIBLE",
            "amount": "100"
        },
        
        "receiverAsset": {
            "id": "ExampleAsset",
            "referenceId": "SATP-ERC20-1",
            "owner": "0x6a2ec8c50ba1a9ce47c52d1cb5b7136ee9d0ccc0",
            "contractName": "SATPTokenContract",
            "contractAddress": "0xbded0d2bf404bdcba897a74e6657f1f12e5c6fb6",
            "networkId": {
                "id": "HardhatTestNetwork2",
                "ledgerType": "ETHEREUM",
            },
            "tokenType": "NONSTANDARD_FUNGIBLE",
            "amount": "100"
        }
    }

    return execute_transact(req_params)
    

if __name__ == "__main__":
    update_response = get_approve_address_source_chain()
    print("Response:", update_response)

    update_response = get_approve_address_target_chain()
    print("Response:", update_response)
