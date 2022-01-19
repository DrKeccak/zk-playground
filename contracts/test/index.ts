import { expect } from "chai";
import { ethers } from "hardhat";
import { Scaling } from "../";

describe("Scaling", function () {
  it("Should return the new greeting once it's changed", async function () {
    const scaling = (await (
      await ethers.getContractFactory("Scaling")
    ).deploy()) as Scaling;

    await scaling.hash5000Times(1);
  });
});
