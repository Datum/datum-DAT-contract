pragma solidity ^0.4.18;


import "./token/DATToken.sol";


contract DatumTokenDistributor is Ownable {
  DATToken public token;
  
  function DatumTokenDistributor(DATToken _token) public
  {
    //token = createTokenContract();
    token = _token;
  }

  function distributeToken(address[] addresses, uint256[] amounts) onlyOwner public {
     require(addresses.length == amounts.length);
     for (uint i = 0; i < addresses.length; i++) {
         token.transfer(addresses[i], amounts[i]);
     }
  }

  // creates the token to be distributed.
  function createTokenContract() internal returns (DATToken) {
    return new DATToken();
  }

  function setTokenSymbolName(string symbol) onlyOwner public
  {
    token.changeSymbolName(symbol);
  }

  function setTokenName(string name) onlyOwner public
  {
    token.changeName(name);
  }

  function releaseToken() onlyOwner public
  {
    token.unpause();
  }
}
