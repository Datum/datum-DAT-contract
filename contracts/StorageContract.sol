pragma solidity ^0.4.18;

import "./token/DATToken.sol";

/**
 * @title StorageContract
 * @dev contract for handling storage process
 */
contract StorageContract is Ownable {
    DATToken public token;

    mapping(bytes32  => StorageItem) storageRequests;


    /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  event StorageRequest(bytes32 key, uint value, uint durance);


    /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  event StorageFound(bytes32 key, address storageNode);

      /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  event StorageDeposited(bytes32 key, address payer, uint256 amount);

     /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  event StorageDepositReleased(bytes32 key, address receiver, uint256 amount);


  function StorageContract(DATToken _token) public
  {
      token = _token;
  }

    struct StorageItem
    {
        address owner;
        address storageNode;
        uint timestamp;
        uint amount;
        uint durance;
        uint256 deposited;
    }

  //add new storage request to network
  function addStorageRequest(uint amount, uint durance) public returns (bytes32)
  {
      //create storage item and publish to requests
      StorageItem memory req = StorageItem(msg.sender, 0x0, block.timestamp, amount, durance,0);

      //create unique id
      var id = keccak256(req);
      storageRequests[id] = req;

      //fire event
      StorageRequest(id, amount,durance);

      //return id
      return id;
  }

  //offer storagespace for given key
  function offerStorageSpace(bytes32 key) public
  {
      //set storageNode for given storageItem
      storageRequests[key].storageNode = msg.sender;

      //fire event to blockchain
      StorageFound(key, msg.sender);
  }

  //deposit DAT for the storageItem with given id
  //ATTENTION: allowance for custom token transfer must be already called by token owner
  //validations: - token allowance is there for transfer to contract
  function depositStorageCost(bytes32 key) public
  {
      //check if allowance for this address exists
      require(token.allowance(msg.sender, this) > 0);

      //get amount allowed
      uint tokenAmount = token.allowance(msg.sender, this);

      //transfer tokens to the contract
      token.transferFrom(msg.sender, this, tokenAmount);

      //save to struct object the payed amount
      storageRequests[key].deposited = tokenAmount;

      //fire event to blockchain
      StorageDeposited(key, msg.sender, tokenAmount);
  }

  //release storage funds to storageNode
  //can by only called by storage nodes
  //validations: - msg.sender == storageNode for this key
  //             - durance of storage contract fullfilled 
  function releaseStorageFunds(bytes32 key) public
  {
      //check that the caller is the storageNode for this key
      require(storageRequests[key].storageNode  == msg.sender);

      //check if the durance for this storageItem is fullfilled
      require(block.timestamp >= storageRequests[key].timestamp);

      //transfer tokens from contract to storageNode
      token.transfer(msg.sender, storageRequests[key].deposited);

      //fire event to blockchain
      StorageDepositReleased(key, storageRequests[key].storageNode, storageRequests[key].deposited);
  }

  // emergency transfer method
  // can by called only by owner in emegency case
  function emergencyTransfer(address receiver, uint256 amount) onlyOwner public
  {
      //transfer amount to given receiver
      token.transfer(receiver, amount);
  }

  //disable direct transfers to contract
  function () payable public {
      require(msg.value == 0);
  } 
}