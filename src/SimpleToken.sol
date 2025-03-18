// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";

contract SimpleToken is ERC20BurnableUpgradeable, OwnableUpgradeable {
    
    /// @notice Disables the ability to call the initializer
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice This function is called by the TokenFactory contract to initialize the token
     * @param name The name of the token
     * @param symbol The symbol of the token
     * @param initialSupply The initial supply of the token
     * @param developer The address of the developer 
    */
    function initialize(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address developer
    ) external initializer {
        __ERC20Burnable_init();
        __ERC20_init(name, symbol);
        __Ownable_init(developer);
        _mint(developer, initialSupply);
    }

    /// @notice This function allows the owner to mint new tokens
    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }
}