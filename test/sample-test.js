const {expect} = require("chai");
const {ethers} = require("hardhat");
const {parseUnits} = require("ethers/lib/utils");

describe("BatchEnter", function () {
    // let token : Contract
    // it("Should deploy without problems", async function () {

    let journey;
    let ftg;
    let account;

    before(async function () {
    // journey = await ethers.getContractAt('Journey', '0xd265be9E5BB7D87a52B758219061889B6bd70935')
    // ftg = await ethers.getContractAt('FantomonTrainer', '0x7881F945cF86473749950B5DD3ED59f7034daF4B')

            const Ftg = await ethers.getContractFactory("FantomonTrainer");
            ftg = await Ftg.deploy('0x406e0a6d2dfd526c2b44628990ebf98535890606');

            await ftg.deployed();
            const Journey = await ethers.getContractFactory("Journey");
            journey = await Journey.deploy(ftg.address);
            await journey.deployed()
            console.log("Journey : " + journey.address)
            console.log("ftg : " + ftg.address)
            expect(journey.address).exist
            expect(ftg.address).exist
        let signer = await ethers.getSigner()
        account = signer.address
    })


    it("should mint without issues", async function () {
        await ftg.mint(2, {value: parseUnits('20')})
        expect(await ftg.getStatus(1)).to.equal(0)
        expect(await ftg.getStatus(2)).to.equal(0)
        let owner = await ftg.ownerOf(1)
        console.log("owner = "+owner)
        // expect(await ftg.getStatus(3)).to.equal(0)
        // expect(ftg.getBalance()).to.equal(30)
    });


// await minting.wait()
    it("should not enter", async function (){
        await ftg.setApprovalForAll(journey.address,true)
        await journey.setPause(true)
        const tx = journey.enterJourney([1, 2], {gasLimit: 30000000})
        console.log(await tx)
        expect(await tx).to.throw;
    })

    it('should enter without error', async function () {
        await ftg.setApprovalForAll(journey.address,true)
        console.log(await ftg.isApprovedForAll(account,journey.address))
        console.log('approved')
        expect(await ftg.location_(1)).to.equal('0x0000000000000000000000000000000000000000')

        const tx = journey.enterJourney([1, 2], {gasLimit: 30000000})
        // console.log(tx)
        await tx;
        console.log(await ftg.totalSupply())
        expect(await ftg.getStatus(1)).to.equal(4)
        // expect(await ftg.getStatus(2)).to.equal(4)
        // expect(await ftg.getStatus(3)).to.equal(4)
        expect(await ftg.location_(1)).to.equal(journey.address)
        // expect(await ftg.location_(3)).to.equal(journey.address)
        // expect(await ftg.location_(2)).to.equal(journey.address)
    });

    it("should leave properly", async function(){
        const tx = journey.leaveJourney([1,2])
        await tx;
        expect(await ftg.getStatus(1)).to.equal(0)
        const c1=await ftg.getCourage(1)
        const c2=await ftg.getCourage(2)
        console.log("courage : "+c1+" "+c2)
    })
})

// const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
// await setGreetingTx.wait();

// expect(await greeter.greet()).to.equal("Hola, mundo!");

