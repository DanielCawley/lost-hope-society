// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error LostHopeSocietyNft__ContentAlreadyOwned();
error LostHopeSocietyNft__YouBetterPayUpMore();
error LostHopeSocietyNft__Only1000NftsInThisCollection();
error LostHopeSocietyNft__SenderAlreadyWhitelisted();
error LostHopeSocietyNft__WhitelistLimitExceeded();
error LostHopeSocietyNft__YouMustBeWhitelisted();

contract LostHopeSocietyNft is ERC721URIStorage, Ownable {
    // immutable saves on gas cost
    uint256 public immutable maxNumberOfWhitelistedAddresses;
    uint256 public immutable whitelistEndTime;
    uint256 public immutable floorPrice;
    uint256 public tokenCounter;
    uint256 public numberOfAddressesWhitelisted;

    mapping(string => uint8) public existingURIs;
    mapping(address => bool) public whitelistedAddresses;

    constructor(
        uint256 _maxNumberOfWhitelistedAddresses,
        uint256 _whitelistTimePeriod,
        uint256 _floorPrice
    ) public ERC721("LostHopeSocietyNft", "LHS") {
        tokenCounter = 0;
        maxNumberOfWhitelistedAddresses = _maxNumberOfWhitelistedAddresses;
        whitelistEndTime = _whitelistTimePeriod + block.timestamp;
        floorPrice = _floorPrice;
    }

    function addUserToWhitelist(address _addressToWhiteList) public onlyOwner {
        if (!whitelistedAddresses[_addressToWhiteList]) {
            revert LostHopeSocietyNft__SenderAlreadyWhitelisted();
        }
        if (numberOfAddressesWhitelisted > maxNumberOfWhitelistedAddresses) {
            revert LostHopeSocietyNft__WhitelistLimitExceeded();
        }
        whitelistedAddresses[_addressToWhiteList] = true;
        numberOfAddressesWhitelisted++;
    }

    function mint(string memory _tokenURI) public payable {
        if (
            block.timestamp > whitelistEndTime &&
            !_isUserWhitelisted(msg.sender) &&
            tokenCounter > 250
        ) {
            revert LostHopeSocietyNft__YouMustBeWhitelisted();
        }
        if (tokenCounter >= 1000) {
            revert LostHopeSocietyNft__Only1000NftsInThisCollection();
        }
        if (existingURIs[_tokenURI] == 1) {
            revert LostHopeSocietyNft__ContentAlreadyOwned();
        }
        if (msg.value >= floorPrice) {
            revert LostHopeSocietyNft__YouBetterPayUpMore();
        }
        uint256 newTokenId = tokenCounter;
        //safeMint was inherited already
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        existingURIs[_tokenURI] = 1;
        tokenCounter += 1;
    }

    function withdrawAllFunds() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function _isUserWhitelisted(address _whitelistedAddress)
        internal
        view
        returns (bool)
    {
        return whitelistedAddresses[_whitelistedAddress];
    }

    function isContentOwned(string memory _uri) public view returns (bool) {
        return existingURIs[_uri] == 1;
    }

    function returnTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }
}
