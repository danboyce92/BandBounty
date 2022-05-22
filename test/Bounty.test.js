const Bounty = artifacts.require("Bounty");

contract("Bounty", (accounts) => {
    before(async () => {
        instance = await Bounty.deployed()
    })

    it("ensures that starting state is Yellow / 1", async () => {
        let state = await instance.checkState()
        assert.equal(state, 1, "The initial state should be 1 or Yellow") 
    })

    it("ensures that contribute function sends contribution", async () => {
        await instance.contribute({from: accounts[0], value: 101})

        let funds = await instance.getFunds()

        assert.equal(funds, 101, "The transaction was successful")
    })

});
