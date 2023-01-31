pragma solidity ^0.5.0;

import "./TokenMintERC20Token.sol";

/**

// @title DNG
// @author Digital Natives Group
// @dev Standard ERC20 token with unique features implemented.
// For full specification of ERC-20 standard see:
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// */
// contract DNG is TokenMintERC20Token {
//     uint256 private _mintingDuration;
//     address private _feeReceiver;
//     /**

//     @dev Constructor.
//     @param name name of the token
//     @param symbol symbol of the token, 3-4 chars is recommended
//     @param decimals number of decimal places of one token unit, 18 is widely used
//     @param totalSupply total supply of tokens in lowest units (depending on decimals)
//     @param mintingDuration the time period in seconds for which token minting is allowed
//     @param feeReceiver address to receive the fees from contract deployment
//     @param tokenOwnerAddress address that gets 100% of token supply
//     */
//     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, uint256 mintingDuration, address payable feeReceiver, address tokenOwnerAddress) public payable
//     TokenMintERC20Token(name, symbol, decimals, totalSupply, feeReceiver, tokenOwnerAddress)
//     {
//     _mintingDuration = mintingDuration;
//     _feeReceiver = feeReceiver;
//     }
//     /**

//     @dev Function to mint new tokens.
//     @param to The address that will receive the new tokens.
//     @param value The amount of tokens to be minted in lowest units (depending on decimals).
//     */
//     function mint(address payable to, uint256 value) public {
//     require(now <= _mintingDuration, "Minting duration has passed");
//     _mint(to, value);
//     }
//     /**

//     @dev Function to update the minting duration.
//     @param newDuration The new time period in seconds for which token minting is allowed.
//     */
//     function updateMintingDuration(uint256 newDuration) public {
//     require(msg.sender == _feeReceiver, "Only the fee receiver can update the minting duration");
//     _mintingDuration = newDuration;
//     }
//     /**

//     @dev Function to get the current minting duration.
//     @return The current time period in seconds for which token minting is allowed.
//     */
//     function getMintingDuration() public view returns (uint256) {
//     return _mintingDuration;
//     }
//     }


contract DNG is TokenMintERC20Token {
    uint256 public constant MIN_STAKE = 1000000000000000000;
    uint256 public constant UNSTAKE_DELAY = 604800;
    uint256 public constant TOTAL_SUPPLY = 100000000000000000;

    address public stakingContract;
    mapping(address => uint256) public stakeAmounts;
    mapping(address => uint256) public lastUnstakeTime;

    /**
    * @dev Constructor.
    * @param stakingContractAddress address of the staking contract
    */
    constructor(string memory name, string memory symbol, uint8 decimals, address payable feeReceiver, address tokenOwnerAddress, address stakingContractAddress) 
    public payable
    TokenMintERC20Token(name, symbol, decimals, TOTAL_SUPPLY, feeReceiver, tokenOwnerAddress)
    {
        stakingContract = stakingContractAddress;
    }

    /**
    * @dev Stakes a specific amount of tokens.
    * @param value The amount of lowest token units to be staked.
    */
    function stake(uint256 value) public {
        require(value >= MIN_STAKE, "Minimum stake amount is not met");
        require(stakeAmounts[msg.sender] + value <= _balanceOf(msg.sender), "Not enough tokens to stake");

        stakeAmounts[msg.sender] += value;
        _transfer(msg.sender, stakingContract, value);
    }

    /**
    * @dev Unstakes a specific amount of tokens.
    * @param value The amount of lowest token units to be unstaked.
    */
    function unstake(uint256 value) public {
        require(stakeAmounts[msg.sender] >= value, "Not enough tokens staked");
        require(now >= lastUnstakeTime[msg.sender] + UNSTAKE_DELAY, "Unstake delay has not passed yet");

        stakeAmounts[msg.sender] -= value;
        lastUnstakeTime[msg.sender] = now;
        _transfer(stakingContract, msg.sender, value);                  
    }
}


contract DNG is TokenMintERC20Token {
    address private _dngTokenFeeReceiver;

    /**
    * @dev Constructor.
    * @param name name of the token
    * @param symbol symbol of the token, 3-4 chars is recommended
    * @param decimals number of decimal places of one token unit, 18 is widely used
    * @param totalSupply total supply of tokens in lowest units (depending on decimals)
    * @param tokenOwnerAddress address that gets 100% of token supply
    */
    constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address dngTokenFeeReceiver, address tokenOwnerAddress) public payable
        TokenMintERC20Token(name, symbol, decimals, totalSupply, dngTokenFeeReceiver, tokenOwnerAddress)
    {
        _dngTokenFeeReceiver = dngTokenFeeReceiver;
    }

    /**
    * @dev Burns a specific amount of tokens.
    * @param value The amount of lowest token units to be burned.
    */
    function burn(uint256 value) public {
        require(value > 0, "Value must be positive");
        _burn(msg.sender, value);
    }

    /**
    * @dev Sends token fee to the fee receiver address.
    */
    function sendTokenFee() public {
        _dngTokenFeeReceiver.transfer(msg.value);
    }
}

