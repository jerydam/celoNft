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

contract MyNft is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable, ERC721Burnable, EIP712, ERC721Votes {
    uint256 private _nextTokenId;
    mapping(address => bool) private _mintedSuccessfully;
    mapping(uint256 => string) private _tokenNames;
    mapping(uint256 => string) private _tokenSymbols;

    event Minted(uint256 indexed tokenId, address indexed to, string uri);

    constructor(address initialOwner)
        ERC721("MyNft", "MNFT")
        Ownable(initialOwner)
        EIP712("MyNft", "1")
    {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri, string memory name, string memory symbol) public onlyOwner {
        // Validate recipient address
        require(to != address(0), "Invalid recipient address");

        // Validate URI
        require(bytes(uri).length > 0, "URI must not be empty");

        // Check if address has already minted a token
        require(!_mintedSuccessfully[to], "Address has already minted a token");

        // Generate token ID securely
        uint256 tokenId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _nextTokenId)));

        // Mint the token
        _safeMint(to, tokenId);

        // Set the token URI
        _setTokenURI(tokenId, uri);

        // Mark address as successfully minted
        _mintedSuccessfully[to] = true;

        // Set token name and symbol
        _setTokenName(tokenId, name);
        _setTokenSymbol(tokenId, symbol);

        // Emit event for successful minting
        emit Minted(tokenId, to, uri);
    }

    function hasMintedSuccessfully(address account) public view returns (bool) {
        return _mintedSuccessfully[account];
    }

    function getAllMintedSuccessfully() public view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (_mintedSuccessfully[ownerOf(i)]) {
                count++;
            }
        }

        address[] memory result = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (_mintedSuccessfully[ownerOf(i)]) {
                result[index] = ownerOf(i);
                index++;
            }
        }

        return result;
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable, ERC721Votes)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable, ERC721Votes)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _setTokenName(uint256 tokenId, string memory name) internal {
        _tokenNames[tokenId] = name;
    }

    function _setTokenSymbol(uint256 tokenId, string memory symbol) internal {
        _tokenSymbols[tokenId] = symbol;
    }
}
