// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("SATPTokenContractModule", (m) => {
  const deployer = m.getAccount(0); 
  const tokenOwner = m.getAccount(1); 
  
  const token = m.contract("SATPTokenContract", [deployer, "id1"], {
    from: deployer,
  });

  m.call(
    token,
    "mint",
    [tokenOwner, 100],
    {
      from: deployer,
    }
  );

  m.call(
    token,
    "giveRole",
    ["0x8464135c8f25da09e49bc8782676a84730c318bc"],
    {
      from: deployer,
    }
  );

  m.call(
    token,
    "approve",
    ["0x8464135c8f25da09e49bc8782676a84730c318bc", 100],
    {
      from: tokenOwner,
    }
  );

  return { token };
});
