// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";
import "./PlayersDNA.sol";

contract PlayersCollectibles is
    ERC721,
    ERC721URIStorage,
    ERC721Enumerable,
    PlayersDNA
{
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("PlayersCollectibles", "PLYCS") {
        maxSupply = _maxSupply;
    }

    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No PlayersCollectibles left :(");

        uint256 _dna = deterministicPseudoRandomDNA(current, msg.sender);
        tokenDNA[current] = _dna;
        _safeMint(msg.sender, current);

        // set metadata 
        string memory params;

        params = string(
            abi.encodePacked(
                "raw/upload/neofutbol/",
                getCountry(_dna),
                "/",
                getCategory(_dna),
                "/",
                getPlayerNumber(_dna).toString(),
                ".json"
            )
        );
        _setTokenURI(current, params);
        _idCounter.increment();
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://res.cloudinary.com/sagarciaescobar/";
    }

    function _paramsURI(uint256 _dna) internal view returns (string memory) {
        string memory params;

        params = string(
            abi.encodePacked(
                "image/upload/neofutbol/",
                getCountry(_dna),
                "/",
                getCategory(_dna),
                "/",
                getPlayerNumber(_dna).toString(),
                ".png"
            )
        );

        return params;
    }

    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, paramsURI));
    }

    function metadataByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, paramsURI));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "id": "',
                tokenId.toString(),
                '", "name": "PlayersDNA #',
                tokenId.toString(),
                '", "description": "Football player from ',
                getCountry(dna),
                '", "image": "',
                image,
                '","metadata":"',
                super.tokenURI(tokenId),
                '"}'
            )
        );

        return
            string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}
