#!/bin/bash
set -uxe

# set environment variables
export GOPATH=~/go
export PATH=$PATH:~/go/bin


INTERVAL=1000

# GET TRUST HASH AND TRUST HEIGHT

LATEST_HEIGHT=$(curl -s http://142.132.196.223:2071/block | jq -r .result.block.header.height);
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL)) 
TRUST_HASH=$(curl -s "http://142.132.196.223:2071/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)


# TELL USER WHAT WE ARE DOING
echo "TRUST HEIGHT: $BLOCK_HEIGHT"
echo "TRUST HASH: $TRUST_HASH"


# export state sync vars
export JUNOD_STATESYNC_ENABLE=true
export JUNOD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export JUNOD_STATESYNC_RPC_SERVERS="http://142.132.196.223:2071,http://142.132.196.223:2071"
export JUNOD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export JUNOD_STATESYNC_TRUST_HASH=$TRUST_HASH
export JUNOD_P2P_SEEDS="2484353dab0b2c1275765b8ffa2c50b3b36158ca@seed-node.junochain.com:26656,ef2315d81caa27e4b0fd0f267d301569ee958893@juno-seed.blockpane.com:26656"

junod start --x-crisis-skip-assert-invariants
