//pragma solidity ^0.8.7;
//
//import "./IEventJourney.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "./IFantomonLocation.sol";
//import "./IFantomonTrainer.sol";
//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//
//contract SendArmyV2 is IFantomonLocation, Ownable{
//
//    address private FTA = 0x4F46C9D58c9736fe0f0DB5494Cf285E995c17397;
//    address private _entgunk = 0x19840d508904587E08f262F518dA078bd4c560bf;
//    address private _journeyAddress = 0xe1247d9C99bCbF6441A1A7420fAc0E472a9ACfBd;
//    address private _healingRiftAddress = 0x078937eBfe4b994162520de713AeA3541e38420A;
//
//    uint8 constant private RESTING   = 0;
//    uint8 constant private PREPARING = 1;
//    uint8 constant private BATTLING  = 2;
//    uint8 constant private HEALING   = 3;
//    uint8 constant private LOST      = 4;
//
//    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
//
//    // Mapping from token ID to enlisted owner address
//    mapping(uint256 => address) private _tokenOwner;
//
//    // Mapping enlisted owner address to token count
//    mapping(address => uint256) private _enlistedBalance;
//
//    // Mapping from owner to list of owned token IDs
//    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
//    // Mapping from token ID to index of the owner tokens list
//    mapping(uint256 => uint256) private _ownedTokensIndex;
//
//    IFantomonTrainer trainers = IFantomonTrainer(FTA);
//    IERC20 rewardToken = IERC20(_entgunk);
//
//    function onERC721Received(address,address,uint256,bytes calldata) external returns(bytes4){
//        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
//    }
//
//
//
//    /**
//    * @dev Called with the tokenId of a trainer to enter that trainer into a new location
//     * @param _tokenId - the trainer ID entering this location
//     * @param _args    - miscellaneous other arguments (placeholder to be interpreted by location contracts)
//     */
//    function enter(uint256 _tokenId, uint256[] calldata _args) override external{
//
//    }
//
//    /**
//     * @dev Called with the tokenId of a trainer to flee from a location
//     * @param _tokenId - the trainer ID being entered into arena
//     */
//    function flee(uint256 _tokenId) override external{
//
//    }
//    function saveTokenInfo(address _ownerAddress, uint256 _tokenId) private{
//        uint256 tokenIndex=_enlistedBalance[_ownerAddress];
//        _tokenOwner[_tokenId]=_ownerAddress;
//        _ownedTokens[_ownerAddress][tokenIndex]=_tokenId;
//        _enlistedBalance[_ownerAddress]+=1;
//        _ownedTokensIndex[_tokenId]=tokenIndex;
//    }
//
//    function enlistTrainers(uint256[] memory _tokenIdList) public {
//        require (isApproved(msg.sender),"Please get approvalForAll");
//        require (balanceOnMain(msg.sender)>0,"You don't own any token");
//        for (uint i=0; i < _tokenIdList.length; i++){
//            require (msg.sender==ownerOf(_tokenIdList[i]));
//            saveTokenInfo(msg.sender,_tokenIdList[i]);
//            trainers.safeTransferFrom(msg.sender,address(this),_tokenIdList[i]);
//        }
//    }
//    function removeTokenInfo(address _ownerAddress, uint256 tokenId) private Authorized(){
//        require (_enlistedBalance[_ownerAddress]>0,"Owner does not have any token");
//        delete _tokenOwner[tokenId];
//        _removeTokenFromOwnerEnumeration(_ownerAddress,tokenId);
//        _enlistedBalance[_ownerAddress]-=1;
//    }
//    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
//        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
//        // then delete the last slot (swap and pop).
//
//        uint256 lastTokenIndex = _enlistedBalance[from] - 1;
//        uint256 tokenIndex = _ownedTokensIndex[tokenId];
//
//        // When the token to delete is the last token, the swap operation is unnecessary
//        if (tokenIndex != lastTokenIndex) {
//            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
//
//            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
//            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
//        }
//
//        // This also deletes the contents at the last position of the array
//        delete _ownedTokensIndex[tokenId];
//        delete _ownedTokens[from][lastTokenIndex];
//    }
//
//    function delistTrainers(uint256[] memory _tokenIdList) public Authorized{
//        uint256 bal = _enlistedBalance[msg.sender];
//        require (bal>0,"You don't have any trainer enlisted");
//        for (uint i=0; i < _tokenIdList.length; i++){
//            require (msg.sender==_tokenOwner[_tokenIdList[i]]);
//            removeTokenInfo(msg.sender,_tokenIdList[i]);
//            trainers.safeTransferFrom(address(this),msg.sender,_tokenIdList[i]);
//        }
//    }
//
//    function enterJourney(uint256[] memory _tokenIdList) public Authorized{
//        uint256 len = _tokenIdList.length;
//        bool hasAny = false;
//        for (uint i=0; i <len ; i++){
//            uint256 _tokenId = _tokenIdList[i];
//            require(msg.sender==_tokenOwner[_tokenId]||msg.sender==address(this),"You do not own one of the tokens");
//            if (trainers.getStatus(_tokenId)==RESTING){
//                trainers.enterJourney(_tokenId,_journeyAddress,new uint256[](0));
//                hasAny = true;
//            }
//        }
//        require(hasAny==true,"No trainer is resting or already went on journey in the last 12hrs");
//    }
//    function leaveJourney(uint256[] memory _tokenIdList) public Authorized{
//        uint256 len = _tokenIdList.length;
//        bool hasAny = false;
//        for (uint i=0; i <len ; i++){
//            uint256 _tokenId = _tokenIdList[i];
//            require(msg.sender==_tokenOwner[_tokenId]||msg.sender==address(this),"You do not own one of the tokens");
//            if (trainers.getStatus(_tokenId)==LOST){
//                trainers._leaveJourney(_tokenId);
//                hasAny=true;
//            }
//        }
//        require(hasAny==true,"No trainer is on journey");
//    }
//
//    function journeyFarming() external{
//        uint256[] memory tokenIds = ownedTokensOnMain();
//        enlistTrainers(tokenIds);
//        enterJourney(tokenIds);
//        leaveJourney(tokenIds);
//        delistTrainers(tokenIds);
//    }
//
//    function enterHealingRift(uint256[] memory _tokenIdList) public Authorized{
//        uint256 len = _tokenIdList.length;
//        bool hasAny = false;
//        for (uint i=0; i <len ; i++){
//            uint256 _tokenId = _tokenIdList[i];
//            require(msg.sender==_tokenOwner[_tokenId]||msg.sender==address(this),"You do not own one of the tokens");
//            if (trainers.getStatus(_tokenId)==RESTING){
//                trainers.enterHealingRift(_tokenId,_healingRiftAddress,new uint256[](0));
//                hasAny=true;
//            }
//        }
//        require(hasAny==true,"No trainer is resting");
//    }
//    function deployAll2HealingRift() external{
//        uint256[] memory tokenIds = ownedTokensOnMain();
//        enlistTrainers(tokenIds);
//        enterHealingRift(tokenIds);
//        delistTrainers(tokenIds);
//    }
//    //getters n setters
//    function setJourney(address journey) external onlyOwner{
//        _journeyAddress = journey;
//        //_journeyId[journey]=_Journeys.length-1;
//    }
//    function getJourney() public view returns(address){
//        return _journeyAddress;
//    }
//    function setHealingRift(address rift) external onlyOwner{
//        _healingRiftAddress = rift;
//        //_healingRiftId[rift]=_healingRifts.length-1;
//    }
//    function getHealingRift() public view returns(address){
//        return _healingRiftAddress;
//    }
//
//    //helpers
//    function balanceOnMain(address _address) public view returns (uint256){
//        return trainers.balanceOf(_address);
//    }
//    function ownerOf(uint256 _tokenId) public returns (address) {
//        return trainers.ownerOf(_tokenId);
//    }
//    function ownedTokens(address ownerAddr) public view returns(uint256[] memory){
//        uint256 bal = _enlistedBalance[msg.sender];
//        if(bal>0){
//            uint256[] memory tokens = new uint256[](bal);
//            for (uint i=0; i<bal;i++){
//                tokens[i]=_ownedTokens[ownerAddr][i];
//            }
//            return tokens;
//        }
//    }
//    function ownedTokensOnMain() public view returns(uint256[] memory){
//        uint256 bal = balanceOnMain(msg.sender);
//        if(bal>0){
//
//            uint256[] memory ownedTokensM = new uint256[](bal);
//            for (uint i=0; i<bal;i++){
//                ownedTokensM[i]=trainers.tokenOfOwnerByIndex(msg.sender,i);
//            }
//            return ownedTokensM;
//        }
//
//    }
//    function isApproved(address _sender) public view virtual returns (bool){
//        return trainers.isApprovedForAll(_sender,address(this));
//    }
//    function isEnlisted(address _address) public view returns (bool){
//        return _enlistedBalance[_address]>0;
//    }
//    modifier Authorized(){
//        require(msg.sender==owner()||isEnlisted(msg.sender));
//        _;
//    }
//
//
//    /**************************************************************************
//    * Payments
//    **************************************************************************/
//    function donation () external payable{
//    }
//    function withdraw() external onlyOwner(){
//        address payable addr = payable(owner());
//        addr.transfer(address(this).balance);
//    }
//    /* End payments
//     **************************************************************************/
//
//}
