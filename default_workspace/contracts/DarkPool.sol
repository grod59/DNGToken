// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

import "./AirbnbLike.sol";

contract DarkPool {
    struct Order {
        address trader;
        string symbol;
        uint256 price;
        uint shares;
        address[] symbolAdr;
    }

        // Event for user rating
    struct UserRatedD{
        address userD;
        uint256 ratingD;
    }

    address public decimals;
    uint256 public totalSupply = 10000;
    
    struct UserD {
        uint256 reputationScoreD;
        uint256 numberOfRatingsD;
    }

    AirbnbLike public service;

    IUniswapV2Router02 public router;
    mapping (uint => Order) public orders;
    uint public orderCount;

    constructor (address _router) public {
        router = IUniswapV2Router02(_router);
    }
 
    function addOrder(string memory _symbol, uint256 _price, uint _shares, address[] memory _symbolAdr) public {
        // service.rateUser(decimals, totalSupply); // works
        // service.rateUser(service.balanceOf[tx], _price);/ // does not work return uint256

        orders[orderCount] = Order(msg.sender, _symbol, _price, _shares, _symbolAdr);
        orderCount++;
    }

    function min(uint a, uint b) internal pure returns (uint) {
        return a < b ? a : b;
    }   

    function matchOrders() public {
        for (uint i = 0; i < orderCount; i++) {
            for (uint j = i + 1; j < orderCount; j++) {
                if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
                keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))) {
                    uint amountIn = min(orders[i].shares, orders[j].shares);
                    // Check liquidity
                    (uint[] memory amounts) = router.getAmountsOut(orders[i].shares, orders[i].symbolAdr);
                    (uint[] memory amounts2) = router.getAmountsOut(orders[j].shares, orders[j].symbolAdr);
                   if (amounts[0] < amountIn) {
                        // Liquidity check failed, don't execute the trade
                        continue;
                    }
                   if (amounts2[0] < amountIn) {
                        // Liquidity check failed, don't execute the trade
                        continue;
                    }
                    // Execute the trade
                    orders[i].shares -= amountIn;
                    orders[j].shares -= amountIn;
                    emit Trade(orders[i].trader, orders[j].trader, amountIn, orders[i].symbol, orders[i].price, orders[i].symbolAdr);
                }
            }
        }
    }
    event Trade(address trader1, address trader2, uint amountIn, string symbol, uint256 price, address[] symbolAdr);

}


// pragma solidity >=0.7.0 <0.9.0;

// /** 
//  * @title Ballot
//  * @dev Implements voting process along with vote delegation
//  */
// contract Ballot {

//     struct Voter {
//         uint weight; // weight is accumulated by delegation
//         bool voted;  // if true, that person already voted
//         address delegate; // person delegated to
//         uint vote;   // index of the voted proposal
//     }

//     struct Proposal {
//         // If you can limit the length to a certain number of bytes, 
//         // always use one of bytes1 to bytes32 because they are much cheaper
//         bytes32 name;   // short name (up to 32 bytes)
//         uint voteCount; // number of accumulated votes
//     }

//     address public chairperson;

//     mapping(address => Voter) public voters;

//     Proposal[] public proposals;

//     /** 
//      * @dev Create a new ballot to choose one of 'proposalNames'.
//      * @param proposalNames names of proposals
//      */
//     constructor(bytes32[] memory proposalNames) {
//         chairperson = msg.sender;
//         voters[chairperson].weight = 1;

//         for (uint i = 0; i < proposalNames.length; i++) {
//             // 'Proposal({...})' creates a temporary
//             // Proposal object and 'proposals.push(...)'
//             // appends it to the end of 'proposals'.
//             proposals.push(Proposal({
//                 name: proposalNames[i],
//                 voteCount: 0
//             }));
//         }
//     }

//     /** 
//      * @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
//      * @param voter address of voter
//      */
//     function giveRightToVote(address voter) public {
//         require(
//             msg.sender == chairperson,
//             "Only chairperson can give right to vote."
//         );
//         require(
//             !voters[voter].voted,
//             "The voter already voted."
//         );
//         require(voters[voter].weight == 0);
//         voters[voter].weight = 1;
//     }

//     /**
//      * @dev Delegate your vote to the voter 'to'.
//      * @param to address to which vote is delegated
//      */
//     function delegate(address to) public {
//         Voter storage sender = voters[msg.sender];
//         require(!sender.voted, "You already voted.");
//         require(to != msg.sender, "Self-delegation is disallowed.");

//         while (voters[to].delegate != address(0)) {
//             to = voters[to].delegate;

//             // We found a loop in the delegation, not allowed.
//             require(to != msg.sender, "Found loop in delegation.");
//         }
//         sender.voted = true;
//         sender.delegate = to;
//         Voter storage delegate_ = voters[to];
//         if (delegate_.voted) {
//             // If the delegate already voted,
//             // directly add to the number of votes
//             proposals[delegate_.vote].voteCount += sender.weight;
//         } else {
//             // If the delegate did not vote yet,
//             // add to her weight.
//             delegate_.weight += sender.weight;
//         }
//     }

//     /**
//      * @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.
//      * @param proposal index of proposal in the proposals array
//      */
//     function vote(uint proposal) public {
//         Voter storage sender = voters[msg.sender];
//         require(sender.weight != 0, "Has no right to vote");
//         require(!sender.voted, "Already voted.");
//         sender.voted = true;
//         sender.vote = proposal;

//         // If 'proposal' is out of the range of the array,
//         // this will throw automatically and revert all
//         // changes.
//         proposals[proposal].voteCount += sender.weight;
//     }

//     /** 
//      * @dev Computes the winning proposal taking all previous votes into account.
//      * @return winningProposal_ index of winning proposal in the proposals array
//      */
//     function winningProposal() public view
//             returns (uint winningProposal_)
//     {
//         uint winningVoteCount = 0;
//         for (uint p = 0; p < proposals.length; p++) {
//             if (proposals[p].voteCount > winningVoteCount) {
//                 winningVoteCount = proposals[p].voteCount;
//                 winningProposal_ = p;
//             }
//         }
//     }

//     /** 
//      * @dev Calls winningProposal() function to get the index of the winner contained in the proposals array and then
//      * @return winnerName_ the name of the winner
//      */
//     function winnerName() public view
//             returns (bytes32 winnerName_)
//     {
//         winnerName_ = proposals[winningProposal()].name;
//     }
// }