pragma solidity ^0.4.25;
contract blackjack {

    address public owner;
    address[] private players;
    uint private card;
    uint private rand;
    uint[] private player1cards;
    uint[] private player2cards;
    uint[] private player1cardsValue;
    uint[] private player2cardsValue;
    uint private player1sum = 0;
    uint private player2sum = 0;
    bool private player1stand = false;
    bool private player2stand = false;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function enter() public payable{
        require(msg.value == 1 ether && players.length <= 2);
        
        //player1
        if(players.length == 0){
            players.push(msg.sender);
            //card1
            player1draw();
            
            //card2
            player1draw();
            
            //checkACE
            if(player1cardsValue[0] == 1 && player1cardsValue[1] == 10){
                player1cardsValue[0] == 11;
            }
            else if(player1cardsValue[0] == 10 && player1cardsValue[1] == 1){
                player1cardsValue[1] == 11;
            }
        }
        
        //player2
        if(players.length == 1 && msg.sender != players[0]){
            players.push(msg.sender);
            //card1
            player2draw();
            
            //card2
            player2draw();
            
            //checkACE
            if(player2cardsValue[0] == 1 && player2cardsValue[1] == 10){
                player2cardsValue[0] == 11;
            }
            else if(player2cardsValue[0] == 10 && player2cardsValue[1] == 1){
                player2cardsValue[1] == 11;
            }
        }
    }
    
    function player1draw() private{
        card = ( random() % 13 ) + 1;
        player1cards.push(card);
        if(card >= 10){
            player1cardsValue.push(10);
            player1sum += 10;
        }else{
            player1cardsValue.push(card);
            player1sum += card;
        }
    }
    
    function player2draw() private{
        card = ( random() % 13 ) + 1;
        player2cards.push(card);
        if(card >= 10){
            player2cardsValue.push(10);
            player2sum += 10;
        }else{
            player2cardsValue.push(card);
            player2sum += card;
        }
    }
    
    function hit() public{
        if(msg.sender == players[0] && player1stand == false){
            player1draw();
            if(player1sum >= 21){
                player1stand = true;
            }
        }else if(msg.sender == players[1] && player2stand == false){
            player2draw();
            if(player2sum >= 21){
                player2stand = true;
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
        if(player1sum > player2sum && player1sum <= 21){
            players[0].transfer(this.balance);
        }else if(player2sum > player1sum && player2sum <= 21){
            players[1].transfer(this.balance);
        }else{
            players[0].transfer(this.balance/3);
            players[1].transfer(this.balance/3);
            owner.transfer(this.balance/3);
        }end();
    }
    
    function end()private{
        delete players;
        delete player1cards;
        delete player2cards;
        delete player1cardsValue;
        delete player2cardsValue;
        player1sum = 0;
        player2sum = 0;
        player1stand = false;
        player2stand = false;
    }
    function random() private view returns (uint){
        rand += uint(keccak256(block.difficulty,now,players,players.length));
        return uint(keccak256(block.difficulty,now,players,players.length,rand));
    }
    
    function getPlayer1card()public view returns(uint[]){
        return player1cards;
    }
    
    function getPlayer1cardValue()public view returns(uint[]){
        return player1cardsValue;
    }
    
    function getPlayer2card()public view returns(uint[]){
        return player2cards;
    }
    
    function getPlayer2cardValue()public view returns(uint[]){
        return player2cardsValue;
    }
    
    function getPlayers()public view returns(address[]){
        return players;
    }
}