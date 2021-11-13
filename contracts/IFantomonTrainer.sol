pragma solidity ^0.8.7;

import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";

interface IFantomonTrainer2 is IERC721Enumerable{

    /**************************************************************************
     * Stats and attributes for all trainers
     **************************************************************************/
    function getKinship(uint256 _tokenId) external view returns (uint256);
    function getFlare(uint256 _tokenId) external view returns (uint256);
    function getCourage(uint256 _tokenId) external view returns (uint256);
    function getWins(uint256 _tokenId) external view returns (uint256);
    function getLosses(uint256 _tokenId) external view returns (uint256);
    /* Stats and attributes for all trainers
     **************************************************************************/

    /**************************************************************************
     * Getters
     **************************************************************************/
    function getStatus(uint256 _tokenId) external view returns (uint8);
    function getRarity(uint256 _tokenId) external view returns (uint8);
    function getClass(uint256 _tokenId) external view returns (uint8);
    function getFace(uint256 _tokenId) external view returns (uint8);
    function getHomeworld(uint256 _tokenId) external view returns (uint8);
    function getTrainerName(uint256 _tokenId) external view returns (string memory);
    function getHealing(uint256 _tokenId) external view returns (uint256);
    /* End getters
     **************************************************************************/

    function pet(uint256 _trainer, uint256 _fantomon, address _fantomonContract) external;
    function play(uint256 _trainer, uint256 _fantomon, address _fantomonContract) external;
    function sing(uint256 _trainer, uint256 _fantomon, address _fantomonContract) external;
    function enterArena(uint256 _tokenId, address _arena, uint256[] calldata _args) external;
    function enterHealingRift(uint256 _tokenId, address _rifts, uint256[] calldata _args) external;
    function enterJourney(uint256 _tokenId, address _journey, uint256[] calldata _args) external;


//    function _enterBattle(uint256 _tokenId) external;
//    function _leaveArena(uint256 _tokenId, bool _won) external;
//    function _leaveHealingRift(uint256 _tokenId) external;
    function _leaveJourney(uint256 _tokenId) external;
    function _leave(uint256 _tokenId) external;


}