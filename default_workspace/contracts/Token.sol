// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./DarkPool.sol";
import "./DNGToken.sol";

contract Token {

    string public constant name = "DNG Token";
    string public constant symbol = "DNG";
    uint256 public constant decimals = 18;
    uint256 public totalSupply = 10000;


    // Mapping to store balance of each address
    mapping(address => uint256) public balanceOf;

    // Mapping to store the allowed transfer of tokens between two addresses
    mapping (address => mapping (address => uint256)) public allowed;

    // Event for tokens approved
    event TokensApproved(
        address spender,
        uint256 value
    );

    // Event for tokens transferred
    event TokensTransferred(
        address from,
        address to,
        uint256 value
    );

    DarkPool public dPool;
    DNGToken public tokenFun;

    function transfer(address to, uint256 value) public {
        require(balanceOf[msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer failed.");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
    }
    
    function approve(address spender, uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Approval failed.");
        allowed[msg.sender][spender] = value;
    }
    
    function transferFrom(address from, address to, uint256 value) public {
        require(balanceOf[from] >= value && allowed[from][msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer from failed.");
        balanceOf[from] -= value;
        allowed[from][msg.sender] -= value;
        balanceOf[to] += value;
    }

}
