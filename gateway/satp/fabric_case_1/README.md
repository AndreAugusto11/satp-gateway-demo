Para meter o fabric network a correr é necessário fazer clone do repo fabric samples 
Depois dentro do fabric samples fazer isto
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

./install-fabric.sh -h

./install-fabric.sh d s b


Depois de se ter instalado dependencies é correr
./network.sh up createChannel -c mychannel -ca

ainda nao testei mas talvez dê este:
./network.sh up