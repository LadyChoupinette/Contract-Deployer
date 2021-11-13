pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @dev Interface for a Fantomon Location contract
 */
interface IFantomonLocation  {
    /**
     * @dev Called with the tokenId of a trainer to enter that trainer into a new location
     * @param _tokenId - the trainer ID entering this location
     * @param _args    - miscellaneous other arguments (placeholder to be interpreted by location contracts)
     */
    function enter(uint256 _tokenId, uint256[] calldata _args) external;
    /**
     * @dev Called with the tokenId of a trainer to flee from a location
     * @param _tokenId - the trainer ID being entered into arena
     */
    function flee(uint256 _tokenId) external;

    //    function _enterBattle(uint256 _tokenId) external;
    //    function _leaveArena(uint256 _tokenId, bool _won) external;
    //    function _leaveHealingRift(uint256 _tokenId) external;
    function _leaveJourney(uint256 _tokenId) external;
    function _leave(uint256 _tokenId) external;

//    function flee(uint256 _tokenId) external;
//    function emergencyFlee(uint256 _tokenId) external;

}