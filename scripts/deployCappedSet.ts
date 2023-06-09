import { ethers } from "hardhat";
import "@nomicfoundation/hardhat-ethers";

async function main() {
    const signer = await ethers.provider.getSigner();
    const CappedSet = await ethers.getContractFactory("CappedSet")
    const cappedSet = await CappedSet.deploy(5)
    await cappedSet.waitForDeployment();
    
    const address = (await cappedSet).getAddress

    console.log(address )

    const hre = require("hardhat")

    hre.run(`verify:verify`, {
        address: address,
        constructorArguments: 5,
    });
    
    

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});