pragma solidity ^0.4.25;
contract blackjack {

    address public owner;
    address[] private players;
    uint8 private card;
    uint private rand;
    uint[] private player1cards;
    uint[] private player2cards;
    uint8 private player1sum = 0;
    uint8 private player2sum = 0;
    bool private player1ace = false;
    bool private player2ace = false;
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
        }
        
        //player2
        if(players.length == 1 && msg.sender != players[0]){
            players.push(msg.sender);
            //card1
            player2draw();
            //card2
            player2draw();
        }
    }
    
    function player1draw() private{
        card = uint8(( random() % 13 ) + 1);
        player1cards.push(card);
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
        if(msg.sender == players[0] && player1stand == false){
            player1draw();
            if(player1sum >= 21 && player1ace == false){
                player1sum = 0;
                player1stand = true;
            }
            else if(player1sum >= 21 && player1ace == true){
                player1sum -= 10;
                player1ace == false;
            }
        }else if(msg.sender == players[1] && player2stand == false){
            player2draw();
            if(player2sum >= 21 && player2ace == false){
                player2sum = 0;
                player2stand = true;
            }
            else if(player2sum >= 21 && player2ace == true){
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
        }else if(player2sum > player1sum){
            owner.transfer(address(this).balance/20);
            players[1].transfer(address(this).balance);
        }else{
            owner.transfer(address(this).balance/20);
            players[0].transfer(address(this).balance/2);
            players[1].transfer(address(this).balance);
        }end();
    }
    
    function end() private{
        delete players;
        delete player1cards;
        delete player2cards;
        player1sum = 0;
        player2sum = 0;
        player1stand = false;
        player2stand = false;
        player1ace = false;
        player2ace = false;
    }
    function random() private view returns (uint){
        rand += uint(keccak256(block.difficulty,now,players,players.length));
        return uint(keccak256(block.difficulty,now,players,players.length,rand));
    }
    
    function getPlayer1card()public view returns(uint[]){
        return player1cards;
    }
    
    function getPlayer1Value()public view returns(uint){
        return player1sum;
    }
    
    function getPlayer2card()public view returns(uint[]){
        return player2cards;
    }
    
    function getPlayer2Value()public view returns(uint){
        return player2sum;
    }
    
    function getPlayers()public view returns(address[]){
        return players;
    }
}