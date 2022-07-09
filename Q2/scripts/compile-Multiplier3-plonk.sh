#!/bin/bash

# [assignment] create your own bash script to compile Multiplier3.circom using PLONK below

cd contracts/circuits

export CONTRACT_NAME="Multiplier3_plonk"

mkdir $CONTRACT_NAME

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."

# compile circuit

cp Multiplier3.circom $CONTRACT_NAME.circom

circom $CONTRACT_NAME.circom --r1cs --wasm --sym -o $CONTRACT_NAME
snarkjs r1cs info $CONTRACT_NAME/$CONTRACT_NAME.r1cs

rm $CONTRACT_NAME.circom

# Start a new zkey and make a contribution

snarkjs plonk setup $CONTRACT_NAME/$CONTRACT_NAME.r1cs powersOfTau28_hez_final_10.ptau $CONTRACT_NAME/circuit_final.zkey
snarkjs zkey export verificationkey $CONTRACT_NAME/circuit_final.zkey $CONTRACT_NAME/verification_key.json

# generate solidity contract
export VERIFIER=$CONTRACT_NAME"Verifier"
snarkjs zkey export solidityverifier $CONTRACT_NAME/circuit_final.zkey ../$VERIFIER.sol

cd ../..
