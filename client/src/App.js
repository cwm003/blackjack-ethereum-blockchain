import React, { Component } from "react";
import BlackjackContract from "./contracts/blackjack.json";
import getWeb3 from "./utils/getWeb3";
import truffleContract from "truffle-contract";
import { Col, Navbar, Alert, ButtonGroup, ButtonToolbar, Row } from "react-bootstrap";
import Grid from '@material-ui/core/Grid';
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
    const { accounts, contract } = this.state;
    // instance.depositeFunds({from: accounts[0],value: 1000000000000000000});
    contract.enter({ from: accounts[0], value: 1000000000000000000 });
    console.log("enter");
  }

  checkPlayer() {
    const { contract } = this.state;
    const players = contract.getPlayers();
    console.log(players);
  }

  // showCard(){
  //   const { contract,accounts } = this.state;
  //   const card = contract.getPlayerCard({from: accounts[0]}).then(result => {
  //     console.log(result[0].words[0]);
  //   });  
  //   // const suit = contract.getPlayers1cardSuit();
  //   // for (var i = 0; i < 3; i++) {
  //   //   console.log(card[i]);
  //   //   console.log("show");
  //   // } 
  //   // console.log(card);
  //   // console.log(test);
  //   // console.log("showwewq");
  //   // console.log(suit);
  // }

  showCard() {
    const { contract, accounts } = this.state;
    contract.getPlayerCard({ from: accounts[0] }).then(result => {
      contract.getPlayersCardSuit({ from: accounts[0] }).then(result2 => {
        var state = this.state;
        state.card = [];
        for (var i = 0; i < result.length; i++) {
          var color = { color: "black", display: "inline" };
          if (result[i].words[0] === 1) result[i].words[0] = "A";
          else if (result[i].words[0] === 11) result[i].words[0] = "J";
          else if (result[i].words[0] === 12) result[i].words[0] = "Q";
          else if (result[i].words[0] === 13) result[i].words[0] = "K";
          if (result2[i].words[0] === 0) result2[i].words[0] = "♣  ";
          else if (result2[i].words[0] === 1) { result2[i].words[0] = "♦  "; color.color = "red"; }
          else if (result2[i].words[0] === 2) { result2[i].words[0] = "♥  "; color.color = "red"; }
          else if (result2[i].words[0] === 3) result2[i].words[0] = "♠  ";
          state.card.push([result[i].words[0] + result2[i].words[0], color]);
          console.log(result[i].words[0]);
          console.log(result2[i].words[0]);
        }
        this.setState(state)
      });
    });
    contract.getWhoWin({ from: accounts[0] }).then(result => {
      var state = this.state;
      if (result.words[0] === 0) result.words[0] = "Game is in process";
      else if (result.words[0] === 1) result.words[0] = "You win!!!";
      else if (result.words[0] === 2) result.words[0] = "You lose!!!";
      else if (result.words[0] === 3) result.words[0] = "Draw!!!";
      state.whowin = result.words[0];
      this.setState(state)
      console.log(result.words[0]);
    });
  }

  getSum() {
    const { contract, accounts } = this.state;
    contract.getPlayerSum({ from: accounts[0] }).then(result => {
      var state = this.state;
      state.sum = result.words[0]
      this.setState(state)
      console.log(result.words[0]);
    });

  }

  hit() {
    const { contract, accounts } = this.state;
    contract.hit({ from: accounts[0] }).then(result => {
      console.log("hit");
    });
  }

  stand() {
    const { contract, accounts } = this.state;
    contract.stand({ from: accounts[0] }).then(result => {
      console.log("stand");
    });
  }

  render() {

    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <Navbar className="staticTop" inverse="true">
          <Navbar.Header>
            <Navbar.Brand>
              <a href="#">Blackjack-Blockchain</a>
            </Navbar.Brand>
          </Navbar.Header>
        </Navbar>
        <center>
          <Col xs={12}>
            <Alert bsStyle="warning" style={{ width: "50%" }}>
              <strong>WARNING</strong> - Ethereum is used for payment method for this site.
            </Alert>
            <Alert bsStyle="info" style={{ width: "50%" }}>
              <strong>ATTENTION</strong> - For each round, 1 ETH is required for playing.
            </Alert>
          </Col>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <Col>
          {
            this.state.card ?
              this.state.card.map(e => <h2 style={e[1]}>{e[0]}</h2>) : null
          }
          <br></br>
          {
            this.state.whowin ?
              this.state.whowin : null
          }
        </Col>
        <br/>
        <br/>
        <br/>
        </center>

        <Row>
          <Col className="col-md-6 col-md-offset-3">
            <ButtonToolbar>
              <ButtonGroup bsSize="large">
                <button type="button" className="btn btn-warning"
                    style={{ width: 150 }} onClick={() => this.enter()}>Play!</button>
                <button type="button" className="btn btn-danger"
                    style={{ width: 150 }} onClick={() => this.hit()}>Hit</button>
                <button type="button" className="btn btn-primary"
                    style={{ width: 150 }} onClick={() => this.stand()}>Stand</button>
                <button type="button" className="btn btn-default"
                    style={{ width: 150 }} onClick={() => this.showCard()}>Show Result</button>
              </ButtonGroup>
            </ButtonToolbar>
          </Col>
        </Row>
        
      </div>
    );
  }
}

export default App;
