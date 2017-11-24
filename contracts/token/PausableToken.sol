pragma solidity ^0.4.18;


import "./StandardToken.sol";
import "../shared/Pausable.sol";

/**
 * Pausable token
 *
 * Simple ERC20 Token example, with pausable token transfer
 **/

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint _value) whenNotPaused public {
    super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint _value) whenNotPaused public {
    super.transferFrom(_from, _to, _value);
  }
}