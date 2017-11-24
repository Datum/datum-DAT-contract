pragma solidity ^0.4.18;

import "./token/DATToken.sol";

/**
 * @title StorageContract
 * @dev contract for handling storage process
 */
contract TradeContract is Ownable {
    DATToken public token;

    mapping(bytes32  => DataRequestItem) dataRequests;


     /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  event DataRequest(bytes32 key, address requester, string dataType, string publicKey, uint amount, bool instant);


       /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  event DataOffer(bytes32 key, address owner, string dataHash);


         /**
  * @notice Log an event for each funding contributed converted to earned tokens
  * @notice Events are not logged when the constructor is being executed during
  *         deployment, so the preallocations will not be logged
  */
  //event PayData(bytes32 key, address owner, address newOwner,uint256 amount);

  event PayData(address owner, address newOwner,uint amount, string  dataHash);



  function TradeContract(DATToken _token) public
  {
      token = _token;
  }

    struct DataRequestItem
    {
       string dataType;
       string publicKey;
       address wallet;
       string dataHash;
       uint256 amount;
       address owner;
       bool instant;
    }

    function addDataRequest(string dataType, string publicKey, uint256 amount) public returns (bytes32)
    {
        DataRequestItem memory req = DataRequestItem(dataType, publicKey, msg.sender,"",amount,0x0, false);
        var id = keccak256(req);
        dataRequests[id] = req;

        DataRequest(id, msg.sender, dataType, publicKey, amount, false);

        return id;
    }

    function addInstantDataRequest(string dataType, string publicKey, uint256 amount) public returns (bytes32)
    {
        DataRequestItem memory req = DataRequestItem(dataType, publicKey, msg.sender,"",amount,0x0,true);
        var id = keccak256(req);
        dataRequests[id] = req;

        token.approve(this, amount);
        token.transferFrom(msg.sender, this, amount);

        DataRequest(id, msg.sender, dataType, publicKey, amount, true);
    }

    function offerData(bytes32 key, string dataHash) public
    {
        dataRequests[key].dataHash = dataHash;
        dataRequests[key].owner = msg.sender;

        DataOffer(key, msg.sender, dataHash);

        //Check if instant payment
        if(dataRequests[key].instant == true)
        {
            token.transfer(msg.sender, dataRequests[key].amount);
            PayData(dataRequests[key].owner, msg.sender, dataRequests[key].amount, dataHash);
        }
    }

    function offerDataOffChain(bytes32 key, string dataHash, address beneficiary) public onlyOwner
    {
        dataRequests[key].dataHash = dataHash;
        dataRequests[key].owner = beneficiary;

        DataOffer(key, beneficiary, dataHash);

        //Check if instant payment
        if(dataRequests[key].instant == true)
        {
            token.transfer(beneficiary, dataRequests[key].amount);
            PayData(dataRequests[key].owner, beneficiary, dataRequests[key].amount, dataHash);
        }
    }


    function payData(bytes32 key, string dataHash) public
    {
        require(token.allowance(msg.sender, dataRequests[key].owner) >= dataRequests[key].amount);

        token.transferFrom(msg.sender, dataRequests[key].owner, dataRequests[key].amount);

        PayData(dataRequests[key].owner, msg.sender, dataRequests[key].amount, dataHash);
    }

    function payDataOffChain(string dataHash, address beneficiary, uint amount) public onlyOwner
    {
        require(token.allowance(msg.sender, beneficiary) >= amount);

        token.transferFrom(msg.sender, beneficiary, amount);

        PayData(beneficiary, msg.sender, amount, dataHash);
    }
  
    function () payable public {
        require(msg.value == 0);
    } 
}