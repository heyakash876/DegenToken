// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
   
    struct Item {
        string name;
        uint256 price;
    }

   
    mapping(uint256 => Item) private items;
    

    uint256 private Count;

    
        constructor() ERC20("Degen", "DGN") {
    
        insertItem("swags", 20);
        insertItem("merch", 40);
        insertItem("NFT", 60);
    
    }

    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Override of the transfer function to include a check for the sender's balance
    function transfer(address to, uint256 amount) public override returns (bool) {
        return super.transfer(to, amount);
    }

    
    function insertItem(string memory name, uint256 price) public onlyOwner {
        Count++;
        items[Count] = Item(name, price);
    }

    
    function getItem(uint256 itemId) public view returns (string memory, uint256) {
        require(itemId <= Count, "PLease enter a valid item id");
        Item memory item = items[itemId];
        return (item.name, item.price);
    }

  
    
    function showItems() public view returns (string memory) {
        string memory allItems;
        
        for (uint256 i = 1; i <= Count; i++) {
            (string memory itemName, uint256 itemPrice) = getItem(i);
            allItems = string(abi.encodePacked(allItems, uintToString(i), ": ", itemName, " - Price: ", uintToString(itemPrice), "\n"));
        }
        
        return allItems;
    }


    function redeemItem(uint256 itemId) public {
        require(itemId <= Count, "Please enter a valid item id");
        Item memory item = items[itemId];
        require(item.price <= balanceOf(msg.sender), "You do not have sufficient balance for this purchase");

        _burn(msg.sender, item.price);
        
    }

    // Utility function to convert a uint to a string
    function uintToString(uint256 value) private pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        
        uint256 temp = value;
        uint256 digits;
        
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        
        return string(buffer);
    }
}
