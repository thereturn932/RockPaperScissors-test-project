# RockPaperScissors test project

You will create a smart contract named `RockPaperScissors` whereby:  
Alice and Bob can play the classic game of rock, paper, scissors using ERC20 (of your choosing).    
  
- To enroll, each player needs to deposit the right token amount, possibly zero.  
- To play, each Bob and Alice need to submit their unique move.  
- The contract decides and rewards the winner with all token wagered.  

There are many ways to implement this, so we leave that up to you.  
  
## Stretch Goals
Nice to have, but not necessary.
- Make it a utility whereby any 2 people can decide to play against each other.  
    
    <em>People can use Game ID to join another persons game.</em>
- Reduce gas costs as much as possible.
- Let players bet their previous winnings.
- How can you entice players to play, knowing that they may have their funds stuck in the contract if they face an uncooperative player? 
    
    <em>A deadline is entered by created of the game. If time exceeds and one of the players does not make any move, tokens return back to users.</em>
- Include any tests using Hardhat.
  
Now fork this repo and do it!
  
When you're done, please send an email to zak@slingshot.finance (if you're not applying through Homerun) with a link to your fork or join the [Slingshot Discord channel](https://discord.gg/JNUnqYjwmV) and let us know.  
  
Happy hacking!

To test the code first installations should be done

```shell
npm install --save-dev hardhat
npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers
npx hardhat install
```

Then code can be test by running

```shell
npx hardhat test
```

##TO-DO

1. Create a interface to play the game. (Create game, join game)
2. Write better tests
3. Write a backend to hide player moves in contract. (To prevent people reading contract to find their opponents move.)
