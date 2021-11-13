pragma solidity ^0.8.7;

/**
 * @dev Interface for a Fantomon Location contract
 */
interface IFantomon {
    /**
     * @dev Called with the tokenId of a trainer and its fantomon to interact with that fantomon
     * @param _trainer  - the trainer ID interacting
     * @param _fantomon - the fantomon ID being interacted with
     * @param _args     - miscellaneous other arguments (placeholder to be interpreted by Fantomon contracts)
     * Note: msg.sender here should be the FantomonTrainer contract to which _trainer belongs
     */
    function interact(uint256 _trainer, uint256 _fantomon, uint256[] calldata _args) external;
}
