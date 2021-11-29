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

contract RockPaperScissors {

    address private owner;
    mapping(address => string) public move;
    mapping(address => bool) public moveMade;
    mapping(address => uint) public bet;
    IERC20 private token;


   constructor(IERC20 _token) {
        owner = msg.sender;
        token = _token;
    }

    function PlayRock() external {
        move[msg.sender] = "Rock";
        moveMade[msg.sender] = true;
    }

    function PlayPaper() external {
        move[msg.sender] = "Paper";
        moveMade[msg.sender] = true;
    }

    function PlayScissors() external {
        move[msg.sender] = "Scissors";
        moveMade[msg.sender] = true;
    }

    function FindWinner(address player1, address player2) internal view returns (uint8 result) {
        require(moveMade[player1] == true && moveMade[player2] == true);
        if(keccak256(abi.encodePacked((move[player1]))) == keccak256(abi.encodePacked(("Rock")))  && keccak256(abi.encodePacked((move[player2]))) == keccak256(abi.encodePacked(("Scissors"))))
            return 1;
        if(keccak256(abi.encodePacked((move[player1]))) == keccak256(abi.encodePacked(("Rock")))  && keccak256(abi.encodePacked((move[player2]))) == keccak256(abi.encodePacked(("Paper"))))
            return 2;
        if(keccak256(abi.encodePacked((move[player1]))) == keccak256(abi.encodePacked(("Paper")))  && keccak256(abi.encodePacked((move[player2]))) == keccak256(abi.encodePacked(("Rock"))))
            return 1;
        if(keccak256(abi.encodePacked((move[player1]))) == keccak256(abi.encodePacked(("Paper")))  && keccak256(abi.encodePacked((move[player2]))) == keccak256(abi.encodePacked(("Scissors"))))
            return 2;
        if(keccak256(abi.encodePacked((move[player1]))) == keccak256(abi.encodePacked(("Scissors")))  && keccak256(abi.encodePacked((move[player2]))) == keccak256(abi.encodePacked(("Rock"))))
            return 2;
        if(keccak256(abi.encodePacked((move[player1]))) == keccak256(abi.encodePacked(("Scissors")))  && keccak256(abi.encodePacked((move[player2]))) == keccak256(abi.encodePacked(("Paper"))))
            return 1;
        else
            return 0;
    }

    function ResetMoves(address player1, address player2) internal {
        moveMade[player1] = false;
        moveMade[player2] = false;
    }

    function Bet(uint _bet) external{
        bet[msg.sender] = _bet;
    }

    function TransferMoney(address player1, address player2) external{
        uint8 result = FindWinner(player1, player2);
        address from;
        address to;
        if(result == 1){
            from = player2;
            to = player1;
            }
        if(result == 2){
            from = player1;
            to = player2;
        }
        else
            revert("Draw");
        token.transferFrom(from, to, bet[from]);
        ResetMoves(player1,player2);
    }



}
