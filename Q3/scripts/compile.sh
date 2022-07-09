#!/bin/bash

export CIRCUIT=$1

cd contracts/circuits

mkdir $CIRCUIT

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling $CIRCUIT.circom..."

# compile circuit

circom RangeProof.circom --r1cs --wasm --sym -o $CIRCUIT
snarkjs r1cs info $CIRCUIT/$CIRCUIT.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup $CIRCUIT/$CIRCUIT.r1cs powersOfTau28_hez_final_10.ptau $CIRCUIT/circuit_0000.zkey
snarkjs zkey contribute $CIRCUIT/circuit_0000.zkey $CIRCUIT/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey $CIRCUIT/circuit_final.zkey $CIRCUIT/verification_key.json

# generate solidity contract
export VERIFIER=$CIRCUIT+"Verifier"
snarkjs zkey export solidityverifier $CIRCUIT/circuit_final.zkey ../$VERIFIER.sol

cd ../..
