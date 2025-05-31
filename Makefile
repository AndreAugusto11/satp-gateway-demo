.PHONY: clean clean-port-container run-case-1 run-case-2 run-case-3 run-case-4 run-all-cases help setup check-docker check-docker-compose check-hardhat check-python check-nvm check-node install-nvm install-node install-hardhat install-python install-docker install-docker-compose

# Sleep constants
SHORTWAIT = 1
MEDIUMWAIT = 3
LONGWAIT = 6

clean:
	# 1. Stop and remove all experiment containers and volumes
	@echo "Stopping and removing all experiment containers and volumes..."
	@docker compose -f gateway/oracle/case_1/docker-compose.yaml down -v || true
	@docker compose -f gateway/oracle/case_2/docker-compose.yaml down -v || true
	@docker compose -f gateway/oracle/case_3/docker-compose.yaml down -v || true
	@docker compose -f gateway/oracle/case_4/docker-compose.yaml down -v || true
	@docker compose -f gateway/satp/case_1/docker-compose.yaml down -v || true

	# 2. Remove containers by image name and port
	@docker ps -a --format '{{.ID}} {{.Ports}}' | awk '/3010|3011|4010/ {print $1}' | xargs -r docker rm -f || true
	@docker ps -a --filter ancestor=5c4a6ec3b166 --format '{{.ID}}' | xargs -r docker rm -f || true
	@docker ps -a --filter ancestor=aaugusto11/cacti-satp-hermes-gateway:215ad342b-2025-05-29 --format '{{.ID}}' | xargs -r docker rm -f || true
	@docker ps -a --filter name=case_1-satp-hermes-gateway- --format '{{.ID}}' | xargs -r docker rm -f || true

	# 3. Kill any process using ports 8545 or 8546 (Hardhat nodes)
	@lsof -ti:8545 | xargs -r kill -9 || true
	@lsof -ti:8546 | xargs -r kill -9 || true

	@echo "Clean complete."



run-case-1:
	@echo "Running Oracle Case 1: Gateway as Middleware for READ and WRITE in EVM-based blockchains..."
	$(MAKE) clean-port-container PORT=3010
	(cd gateway/oracle/case_1 && docker compose up -d)
	sleep $(SHORTWAIT)
	# Start Hardhat EVM Blockchain (port 8545)
	(cd EVM && npx hardhat node --hostname 0.0.0.0 --port 8545 &)
	sleep $(MEDIUMWAIT)
	# Deploy the OracleTestContract smart contract
	(cd EVM && npx hardhat ignition deploy ./ignition/modules/OracleTestContract.js --network hardhat1)
	sleep $(SHORTWAIT)
	# Run the Oracle interaction script (read/write via Gateway)
	(cd gateway/oracle/case_1 && python3 oracle-execute-manual-read-and-write.py)

run-case-2:
	@echo "Running Oracle Case 2: Gateway as Middleware for READ and WRITE on two EVM-based blockchains..."
	$(MAKE) clean-port-container PORT=3010
	(cd gateway/oracle/case_2 && docker compose up -d)
	sleep $(SHORTWAIT)
	# Start Hardhat EVM Blockchain 1 (port 8545)
	(cd EVM && npx hardhat node --hostname 0.0.0.0 --port 8545 &)
	sleep $(SHORTWAIT)
	# Start Hardhat EVM Blockchain 2 (port 8546)
	(cd EVM && npx hardhat node --hostname 0.0.0.0 --port 8546 &)
	sleep $(MEDIUMWAIT)
	# Deploy the OracleTestContract smart contract to both blockchains
	(cd EVM && npx hardhat ignition deploy ./ignition/modules/OracleTestContract.js --network hardhat1)
	(cd EVM && npx hardhat ignition deploy ./ignition/modules/OracleTestContract.js --network hardhat2)
	sleep $(SHORTWAIT)
	# Run the Oracle interaction script (read/write via Gateway)
	(cd gateway/oracle/case_2 && python3 oracle-execute-auto-read-and-write.py)

run-case-3:
	@echo "Running Oracle Case 3: Registering a Polling Task to Periodically READ from EVM-based Blockchain..."
	$(MAKE) clean-port-container PORT=3010
	(cd gateway/oracle/case_3 && docker compose up -d)
	sleep $(SHORTWAIT)
	# Start Hardhat EVM Blockchain (port 8545)
	(cd EVM && npx hardhat node --hostname 0.0.0.0 --port 8545 &)
	sleep $(MEDIUMWAIT)
	# Deploy the OracleTestContract smart contract
	(cd EVM && npx hardhat ignition deploy ./ignition/modules/OracleTestContract.js --network hardhat1)
	sleep $(SHORTWAIT)
	# Register the polling task via Gateway
	(cd gateway/oracle/case_3 && python3 oracle-evm-register-poller.py)
	sleep $(SHORTWAIT)
	@echo "Now you can:"
	@echo "- Observe failing reads in Hardhat logs (Terminal 2)"
	@echo "- Trigger a write to the contract: python3 gateway/oracle/case_3/oracle-evm-execute-update.py"
	@echo "- Check polling task status: python3 gateway/oracle/case_3/oracle-evm-check-status.py <TASK_ID>"
	@echo "- Unregister the polling task: python3 gateway/oracle/case_3/oracle-evm-unregister.py <TASK_ID>"

