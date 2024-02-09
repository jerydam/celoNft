`MyNft` is an ERC721 token contract implemented in Solidity. It inherits various features from OpenZeppelin's ERC721 implementation and its extensions, providing functionalities such as minting, pausing, burning, and voting.

## Contract Dependencies

- ERC721: [OpenZeppelin ERC721 Documentation](https://docs.openzeppelin.com/contracts/3.x/token_erc721)
- ERC721Enumerable: [OpenZeppelin ERC721Enumerable Documentation](https://docs.openzeppelin.com/contracts/3.x/token_erc721_enumerable)
- ERC721URIStorage: [OpenZeppelin ERC721URIStorage Documentation](https://docs.openzeppelin.com/contracts/3.x/token_erc721_uri)
- ERC721Pausable: [OpenZeppelin ERC721Pausable Documentation](https://docs.openzeppelin.com/contracts/3.x/token_erc721_pausable)
- Ownable: [OpenZeppelin Ownable Documentation](https://docs.openzeppelin.com/contracts/3.x/access-control#ownable)
- ERC721Burnable: [OpenZeppelin ERC721Burnable Documentation](https://docs.openzeppelin.com/contracts/3.x/token_erc721_burnable)
- EIP712: [OpenZeppelin EIP712 Documentation](https://docs.openzeppelin.com/contracts/3.x/utils-cryptography#eip712)
- ERC721Votes: [OpenZeppelin ERC721Votes Documentation](https://docs.openzeppelin.com/contracts/4.x/erc721#votes)

_nextTokenId: Private variable to keep track of the next token ID to be minted.
_mintedSuccessfully: Mapping to track addresses that have successfully minted tokens.
Constructor
Initializes the contract with the given initialOwner address and sets up ERC721, Ownable, and EIP712 configurations.
Pausing/Unpausing
pause(): Function to pause the contract, accessible only by the owner.
unpause(): Function to unpause the contract, accessible only by the owner.
Minting
safeMint(address to, string memory uri): Function to safely mint a new token for the specified address (to). It generates a new token ID, mints the token, sets its URI, and marks the address as successfully minted.
Checking Minting Status
hasMintedSuccessfully(address account): Function to check if a specific address has successfully minted a token.
getAllMintedSuccessfully(): Function to get an array of addresses that have successfully minted tokens.
Overrides
_update(), _increaseBalance(), tokenURI(), supportsInterface(): Functions required to be overridden due to the contract inheriting from various ERC721-related contracts.
This contract provides a comprehensive ERC721 implementation with additional features for pausing, burning, and tracking successful minting. It's designed to be flexible and compatible with various use cases in the NFT space.