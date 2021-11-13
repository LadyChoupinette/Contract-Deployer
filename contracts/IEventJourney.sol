pragma solidity ^0.8.7;

interface IEventJourney {
//    constructor(address adr, uint16 chances) external;
//    address tokenOwner;
//    uint16 chances;

    function _process(uint256 _tokenId, uint256[] calldata _args) external returns (bool, string calldata);
}