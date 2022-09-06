// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract PlayersDNA {
    string[] private _country = ["argentina", "brasil", "chile", "uruguay"];

    string[] private _category = ["default", "heroes", "legendary"];

    // This pseudo random function is determistic and should not be used on production
    function deterministicPseudoRandomDNA(uint256 _tokenId, address _minter)
        public
        pure
        returns (uint256)
    {
        uint256 combinedParams = _tokenId + uint160(_minter);
        bytes memory encodedParams = abi.encodePacked(combinedParams);
        bytes32 hashedParams = keccak256(encodedParams);

        return uint256(hashedParams);
    }

    // Get attributes
    uint8 constant ADN_SECTION_SIZE = 2;

    function _getDNASection(uint256 _dna, uint8 _rightDiscard)
        internal
        pure
        returns (uint8)
    {
        return
            uint8(
                (_dna % (1 * 10**(_rightDiscard + ADN_SECTION_SIZE))) /
                    (1 * 10**_rightDiscard)
            );
    }

    function getCountry(uint256 _dna) public view returns (string memory) {
        uint8 dnaSection = _getDNASection(_dna, 0);
        return _country[dnaSection % _country.length];
    }

    function getCategory(uint256 _dna) public view returns (string memory) {
        uint8 dnaSection = _getDNASection(_dna, 2);
        return _category[dnaSection % _category.length];
    }

    function getPlayerNumber(uint256 _dna) public view returns (uint256) {
        uint256 dnaSection = _getDNASection(_dna, 4);
        uint256 divisor;
        if (
            keccak256(abi.encodePacked(getCountry(_dna))) ==
            keccak256(abi.encodePacked("argentina"))
        ) {
            if (
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("default")) ||
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("heroes"))
            ) {
                divisor = 30;
            } else {
                divisor = 4;
            }
        } else if (
            keccak256(abi.encodePacked(getCountry(_dna))) ==
            keccak256(abi.encodePacked("brasil"))
        ) {
            if (
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("default")) ||
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("heroes"))
            ) {
                divisor = 26;
            } else {
                divisor = 4;
            }
        } else if (
            keccak256(abi.encodePacked(getCountry(_dna))) ==
            keccak256(abi.encodePacked("chile"))
        ) {
            if (
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("default")) ||
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("heroes"))
            ) {
                divisor = 21;
            } else {
                divisor = 4;
            }
        } else {
            if (
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("default")) ||
                keccak256(abi.encodePacked(getCategory(_dna))) ==
                keccak256(abi.encodePacked("heroes"))
            ) {
                divisor = 24;
            } else {
                divisor = 4;
            }
        }
        return (dnaSection % divisor) + 1;
    }
}
