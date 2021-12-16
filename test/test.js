const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Rock Paper Scissors Game", async function () {
  it("Plays the game returns winner", async function () {

    [owner, player1, player2] = await ethers.getSigners();

    const GameTokenFactory = await ethers.getContractFactory("RockPaperScissorsToken");
    const GameToken = await GameTokenFactory.deploy();
    await GameToken.deployed();
    console.log("Token contract is deployed")

    const GameFactory = await ethers.getContractFactory("RockPaperScissors");
    const Game = await GameFactory.deploy(GameToken.address);
    await Game.deployed();
    console.log("Game contract is deployed")

    GameToken.transfer(player1.address, hre.ethers.utils.parseEther('200'));
    console.log("Token is given to player 1")
    GameToken.transfer(player2.address, hre.ethers.utils.parseEther('200'));
    console.log("Token is given to player 2")

    var newGameID = 1;



    

    GameToken.connect(player1).approve(Game.address, hre.ethers.utils.parseEther('100'))
    console.log("Player 1 approves token")
    await Game.connect(player1).CreateGame(hre.ethers.utils.parseEther('100'), 30);
    console.log("Player 1 creates a game")

    let createEvent = await new Promise((resolve, reject) => {
      Game.on("GameCreated", (gameID, deadline) => {
        console.log(`Game ID is ${gameID} \nGame will finish at ${deadline}`);
        newGameID = gameID;
        resolve();
      });
      

      setTimeout(() => {
          reject(new Error('timeout'));
      }, 30000)
    });




    await GameToken.connect(player2).approve(Game.address, hre.ethers.utils.parseEther('100'))
    console.log("Player 2 approves token")
    await Game.connect(player2).JoinGame(newGameID);
    console.log("Player 2 joins to the game")

    let balance = await GameToken.balanceOf(Game.address);
    console.log("Balance of contract is ", hre.ethers.utils.formatEther(balance));

    await Game.connect(player1).PlayPaper(newGameID);
    console.log("Player 1 plays Paper")
    await Game.connect(player2).PlayRock(newGameID);
    console.log("Player 2 plays Rock")

    console.log('Waiting for 15 second');
    await new Promise(resolve => setTimeout(resolve, 30000));
    





    await Game.FindWinner(newGameID);

    let finishEvent = await new Promise((resolve, reject) => {
      Game.on("GameFinished", (gameID, winner,event) => {
        if(winner == "0x0000000000000000000000000000000000000000") {
          console.log(`Game ${gameID} is finished \nIt's draw`);
          resolve();
        }
        else {
          console.log(`Game ${gameID} is finished \nWinner is ${winner}`);
        }
        event.removeListener();
        resolve();

      });
    })



  });
});
