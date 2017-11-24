pragma solidity ^0.4.18;


import "./PausableToken.sol";



/**
 * @title GODToken
 * @dev GOD Token contract
 */
contract DATToken is PausableToken {
  using SafeMath for uint256;

  string public name = "DAT Token";
  string public symbol = "DAT";
  uint public decimals = 18;


  uint256 private constant INITIAL_SUPPLY = 3000000000 ether;


  /**
   * @dev Contructor that gives msg.sender all of existing tokens. 
   */
  function DATToken() public {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }

  function changeSymbolName(string symbolName) onlyOwner public
  {
      symbol = symbolName;
  }

   function changeName(string symbolName) onlyOwner public
  {
      name = symbolName;
  }
}