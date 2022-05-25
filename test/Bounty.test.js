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
        await instance.contribute({from: accounts[0], value: 1100})

        let funds = await instance.getFunds()

        assert.equal(funds, 1100, "The transaction was successful")
    })

    it("ensures state is yellow after deployment", async () => {
        let state = await instance.state()
        assert.equal(state, 1, "State is Yellow")

    })

    it("ensures that vipName gets saved to vipList", async () => {
        
        await instance.setState(2)
        await instance.contribute({from: accounts[0], value: 1100})

       

        await instance.enterVipList("David", {
            from: accounts[0],
        })

        let vipId = await instance.vipID(accounts[0])

        assert.equal(vipId, "David", "The name was saved to the list")

    })

});
