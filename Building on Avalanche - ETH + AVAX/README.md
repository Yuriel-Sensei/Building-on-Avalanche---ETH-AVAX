# Building on Avalanche

This Solidity program includes a contract that utilizes MetaMask to mint, burn, and transfer, redeem tokens, and checking the balance from other accounts while utilizing AVAX currency and Avalanche.
## Getting Started

### Executing program

- To get started with the `DegenToken` contract, you'll need to use the [Remix's Solidity IDE](https://remix.ethereum.org/).
- Once you are on the Remix website, create a new file named `DegenToken.sol`.
- Copy and paste the `DegenToken` contract code you created into the `DegenToken.sol` file.
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    event Minted(address indexed recipient, uint256 amount);
    event Burned(address indexed burner, uint256 amount);
    event Redeemed(address indexed redeemer, string item, uint256 amount);

    constructor() ERC20("Degen", "DGN") {}

    // Mint new tokens, only callable by the owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    // Burn tokens owned by the caller
    function burn(uint256 amount) public override {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    // Redeem tokens for in-game items
    function redeemTokens(uint256 choice) external {
        string memory item;
        uint256 cost;

        if (choice == 1) {
            item = "Rare Armor";
            cost = 3 * (10 ** decimals());
        } else if (choice == 2) {
            item = "Magic Wand";
            cost = 2 * (10 ** decimals());
        } else if (choice == 3) {
            item = "Health Potion";
            cost = 1 * (10 ** decimals());
        } else {
            revert("Invalid reward selection");
        }

        require(balanceOf(msg.sender) >= cost, "Insufficient tokens to redeem this reward");
        _burn(msg.sender, cost);
        emit Redeemed(msg.sender, item, cost);
    }

    // Check the token balance of the caller
    function getMyBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Display redeemable items
    function getRedeemableItems() external pure returns (string memory) {
        return "1. Rare Armor (30 DGN)\n2. Magic Wand (20 DGN)\n3. Health Potion (10 DGN)";
    }

    // Transfer function
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, to, amount);
        return true;
    }
}
```
- Finally, compile the contract by selecting the Solidity compiler and clicking the "Compile" button.

### Deploying the Contract

1. In Remix, go to the "Deploy & Run Transactions" tab.
2. Select the `DegenToken` contract from the dropdown menu.
3. Choose Injected Provider - MetaMask.
4. Click the "Deploy" button to deploy the contract.

### Interacting with the Contract

* Once deployed, you can interact with the contract using the Remix interface.
   - To mint tokens to an account, copy the account's address and paste it in the address field, then input the value to be minted, then click the `mint` button. You are then prompted to accept or reject the transaction on MetaMask then it adds the total supply of tokens
   - To transfer tokens from one account to another, copy a different account's address and paste it in the `to` field, then copy the previous account's address and paste it in the `from` address field, then input the value to be transferred to the other account, then click the `transfer` button. You are then prompted to accept or reject the transaction on MetaMask, accepting it will transfer the total supply of tokens from the first account, to a second account.
   - To redeem tokens from one account to another, simply enter a number from 1 - 3 to take your pick on which items to choose from then click `redeemTokens`, you are then prompted to accept or reject the transaction on MetaMask before getting that specific item.
   - To check for an account's token balance, simply paste an account's address, and click `balanceOf`. This will display the account's total balance.
   - To burn tokens to an account, copy the account's address and paste it in the address field, then input the value to be burned, then click the `burn` button. This will deduct the total supply of tokens, but first you are then prompted to accept or reject the transaction on MetaMask in order to do so.

## Authors

Miguel Lacanienta
[@MiguelLacanienta](https://www.facebook.com/miguel.lacanienta.16/)
