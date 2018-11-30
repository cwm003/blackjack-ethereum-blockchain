const Blackjack = artifacts.require("./Blackjack.sol");

contract("Blackjack", accounts => {
  it("Deploy", async () => {
    assert.ok(await Blackjack.deployed());
  });

  it("Enter", async () => {
    const BlackjackInstance = await Blackjack.deployed();
    await BlackjackInstance.enter({ form: accounts[0] , value: 100000000000000000 });
    const players = await BlackjackInstance.getPlayers();
    assert.notEqual(parseInt(players[0]),0);
  });

  // it("Enter", async () => {
  //   const BlackjackInstance = await Blackjack.deployed();
  //   // await BlackjackInstance.enter({ form: accounts[0] , value: 1000000000000000000 });
  //   const players = await BlackjackInstance.getPlayers();
  //   assert.notEqual(parseInt(players[0]),0);
  // });

  it("Sum", async () => {
    const BlackjackInstance = await Blackjack.deployed();
    // await BlackjackInstance.enter({ form: accounts[0] , value: 1000000000000000000 });
    await BlackjackInstance.getPlayerSum({form: accounts[0]}).then(result => {
      assert.notEqual(result[0],0);
    });
  });

  it("Card", async () => {
    const BlackjackInstance = await Blackjack.deployed();
    await BlackjackInstance.getPlayerCard({form: accounts[0]}).then(result => {
      assert.equal(result.length,2);
    });
    
  });

  it("Hit", async () => {
    const BlackjackInstance = await Blackjack.deployed();
    await BlackjackInstance.hit();
    await BlackjackInstance.getPlayerCard({form: accounts[0]}).then(result => {
      assert.equal(result.length,3);
    });
  });

  it("Stand", async () => {
    const BlackjackInstance = await Blackjack.deployed();
    await BlackjackInstance.stand();
    await BlackjackInstance.hit();
    await BlackjackInstance.getPlayerCard({form: accounts[0]}).then(result => {
      assert.equal(result.length,3);
    });
  });

});