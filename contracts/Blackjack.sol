pragma solidity ^0.4.24;
contract Blackjack {

    address private owner;
    address[2] private players;
    address[2] private lastPlayers;
    uint8 private card;
    uint8 private suit;
    uint private rand;
    uint8[] private player1cards;
    uint8[] private player2cards;
    uint8[] private player1cards_suit;
    uint8[] private player2cards_suit;
    uint8 private player1sum = 0;
    uint8 private player2sum = 0;
    bool private player1ace = false;
    bool private player2ace = false;
    bool private player1stand = false;
    bool private player2stand = false;
    bool private endGame = false;
    uint8 whoWin = 0;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function enter() public payable returns(uint8[]){
        require(msg.value == 1 ether && msg.sender != players[0] && msg.sender != players[1]);
        
        if(endGame == true){
            delete lastPlayers;
            endGame = false;
            whoWin = 0;
        }
        //player1
        if(players[0] == 0){
            players[0] = msg.sender;
            delete player1cards;
            //card1
            player1draw();
            //card2
            player1draw();

            if(player1sum == 21){
                player1stand = true;
            }

            return player1cards;
        }
        
        //player2
        if(players[1] == 0 && msg.sender != players[0]){
            players[1] = msg.sender;
            delete player2cards;
            //card1
            player2draw();
            //card2
            player2draw();

            if(player1sum == 21){
                player2stand = true;
            }

            return player2cards;
        }
    }
    
    function player1draw() private{
        card = uint8(( random() % 13 ) + 1);
        suit = uint8(randomSuit() % 4);
        player1cards.push(card);
        player1cards_suit.push(suit);
        if(card >= 10){
            player1sum += 10;
        }else if(card == 1 && player1sum <= 10){
            player1sum += 11;
            player1ace = true;
        }else{
            player1sum += card;
        }
    }
    
    function player2draw() private{
        card = uint8(( random() % 13 ) + 1);
        suit = uint8(randomSuit() % 4);
        player2cards_suit.push(suit);
        player2cards.push(card);    
        if(card >= 10){
            player2sum += 10;
        }else if(card == 1 && player2sum <= 10){
            player2sum += 11;
            player2ace = true;
        }else{
            player2sum += card;
        }
    }
    
    function hit() public{
        if(msg.sender == players[0] && player1stand == false && endGame == false){
            player1draw();
            if(player1sum > 21 && player1ace == false){
                player1sum = 0;
                player1stand = true;
            }
            else if(player1sum > 21 && player1ace == true){
                player1sum -= 10;
                player1ace == false;
            }
        }else if(msg.sender == players[1] && player2stand == false && endGame == false){
            player2draw();
            if(player2sum > 21 && player2ace == false){
                player2sum = 0;
                player2stand = true;
            }
            else if(player2sum > 21 && player2ace == true){
                player2sum -= 10;
                player2ace = false;
            }
        }if(player1stand == true && player2stand == true){
            findWinner();
        }
    }
    
    function stand() public{
        if(msg.sender == players[0]){
            player1stand = true;
        }else if(msg.sender == players[1]){
            player2stand = true;
        }if(player1stand == true && player2stand == true){
            findWinner();
        }
    }
    
    function findWinner() private{
        if(player1sum > player2sum){
            owner.transfer(address(this).balance/20);
            players[0].transfer(address(this).balance);
            whoWin = 1;
        }else if(player2sum > player1sum){
            owner.transfer(address(this).balance/20);
            players[1].transfer(address(this).balance);
            whoWin = 2;
        }else{
            owner.transfer(address(this).balance/20);
            players[0].transfer(address(this).balance/2);
            players[1].transfer(address(this).balance);
            whoWin = 3;
        }end();
    }
    
    function end() private{
        lastPlayers = players;
        delete players;
        player1sum = 0;
        player2sum = 0;
        player1stand = false;
        player2stand = false;
        player1ace = false;
        player2ace = false;
        endGame = true;
    }
    
    function random() private view returns (uint){
        rand += uint(keccak256(block.difficulty,now,players,players.length));
        return uint(keccak256(block.difficulty,now,players,players.length,rand));
    }
    
    function randomSuit() private view returns (uint){
        rand += uint(keccak256(block.difficulty,now,players,players.length));
        return uint(keccak256(rand,players.length,players,now,block.difficulty));
    }
    
    function getPlayerCard()public view returns(uint8[]){
        if(msg.sender == players[0] || msg.sender == lastPlayers[0]){
            return player1cards;
        }
        else if(msg.sender == players[1] || msg.sender == lastPlayers[1]){
            return player2cards;
        }
    }

    function getPlayerSum()public view returns(uint8){
        if(msg.sender == players[0]){
            return player1sum;
        }
        else if(msg.sender == players[1]){
            return player2sum;
        }
    } 

    function getPlayersCardSuit()public view returns(uint8[]){
        if(msg.sender == players[0] || msg.sender == lastPlayers[0]){
            return player1cards_suit;
        }
        else if(msg.sender == players[1]|| msg.sender == lastPlayers[1]){
            return player2cards_suit;
        }
    }    
    
    function getPlayers()public view returns(address[2]){
        return players;
    }

    function getOwner()public view returns(address){
        return owner;
    }

    function getWhoWin()public view returns(uint8){
        uint8 state = whoWin;
        if(msg.sender == players[0] || msg.sender == lastPlayers[0]){
            return state;
        }
        else if(msg.sender == players[1] || msg.sender == lastPlayers[1]){
            if(whoWin == 1){state = 2;}
            else if(whoWin == 2){state = 1;}
            return state;
        }
    }
    
}