run-case-4:
	@echo "Running Oracle Case 4: Cross-Chain EVENT_LISTENING with READ_AND_UPDATE Tasks..."
	$(MAKE) clean-port-container PORT=3010
	(cd gateway/oracle/case_4 && docker compose up -d)
	sleep $(SHORTWAIT)
	# Start Hardhat EVM Blockchain 1 (port 8545)
	(cd EVM && npx hardhat node --hostname 0.0.0.0 --port 8545 &)
	sleep $(SHORTWAIT)
	# Start Hardhat EVM Blockchain 2 (port 8546)
	(cd EVM && npx hardhat node --hostname 0.0.0.0 --port 8546 &)
	sleep $(MEDIUMWAIT)
	# Deploy the OracleTestContract smart contract to both blockchains
	(cd EVM && npx hardhat ignition deploy ./ignition/modules/OracleTestContract.js --network hardhat1)
	(cd EVM && npx hardhat ignition deploy ./ignition/modules/OracleTestContract.js --network hardhat2)
	sleep $(SHORTWAIT)
	# Register the event listening task via Gateway
	(cd gateway/oracle/case_4 && python3 oracle-evm-register-listener.py)
	sleep $(SHORTWAIT)
	@echo "Now you can:"
	@echo "- Trigger the event in source chain: python3 gateway/oracle/case_4/oracle-evm-execute-update.py"
	@echo "- Check task status: python3 gateway/oracle/case_4/oracle-evm-check-status.py <TASK_ID>"
	@echo "- Unregister the event listening task: python3 gateway/oracle/case_4/oracle-evm-unregister.py <TASK_ID>"


# Run all cases sequentially with wait times (customize as needed)

# Run all cases sequentially, cleaning and waiting between each
.PHONY: run-all-cases
run-all-cases:
	@echo "Running all cases sequentially with cleanup and wait times..."
	$(MAKE) run-case-1
	$(MAKE) clean
	sleep 3
	$(MAKE) run-case-2
	$(MAKE) clean
	sleep 3
	$(MAKE) run-case-3
	$(MAKE) clean
	sleep 3
	$(MAKE) run-case-4
	$(MAKE) clean
	@echo "All cases executed successfully. Cleaned up."

# Show help for all Makefile targets
.PHONY: help
help:
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:($$| )' Makefile | grep -v '^_' | awk -F: '{printf "  %-20s %s\n", $$1, "- "}'
	@echo "\nRun 'make <target>' to execute a specific task."
# Makefile for SATP Gateway Demo

.PHONY: setup check-docker check-docker-compose check-hardhat check-python check-nvm check-node install-nvm install-node install-hardhat install-python install-docker install-docker-compose

setup: check-docker check-docker-compose check-nvm install-node check-hardhat check-python
	@echo "All dependencies are installed."

check-docker:
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "Docker not found. Please install Docker."; \
		exit 1; \
	else \
		echo "Docker is installed."; \
	fi

check-docker-compose:
	@if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then \
		echo "Docker Compose not found. Please install Docker Compose."; \
		exit 1; \
	else \
		echo "Docker Compose is installed."; \
	fi

check-nvm:
	@if [ -z "$(shell command -v nvm)" ] && [ ! -d "$$HOME/.nvm" ]; then \
		$(MAKE) install-nvm; \
	else \
		echo "nvm is installed."; \
	fi

install-nvm:
	@echo "Installing nvm..." && \
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

install-node:
	@. $$HOME/.nvm/nvm.sh && nvm install 18.19.0 && nvm use 18.19.0 && nvm alias default 18.19.0

check-node:
	@. $$HOME/.nvm/nvm.sh && nvm use 18.19.0 && node -v | grep 'v18.19.0' || $(MAKE) install-node
check-python:
	@if ! command -v python3 >/dev/null 2>&1; then \
		echo "Python3 not found. Please install Python >= 3.8."; \
		exit 1; \
	fi; \
	PYVER=$$(python3 -c 'import sys; print("%d.%d" % sys.version_info[:2])'); \
	REQVER=3.8; \
	if [ "$$(echo $$PYVER | awk -v req=$$REQVER 'BEGIN{split(req, r, "."); split($$0, v, "."); exit (v[1]<r[1] || (v[1]==r[1] && v[2]<r[2]))}')" = "1" ]; then \
		echo "Python >= 3.8 required. Found $$PYVER."; \
		exit 1; \
	else \
		echo "Python >= 3.8 is installed."; \
	fi

clean-port-container:
	@echo "Checking for containers using port $(PORT)..."
	@container_id=$$(docker ps -q --filter "publish=$(PORT)"); \
	if [ -n "$$container_id" ]; then \
		echo "Stopping container using port $(PORT): $$container_id"; \
		docker stop $$container_id; \
		docker rm $$container_id; \
	else \
		echo "No container found using port $(PORT)."; \
	fi
