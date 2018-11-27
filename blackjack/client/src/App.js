import React, { Component } from "react";
import SimpleStorageContract from "./contracts/SimpleStorage.json";
import BlackjackContract from "./contracts/blackjack.json";
import getWeb3 from "./utils/getWeb3";
import truffleContract from "truffle-contract";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const Contract = truffleContract(BlackjackContract);
      Contract.setProvider(web3.currentProvider);
      const instance = await Contract.deployed();

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }/*, this.runExample*/);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.log(error);
    }
  };

  // runExample = async () => {
  //   const { accounts, contract } = this.state;

  //   const players = await contract.getPlayers()
  //   console.log(players)



    // Stores a given value, 5 by default.
    // await contract.set(5, { from: accounts[0] });

    // Get the value from the contract to prove it worked.
    // const response = await contract.get();

    // Update state with the result.
    // this.setState({ storageValue: response.toNumber() });
  // };

  enter() {
    const { web3, accounts, contract,instance } = this.state;
    // instance.depositeFunds({from: accounts[0],value: 1000000000000000000});
    contract.enter({ from: accounts[0],value: 1000000000000000000});
    console.log("enter");
  }

  checkPlayer(){
    const { contract } = this.state;
    const players = contract.getPlayers();
    console.log(players.map);
  }

  showCard(){
    const { contract } = this.state;
    const card = contract.getPlayer1card();
    // const suit = contract.getPlayers1cardSuit();
    // for (var i = 0; i < 3; i++) {
    //   console.log(card[i]);
    //   console.log("show");
    // } 
    console.log(card);
    // console.log(test);
    console.log("showwewq");
    // console.log(suit);
  }

  getSum(){
    const { contract } = this.state;
    const sum = contract.getPlayer1Value();
    console.log(sum);
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Blackjack</h1>
        <button onClick={()=>this.enter()}>Play! 1 ETH</button>
        <button onClick={()=>this.checkPlayer()}>check Player</button>
        <button onClick={()=>this.showCard()}>show cards</button>
        <button onClick={()=>this.getSum()}>get sum</button>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 40</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.storageValue}</div>
      </div>
    );
  }

  
}

export default App;
