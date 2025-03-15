// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleToken is ERC20Burnable, Ownable {
    
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _developer
        
    ) ERC20(_name, _symbol) Ownable (_developer) {  
        _mint(_developer, _initialSupply);
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }

}