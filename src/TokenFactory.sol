// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./SimpleToken.sol";

contract TokenFactory is Ownable, Pausable, ReentrancyGuard {

    address public tokenImplementation;
    address[] public tokens;

    event TokenCreated(address token, address owner);

    constructor(address _tokenImplementation) {
        tokenImplementation = _tokenImplementation;
    }

    function createToken(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _developer
    ) external whenNotPaused nonReentrant {
        address token = tokenImplementation.cloneDeterministic(
            keccak256(abi.encodePacked(_name, _symbol, _initialSupply, _developer))
        );

        SimpleToken(token).initialize(_name, _symbol, _initialSupply, msg.sender);

        tokens.push(token);

        emit TokenCreated(token, msg.sender);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function getTokens() external view returns (address[] memory) {
        return tokens;
    }
}
