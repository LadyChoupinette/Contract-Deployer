pragma solidity ^0.8.7;

import "./IEventJourney.sol";
import "./FantomonTrainerGraphics.sol";
import "./IFantomonLocation.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IFantomonTrainer.sol";
import "hardhat/console.sol";

contract Journey is IFantomonLocation, ReentrancyGuard, Ownable {

    bool private paused;
    address private FTA;
    address private _entgunk = 0x19840d508904587E08f262F518dA078bd4c560bf;
    //    address private _journeyAddress = 0xe1247d9C99bCbF6441A1A7420fAc0E472a9ACfBd;
    //    address private _healingRiftAddress = 0x078937eBfe4b994162520de713AeA3541e38420A;

    /**************************************************************************
 * Stats and attributes for all trainers
 **************************************************************************/
    mapping(uint256 => address) public location_;    // per tokenId
    mapping(uint256 => bool)    private named_;       // per tokenId
    mapping(string => bool)     public  nameTaken_;
    mapping(uint256 => string)  private trainerName_; // per tokenId

    mapping(uint256 => uint256) private kinship_;      // per tokenId
    mapping(uint256 => uint256) private flare_;        // per tokenId
    mapping(uint256 => uint256) private timeHealing_;  // per tokenId
    mapping(uint256 => uint256) private courage_;      // per tokenId

    mapping(uint256 => uint256) private wins_;         // per tokenId
    mapping(uint256 => uint256) private losses_;       // per tokenId

    mapping(uint256 => uint256) private timeLastInteraction_;  // per tokenId - what time did you last interact with a Fantomon
    mapping(uint256 => uint256) private timeEnteredRift_;      // per tokenId - what time did you last enter a HealingRift
    mapping(uint256 => uint256) private timeLastJourney_;      // per tokenId - what time did you last journey

    mapping(uint256 => uint8) private status_;      // per tokenId
    mapping(uint256 => uint8) private rarity_;      // per tokenId

    FantomonTrainerGraphics graphics_;

    uint8 constant private RESTING = 0;
    uint8 constant private PREPARING = 1;
    uint8 constant private BATTLING = 2;
    uint8 constant private HEALING = 3;
    uint8 constant private LOST = 4;

    uint8 constant private NUM_TRAINER_CLASSES = 16;
    mapping(uint256 => uint8) private class_;  // per tokenId

    uint8 constant private NUM_TRAINER_FACES = 7;
    mapping(uint256 => uint8) private face_;  // per tokenId

    uint8 constant private NUM_WORLDS = 13;
    mapping(uint256 => uint8) private homeworld_;  // per tokenId
    /* Stats and attributes for all trainers
     **************************************************************************/

    constructor(address adr){
        FTA = adr;
    }

    /**************************************************************************
     * Modifiers
     **************************************************************************/
    modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == ownerOf(_tokenId), "Only owner of that tokenId can do that");
        _;
    }
    modifier onlyCurrentLocation(uint256 _tokenId) {
        require(location_[_tokenId] == msg.sender, "Only this trainer's current location can do this");
        _;
    }
    modifier unpaused() {
        require(paused == false, "Contract is paused");
        _;
    }
    /* End modifiers
     **************************************************************************/

    //    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; //??

    // Mapping from token ID to enlisted owner address
    mapping(uint256 => address) private _tokenOwner;

    // Mapping enlisted owner address to token count
    mapping(address => uint256) private _enlistedBalance;

    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    IFantomonTrainer2 ITrainers = IFantomonTrainer2(FTA);
    IERC20 rewardToken = IERC20(_entgunk);
    IEventJourney[] events;

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    /**
    * @dev Called with the tokenId of a trainer to enter that trainer into a new location
     * @param _tokenId - the trainer ID entering this location
     * @param _args    - miscellaneous other arguments (placeholder to be interpreted by location contracts)
     */
    function enter(uint256 _tokenId, uint256[] calldata _args) override external {
        timeLastJourney_[_tokenId] = block.timestamp;
        console.log("entered");
    }

    /**
     * @dev Called with the tokenId of a trainer to flee from a location
     * @param _tokenId - the trainer ID being entered into arena
     */
    function flee(uint256 _tokenId) override external {
        //        ITrainers.flee(_tokenId);
        status_[_tokenId] = RESTING;
        // resting
        location_[_tokenId] = address(0);
    }

    function saveTokenInfo(address _ownerAddress, uint256 _tokenId) private {
        uint256 tokenIndex = _enlistedBalance[_ownerAddress];
        _tokenOwner[_tokenId] = _ownerAddress;
        _ownedTokens[_ownerAddress][tokenIndex] = _tokenId;
        //        _enlistedBalance[_ownerAddress] += 1;
        _ownedTokensIndex[_tokenId] = tokenIndex;
    }


    //    function batchEnterJourney()

    event testEvent(address txOrigin, address msgSenderAddress, address _from);

    function enterJourney(uint256[] memory _tokenIdList) public Authorized unpaused nonReentrant {
        console.log("enter");

        emit testEvent(tx.origin, msg.sender, address(this));
        uint256 len = _tokenIdList.length;
        bool hasAny = false;
        for (uint i = 0; i < len; i++) {
            console.log("in boucle");
            require(status_[_tokenIdList[i]] == RESTING, "Trainer busy");
            require(block.timestamp > timeLastJourney_[_tokenIdList[i]] + 12 hours, "Can only journey once every 12 hours");
            console.log("ok to go");
            console.log(FTA);
            //console.log(ITrainers.toString());
            console.log(address(this));
            uint256 _tokenId = _tokenIdList[i];
            //            require(msg.sender == _tokenOwner[_tokenId] || msg.sender == address(this), "You do not own one azee the tokens");
            require(isApproved(msg.sender), "Please get approvalForAll");
            address own = IFantomonTrainer2(FTA).ownerOf(_tokenIdList[i]);
            console.log(own);
            require(msg.sender == IFantomonTrainer2(FTA).ownerOf(_tokenIdList[i]), "You do not own one kmjnb the tokens");
            saveTokenInfo(msg.sender, _tokenIdList[i]);
            //            IFantomonTrainer2(FTA).setApprovalForAll(address(this),true);
            IFantomonTrainer2(FTA).safeTransferFrom(msg.sender, address(this), _tokenIdList[i]);
            IFantomonTrainer2(FTA).enterJourney(_tokenIdList[i], address(this), new uint256[](0));

            //            (bool success, bytes memory result) = FTA.call(abi.encodeWithSignature("enterJourney(uint256,address,uint256[])", _tokenId, address(this), new uint256[](0)));
            //            (status, result) = FTA.delegatecall(abi.encodePacked(bytes4(keccak256("enterJourney(uint256,address,uint256[])")), _tokenId, address(this),_tokenIdList));
            //            console.log(success);
            //            console.logBytes(result);

            console.log("done");
            hasAny = true;
        }

        require(hasAny == true, "No trainer is resting or already went on journey in the last 12hrs");
    }

    function leaveJourney(uint256[] memory _tokenIdList) public Authorized {//todo add events, add possibility of trinket
        uint256 len = _tokenIdList.length;
        bool hasAny = false;
        for (uint i = 0; i < len; i++) {
            uint256 _tokenId = _tokenIdList[i];
            //            require(address(this) == _tokenOwner[_tokenId] || msg.sender == address(this), "Youeeee do not own one of the tokens");
            if (IFantomonTrainer2(FTA).getStatus(_tokenId) == LOST) {
                uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _tokenId)));
                bool isSuccessful = randomHash % 2 == 0;
                if (isSuccessful) {
                    IFantomonTrainer2(FTA)._leaveJourney(_tokenId);
                } else {
                    IFantomonTrainer2(FTA)._leave(_tokenId);
                }

                hasAny = true;
            }
        }
        require(hasAny == true, "No trainer is on journey");
    }

    function batchProcessJourney(uint256[] memory _tokenIdList) public unpaused Authorized nonReentrant {
        enterJourney(_tokenIdList);
        leaveJourney(_tokenIdList);

    }

    function _leave(uint256 _tokenId) override public Authorized {}

    function _leaveJourney(uint256 _tokenId) override public Authorized {}
    /*
        function journeyFarming() external{
            uint256[] memory tokenIds = ownedTokensOnMain();
            enlistTrainers(tokenIds);
            enterJourney(tokenIds);
            leaveJourney(tokenIds);
            delistTrainers(tokenIds);
        }
    */
    //getters n setters
    /*    function setJourney(address journey) external onlyOwner{
            _journeyAddress = journey;
            //_journeyId[journey]=_Journeys.length-1;
        }
        function getJourney() public view returns(address){
            return _journeyAddress;
        }*/
    function setPause(bool paused) external onlyOwner {
        paused = paused;
    }

    function getPause() public view returns (bool){
        return paused;
    }

    //helpers
    function balanceOnMain(address _address) public view returns (uint256){
        return ITrainers.balanceOf(_address);
    }

    function ownerOf(uint256 _tokenId) public returns (address) {
        return ITrainers.ownerOf(_tokenId);
    }

    function ownedTokens(address ownerAddr) public view returns (uint256[] memory){
        uint256 bal = _enlistedBalance[msg.sender];
        if (bal > 0) {
            uint256[] memory tokens = new uint256[](bal);
            for (uint i = 0; i < bal; i++) {
                tokens[i] = _ownedTokens[ownerAddr][i];
            }
            return tokens;
        }
    }

    function ownedTokensOnMain() public view returns (uint256[] memory){
        uint256 bal = balanceOnMain(msg.sender);
        if (bal > 0) {

            uint256[] memory ownedTokensM = new uint256[](bal);
            for (uint i = 0; i < bal; i++) {
                ownedTokensM[i] = IFantomonTrainer2(FTA).tokenOfOwnerByIndex(msg.sender, i);
            }
            return ownedTokensM;
        }

    }

    function isApproved(address _sender) public view virtual returns (bool){
        return IFantomonTrainer2(FTA).isApprovedForAll(_sender, address(this));
    }
    //    function isEnlisted(address _address) public view returns (bool){
    //        return _enlistedBalance[_address]>0;
    //    }
    modifier Authorized(){
        require(msg.sender == owner());
        _;
    }


    /**************************************************************************
    * Payments
    **************************************************************************/
    function donation() external payable {
    }

    function withdraw() external onlyOwner() {
        address payable addr = payable(owner());
        addr.transfer(address(this).balance);
    }
    /* End payments
     **************************************************************************/

    /**************************************************************************
     * Helper functions
     **************************************************************************/
    function random(string memory _tag, uint256 _int0) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_tag, toString(_int0), toString(block.timestamp), msg.sender)));
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    /* End helper functions
     **************************************************************************/

    event EventSuccess(address indexed from, address indexed to, uint256 indexed tokenId, string message);
    event Success(address indexed from, address indexed to, uint256 indexed tokenId, string message);
    event Failure(address indexed from, address indexed to, uint256 indexed tokenId, string message);
    event Fleeing(address indexed from, address indexed to, uint256 indexed tokenId, string message);

}
