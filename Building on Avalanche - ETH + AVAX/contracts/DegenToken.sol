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
