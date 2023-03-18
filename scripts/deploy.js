const hre = require("hardhat");

const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory(
    "ChainBattles"
  );
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();

  console.log("Contract deployed to: ", nftContract.address);
};

main()
  .then(() => process.getMaxListeners(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
