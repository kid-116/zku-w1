const fs = require("fs");

function bump(contractName) {
    console.log(`Bumping ${contractName}Verifier.sol...`)

    const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/;
    const verifierRegex = /contract Verifier/;
    
    let content = fs.readFileSync(`./contracts/${contractName}Verifier.sol`, { encoding: 'utf-8' });
    let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
    bumped = bumped.replace(verifierRegex, `contract ${contractName}Verifier`);
    
    fs.writeFileSync(`./contracts/${contractName}Verifier.sol`, bumped);
}

bump("HelloWorld");

// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment

bump("Multiplier3");
bump("Multiplier3_plonk");