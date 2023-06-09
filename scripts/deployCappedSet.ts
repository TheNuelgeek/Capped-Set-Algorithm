import { ethers } from "hardhat";

async function main() {
    const CappedSet = await ethers.getContractFactory('CappedSet')
    const cappedSet = await CappedSet.deploy(5)
    await cappedSet.waitForDeployment();


    console.log(await cappedSet.getAddress())

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});