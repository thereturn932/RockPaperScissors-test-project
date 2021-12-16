pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

/*

You will create a smart contract named `RockPaperScissors` whereby:
Alice and Bob can play the classic game of rock, paper, scissors using ERC20 (of your choosing).

- To enroll, each player needs to deposit the right token amount, possibly zero.
- To play, each Bob and Alice need to submit their unique move.
- The contract decides and rewards the winner with all token wagered.

There are many ways to implement this, so we leave that up to you.
*/
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract RockPaperScissors {

    event GameCreated(uint gameID, uint deadline);
    event GameFilled(uint gameID);
    event GameFinished(uint gameID, address winner);

    address private owner;
    
    mapping(address => bool) public moveMade;
    mapping(address => uint) public bet;
    IERC20 private token;

    struct Game{
        address player1;
        address player2;
        string moveP1;
        string moveP2;
        uint bet;
        uint gameID;
        uint deadline;
    }

    uint GameNo = 0;
    mapping(uint => Game) private _games;

   constructor(address _token) {
        owner = msg.sender;
        token = IERC20(_token);
    }

    function CreateGame(uint _bet, uint time) external {
        assert(0x0000000000000000000000000000000000000000 != msg.sender);
        require(time <= 30 * 60, "Game should finish in 30 minutes");
        GameNo++;
        uint GameID = GameNo;
        _games[GameID].player1 = msg.sender;
        _games[GameID].player2 = 0x0000000000000000000000000000000000000000;
        _games[GameID].bet = _bet;
        _games[GameID].gameID = GameID;
        _games[GameID].deadline = block.timestamp + time;
        token.transferFrom(msg.sender, address(this), _bet);
        emit GameCreated(_games[GameID].gameID, _games[GameID].deadline);
    }

    function JoinGame(uint _gameID) external {
        require(_games[_gameID].player2 == 0x0000000000000000000000000000000000000000);
        token.transferFrom(msg.sender, address(this), _games[_gameID].bet);
        _games[_gameID].player2 = msg.sender;

        emit GameFilled(_gameID);
    }

    function PlayRock(uint _gameID) external {
        if(msg.sender == _games[_gameID].player1){
            _games[_gameID].moveP1 = "Rock";
        }
        else {
            require(msg.sender == _games[_gameID].player2);
            _games[_gameID].moveP2 = "Rock";
        }
    }

    function PlayPaper(uint _gameID) external {
        if(msg.sender == _games[_gameID].player1){
            _games[_gameID].moveP1 = "Paper";
        }
        else {
            require(msg.sender == _games[_gameID].player2);
            _games[_gameID].moveP2 = "Paper";
        }
    }

    function PlayScissors(uint _gameID) external {
        if(msg.sender == _games[_gameID].player1){
            _games[_gameID].moveP1 = "Scissors";
        }
        else {
            require(msg.sender == _games[_gameID].player2);
            _games[_gameID].moveP2 = "Scissors";
        }
    }

    function FindWinner(uint _gameID) external {
        address winner = 0x0000000000000000000000000000000000000000;
        require(_games[_gameID].deadline <= block.timestamp);
        if(keccak256(abi.encodePacked(_games[_gameID].moveP1)) == keccak256(abi.encodePacked("")) || keccak256(abi.encodePacked(_games[_gameID].moveP1)) == keccak256(abi.encodePacked(""))) {
            token.transfer(_games[_gameID].player1, _games[_gameID].bet);
            token.transfer(_games[_gameID].player2, _games[_gameID].bet);
            emit GameFinished(_gameID, winner);
            return;
        }
        else {
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked(("Rock")))  && keccak256(abi.encodePacked((_games[_gameID].moveP2))) == keccak256(abi.encodePacked(("Scissors"))))
            {
                token.transfer(_games[_gameID].player1, _games[_gameID].bet*2);
                winner = _games[_gameID].player1;
            }
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked(("Rock")))  && keccak256(abi.encodePacked((_games[_gameID].moveP2))) == keccak256(abi.encodePacked(("Paper"))))
            {
                token.transfer(_games[_gameID].player2, _games[_gameID].bet*2);
                winner = _games[_gameID].player2;
            }
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked(("Paper")))  && keccak256(abi.encodePacked((_games[_gameID].moveP2))) == keccak256(abi.encodePacked(("Rock"))))
            {
                token.transfer(_games[_gameID].player1, _games[_gameID].bet*2);
                winner = _games[_gameID].player1;
            }
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked(("Paper")))  && keccak256(abi.encodePacked((_games[_gameID].moveP2))) == keccak256(abi.encodePacked(("Scissors"))))
            {
                token.transfer(_games[_gameID].player2, _games[_gameID].bet*2);
                winner = _games[_gameID].player2;
            }
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked(("Scissors")))  && keccak256(abi.encodePacked((_games[_gameID].moveP2))) == keccak256(abi.encodePacked(("Rock"))))
            {   
                token.transfer(_games[_gameID].player2, _games[_gameID].bet*2);
                winner = _games[_gameID].player2;
            }
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked(("Scissors")))  && keccak256(abi.encodePacked((_games[_gameID].moveP2))) == keccak256(abi.encodePacked(("Paper"))))
            {
                token.transfer(_games[_gameID].player1, _games[_gameID].bet*2);
                winner = _games[_gameID].player1;
            }
            if(keccak256(abi.encodePacked((_games[_gameID].moveP1))) == keccak256(abi.encodePacked((_games[_gameID].moveP2)))) {
                token.transfer(_games[_gameID].player1, _games[_gameID].bet);
                token.transfer(_games[_gameID].player2, _games[_gameID].bet);
            }   
        }
        emit GameFinished(_gameID, winner);
    }
}
