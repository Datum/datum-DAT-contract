pragma solidity ^0.4.18;


import "./Ownable.sol";


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Unpause();

  bool public paused = true;


  /**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
      require(!paused);
    _;
  }

  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused {
      require(paused);
    _;
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public returns (bool) {
    paused = false;
    Unpause();
    return true;
  }

    /**
   * @dev called by the owner to pause, returns to paused state
   */
  function pause() onlyOwner whenNotPaused public returns (bool) {
    paused = true;
    return false;
  }
}