// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";

contract MyNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable, ERC721Burnable, ERC721Votes {
    uint256 private _nextTokenId;
    mapping(address => bool) private _mintedSuccessfully;
    mapping(uint256 => string) private _tokenNames;
    mapping(uint256 => string) private _tokenSymbols;

    constructor(address initialOwner)
        ERC721("MyNFT", "MNFT")
        Ownable(initialOwner)
        ERC721Votes()
    {
        _nextTokenId = 1; // Start token IDs from 1
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri, string memory name, string memory symbol) external {
        require(to != address(0), "Invalid address");
        uint256 tokenId = _nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _mintedSuccessfully[to] = true;
        _setTokenName(tokenId, name);
        _setTokenSymbol(tokenId, symbol);
        _nextTokenId++; // Increment token ID for the next minting
    }

    function hasMintedSuccessfully(address account) external view returns (bool) {
        return _mintedSuccessfully[account];
    }

    function getAllMintedSuccessfully() external view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 1; i < _nextTokenId; i++) {
            if (_exists(i) && _mintedSuccessfully[ownerOf(i)]) {
                count++;
            }
        }

        address[] memory result = new address[](count);
        uint256 index = 0;
        for (uint256 i = 1; i < _nextTokenId; i++) {
            if (_exists(i) && _mintedSuccessfully[ownerOf(i)]) {
                result[index] = ownerOf(i);
                index++;
            }
        }

        return result;
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _setTokenName(uint256 tokenId, string memory name) internal {
        _tokenNames[tokenId] = name;
    }

    function _setTokenSymbol(uint256 tokenId, string memory symbol) internal {
        _tokenSymbols[tokenId] = symbol;
    }
}
