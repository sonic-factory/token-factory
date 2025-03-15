// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./SimpleToken.sol";

contract TokenFactory is Ownable, Pausable, ReentrancyGuard {

    address public immutable tokenImplementation;
    address public treasury;
    address[] public tokens;

    uint256 public creationFee;
    uint256 public tokenCounter;

    event TokenCreated(address token, address owner);
    event TreasuryUpdated(address treasury);
    event CreationFeeUpdated(uint256 creationFee);

    error ZeroAddress();
    error IncorrectFee();

    constructor(
        address _tokenImplementation,
        address _treasury,
        uint256 _creationFee
    ) Ownable (msg.sender) {
        if (_tokenImplementation == address(0)) revert ZeroAddress();
        if (_treasury == address(0)) revert ZeroAddress();

        tokenImplementation = _tokenImplementation;
        treasury = _treasury;
        creationFee = _creationFee;
    }

    /*
     * @notice This function is called by the UI to create a new token
     * @param name The name of the token
     * @param symbol The symbol of the token
     * @param initialSupply The initial supply of the token
     * @param developer The address of the developer
    */
    function createToken(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address developer
    ) external payable whenNotPaused nonReentrant {
        if (developer == address(0)) revert ZeroAddress();
        if (msg.value != creationFee) revert IncorrectFee();

        address token = Clones.cloneDeterministic(
            tokenImplementation,
            keccak256(abi.encodePacked(name, symbol, initialSupply, developer))
        );

        SimpleToken(token).initialize(name, symbol, initialSupply, msg.sender);

        tokens.push(token);
        tokenCounter = tokenCounter + 1;

        emit TokenCreated(token, msg.sender);
    }

    /// @notice This function sets the treasury address.
    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "TokenFactory: treasury is the zero address");

        treasury = _treasury;
        emit TreasuryUpdated(_treasury);
    }

    /// @notice This function sets the creation fee.
    function setCreationFee(uint256 _creationFee) external onlyOwner {
        
        creationFee = _creationFee;
        emit CreationFeeUpdated(_creationFee);
    }

    /// @notice This function allows the owner to pause the contract.
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice This function allows the owner to unpause the contract.
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice This function allows the UI to get all the tokens created by the factory.
    function getTokens() external view returns (address[] memory) {
        return tokens;
    }
}
