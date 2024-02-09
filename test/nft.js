// tests/MyNft.test.js
import { expect } from "chai";
import { ethers } from "hardhat";
import "esm";

describe("MyNft", function () {
  this.timeout(50000);
  let MyNft;
  let myNft; // Fix variable name
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    MyNft = await ethers.getContractFactory("MyNft");
    [owner, addr1, addr2] = await ethers.getSigners();

    myNft = await MyNft.deploy(); // Fix variable name
  });

  it("Should set the right owner", async function () {
    expect(await myNft.owner()).to.equal(owner.address);
  });

  it("Should mint one NFT", async function () {
    expect(await myNft.balanceOf(addr1.address)).to.equal(0);

    const tokenURI = "QmRotf6URT25TVZX4h4iwgXThLPn1XyewZ1UnacF5G7tsW";

    // Mint an NFT
    await myNft.safeMint(addr1.address, tokenURI);

    // Check the balance after minting
    expect(await myNft.balanceOf(addr1.address)).to.equal(1);
  });

  it("Should mint an NFT and get the list of minted addresses", async function () {
    // Mint an NFT
    await myNft.safeMint(addr1.address, tokenURI);

    // Get the list of minted addresses
    const mintedAddresses = await myNft.getMintedAddresses();

    // Expect the list to contain the minted address
    expect(mintedAddresses).to.include(addr1.address);
  });

  it("Should not include an address that has not minted", async function () {
    // Get the list of minted addresses before minting
    const mintedAddressesBefore = await myNft.getMintedAddresses();

    // Mint an NFT
    await myNft.safeMint(addr1.address, "tokenURI");

    // Get the list of minted addresses after minting
    const mintedAddressesAfter = await myNft.getMintedAddresses();

    // Expect the list before and after to be different
    expect(mintedAddressesBefore).to.not.include(addr1.address);
    expect(mintedAddressesAfter).to.include(addr1.address);
  });
});
