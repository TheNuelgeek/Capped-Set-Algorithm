# WEB3 SOLIDITY DEVELOPER TASK (Capped Set)

## Objective:
- Implement a set-like structure in Solidity (using hardhat to help out) that
only allows a certain amount of "elements" in the set. Once you've created the Solidity contract,
we want you to test it in TypeScript, not in Solidity.

## Deployed to Polygon Testnet(Mumbai) 
- Link: https://mumbai.polygonscan.com/address/0xd17a8146c4b952891e6b66338faf56d8e95c5fb7
- Address: 0xD17a8146C4b952891e6b66338fAF56d8e95c5FB7

## How to Run the Project

1. Clone or fork the repository to your local machine.
2. Navigate into the project directory and run `yarn install` to install all the required dependencies.
```shell
`npx hardhat help`

`npx hardhat test`

`REPORT_GAS=true npx hardhat test`

`npx hardhat node`

`npx hardhat run scripts/deployCappedSet.ts`

`npx hardhat run test/CappedSet.ts`

```

## Dependencies
The project uses the following dependencies:

- "@nomicfoundation/hardhat-chai-matchers": "^2.0.0",
- "@nomicfoundation/hardhat-ethers": "^3.0.2",
- "@nomicfoundation/hardhat-network-helpers": "^1.0.0",
- "@nomicfoundation/hardhat-toolbox": "^3.0.0",
- "@nomicfoundation/hardhat-verify": "^1.0.0",
- "@typechain/ethers-v6": "^0.4.0",
- "@typechain/hardhat": "^8.0.0",
- "@types/chai": "^4.2.0",
- "@types/mocha": ">=9.1.0",
- "@types/node": ">=12.0.0",
- "chai": "^4.2.0",
- "ethers": "^6.4.0",
- "hardhat": "^2.15.0",
- "hardhat-gas-reporter": "^1.0.8",
- "solidity-coverage": "^0.8.0",
- "ts-node": ">=8.0.0",
- "typechain": "^8.1.0",
- "typescript": ">=4.5.0"

## Features

The contract allows users to:

- insert new element to the set and return the lowest element's value.
- update an existing element in the set and return the lowest element's value.
- delete an element from the set and return the lowest element's value.
- getValue function to retrieve the value for a given address.

## Written In
   - Solidity
   - Typescript

## License
This project is licensed under the MIT License.
