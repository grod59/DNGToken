// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract AirbnbLike {

    // Define the structure for a property
    struct Property {
        string name;
        string description;
        string addressP;
        uint256 pricePerNight;
        address owner;
        bytes32[] images;
        bytes32[] documents;
        bool refundRequested;
    }

    // Define the structure for a review
    struct Review {
        uint256 rating;
        string review;
        address renter;
    }

    // Define the structure for a booking
    struct Booking {
        uint256 startDate;
        uint256 endDate;
        address renter;
        uint256 amount;
    }

    // Define the structure for a dispute
    struct Dispute {
        bytes32 propertyId;
        address renter;
        string reason;
        uint256 status; // 0 = pending, 1 = resolved
    }

    // Define the structure for a user
    struct User {
        address userAdd;
        uint256 reputationScore;
        uint256 numberOfRatings;
    }

    // Mapping to store the allowed transfer of tokens between two addresses
    // mapping (address => mapping (address => uint256)) public allowed;

    // Mapping to store properties
    mapping(bytes32 => Property) public properties;

    // Mapping to store reviews
    mapping(bytes32 => Review[]) public reviews;

    // Mapping to store bookings
    mapping (bytes32 => Booking[]) public bookings;


    // Mapping to store disputes
    mapping (uint256 => Dispute) public disputes;

    // Mapping to store users
    mapping (address => User) public users;

    // Event for adding property
    event PropertyAdded(
        string name,
        string description,
        string addressP,
        uint256 pricePerNight
    );

    // Event for user rating
    event UserRated(
        address user,
        uint256 rating
    );

    // Event for booking made
    event BookingMade(
        bytes32 propertyId,
        uint256 startDate,
        uint256 endDate,
        uint256 amount
    );

    // Event for stay reviewed
    event StayReviewed(
        bytes32 propertyId,
        uint256 rating,
        string review
    );

    // Event for refund requested
    event RefundRequested(
        bytes32 propertyId
    );

    // // Event for tokens transferred
    // event TokensTransferred(
    //     address from,
    //     address to,
    //     uint256 value
    // );

    // // Event for tokens approved
    // event TokensApproved(
    //     address spender,
    //     uint256 value
    // );

    function addProperty(
        string memory _name,
        string memory _description,
        string memory _address,
        uint256 _pricePerNight,
        bytes32[] memory _images,
        bytes32[] memory _documents
    ) public {
        properties[keccak256(abi.encodePacked(_name))] = Property(
            _name,
            _description,
            _address,
            _pricePerNight,
            msg.sender,
            _images,
            _documents,
            false
        );
    }

    function rateUser(address user, uint256 rating) public {
        User storage userData = users[user];
        userData.reputationScore = (userData.reputationScore * userData.numberOfRatings + rating) / (userData.numberOfRatings + 1);
        userData.numberOfRatings++;
    }

    // function raiseDispute(bytes32 propertyId, string memory reason) public {
    //     Property storage property = properties[propertyId];
    //     require(property.owner != address(0), "Property does not exist");
        
    //     uint256 disputeId = keys(disputes).length;
    //     disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);
    // }

    function resolveDispute(uint256 disputeId, uint256 resolution) public {
        Dispute storage dispute = disputes[disputeId];
        require(dispute.status == 0, "Dispute already resolved");
        
        dispute.status = resolution;  
    }
    
    function makeBooking(bytes32 propertyId, uint256 startDate, uint256 endDate, uint256 amount) public {
        Property storage property = properties[propertyId];
        require(property.owner != address(0), "Property does not exist");
        
        bookings[propertyId].push(Booking(startDate, endDate, msg.sender, amount));
    }
    
    function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
        // Ensure that the property exists
        Property storage property = properties[propertyId];
        require(property.owner != address(0), "Property does not exist");
        
        // Add the review
        reviews[propertyId].push(Review(rating, review, msg.sender));
    }
    
    
    function requestRefund(bytes32 propertyId) public {
        // Ensure that the property exists
        Property storage property = properties[propertyId];
        require(property.owner != address(0), "Property does not exist");

        // Ensure that the refund has not already been requested
        require(!property.refundRequested, "Refund has already been requested");
        
        // Request the refund
        property.refundRequested = true;
    }
    
    // function transfer(address to, uint256 value) public {
    //     require(balanceOf[msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer failed.");
    //     balanceOf[msg.sender] -= value;
    //     balanceOf[to] += value;
    // }
    
    // function approve(address spender, uint256 value) public {
    //     require(balanceOf[msg.sender] >= value, "Approval failed.");
    //     allowed[msg.sender][spender] = value;
    // }
    
    // function transferFrom(address from, address to, uint256 value) public {
    //     require(balanceOf[from] >= value && allowed[from][msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer from failed.");
    //     balanceOf[from] -= value;
    //     allowed[from][msg.sender] -= value;
    //     balanceOf[to] += value;
    // }

    // function getProperties() public view returns (bytes32[] memory) {
    //     bytes32[] memory propertyIds = new bytes32[](properties.length);
    //     uint256 i = 0;
    //     for (bytes32 propertyId in properties) {
    //         propertyIds[i++] = propertyId;
    //     }
    //     return propertyIds;
    // }
}

// // pragma solidity ^0.8.0;
// import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint shares;
//         address[] symbolAdr;
//     }

//     IUniswapV2Router02 public router;
//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     constructor (address _router) public {
//         router = IUniswapV2Router02(_router);
//     }
 
//     function addOrder(string memory _symbol, uint256 _price, uint _shares, address[] memory _symbolAdr) public {
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares, _symbolAdr);
//         orderCount++;
//     }

//     function min(uint a, uint b) internal pure returns (uint) {
//         return a < b ? a : b;
//     }   

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))) {
//                     uint amountIn = min(orders[i].shares, orders[j].shares);
//                     // Check liquidity
//                     (uint[] memory amounts) = router.getAmountsOut(orders[i].shares, orders[i].symbolAdr);
//                     (uint[] memory amounts2) = router.getAmountsOut(orders[j].shares, orders[j].symbolAdr);
//                    if (amounts[0] < amountIn) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                    if (amounts2[0] < amountIn) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                     // Execute the trade
//                     orders[i].shares -= amountIn;
//                     orders[j].shares -= amountIn;
//                     emit Trade(orders[i].trader, orders[j].trader, amountIn, orders[i].symbol, orders[i].price, orders[i].symbolAdr);
//                 }
//             }
//         }
//     }
//     event Trade(address trader1, address trader2, uint amountIn, string symbol, uint256 price, address[] symbolAdr);

// }

// // pragma solidity ^0.8.0;
// // import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
// // contract DarkPool {
// //     struct Order {
// //         address trader;
// //         string symbol;
// //         uint256 price;
// //         uint shares;
// //         address[] symbolAdr;
//     }
//     IUniswapV2Router02 public router;

//     mapping (address => mapping (string => mapping (uint256 => uint256))) public orders;
//     uint public orderCount;

//     function addOrder(address trader, string memory symbol, uint256 price, uint shares, address[] memory symbolAdr) public {
//         orders[trader][symbol][price] = shares;
//         orderCount++;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbolAdr)) == keccak256(abi.encodePacked(orders[j].symbolAdr)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))) {
//                     uint amountIn = min(orders[i].shares, orders[j].shares);
//                     // Check liquidity
//                     (uint[] memory amounts) = router.getAmountsOut(orders[i].shares, orders[i].symbolAdr);
//                     (uint[] memory amounts2) = router.getAmountsOut(orders[j].shares, orders[j].symbolAdr);
//                 if (amounts[0] < amountIn) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                 if (amounts2[0] < amountIn) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                     // Execute the trade
//                     orders[i].shares -= amountIn;
//                     orders[j].shares -= amountIn;
//                     emit Trade(orders[i].trader, orders[j].trader, amountIn, orders[i].symbol, orders[i].price, orders[i].symbolAdr);
//                 }
//             }
//         }
//     }

    // function matchOrders() public {
    //     for (address trader1 in orders) {
    //         for (string symbol1 in orders[trader1]) {
    //             for (uint256 price1 in orders[trader1][symbol1]) {
    //                 for (address trader2 in orders) {
    //                     for (string symbol2 in orders[trader2]) {
    //                         for (uint256 price2 in orders[trader2][symbol2]) {
    //                             if (trader1 != trader2 && symbol1 == symbol2 && price1 == price2) {
    //                                 uint shares1 = orders[trader1][symbol1][price1];
    //                                 uint shares2 = orders[trader2][symbol2][price2];
    //                                 uint amountIn = min(shares1, shares2);

    //                                 // Execute the trade
    //                                 orders[trader1][symbol1][price1] -= amountIn;
    //                                 orders[trader2][symbol2][price2] -= amountIn;

    //                                 // Emit the Trade event
    //                                 emit Trade(trader1, trader2, amountIn, symbol1, price1, symbolAdr);
    //                             }
    //                         }
    //                     }
    //                 }
    //             }
    //         }
//     //     }
//     // }

//     function min(uint a, uint b) internal pure returns (uint) {
//         return a < b ? a : b;
//     }

//     event Trade(address trader1, address trader2, uint amountIn, string symbol, uint256 price, address[] symbolAdr);
// }


// pragma solidity ^0.8.0;
// import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint shares;
//         address[] symbolAdr;
//     }

//     IUniswapV2Router02 public router;
//     mapping (address => mapping (string => mapping (uint256 => mapping (uint => Order)))) public orders;
//     mapping (address => mapping (string => mapping (uint256 => uint))) public orderCount;

//     constructor (address _router) public {
//         router = IUniswapV2Router02(_router);
//     }

//     function addOrder(string memory _symbol, uint256 _price, uint _shares, address[] memory _symbolAdr) public {
//         orders[msg.sender][_symbol][_price][orderCount[msg.sender][_symbol][_price]++] = Order(msg.sender, _symbol, _price, _shares, _symbolAdr);
//     }

//     function min(uint a, uint b) internal pure returns (uint) {
//         return a < b ? a : b;
//     }   

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (
//                     orders[i].symbol == orders[j].symbol &&
//                     orders[i].price == orders[j].price
//                 ) {
//                     uint amountIn = min(orders[i].shares, orders[j].shares);

//                     (uint[] memory amounts) = router.getAmountsOut(amountIn, orders[i].symbolAdr);
//                     if (amounts[0] < amountIn) continue;

//                     (uint[] memory amounts2) = router.getAmountsOut(amountIn, orders[j].symbolAdr);
//                     if (amounts2[0] < amountIn) continue;

//                     orders[i].shares -= amountIn;
//                     orders[j].shares -= amountIn;

//                     emit Trade(
//                         orders[i].trader,
//                         orders[j].trader,
//                         amountIn,
//                         orders[i].symbol,
//                         orders[i].price,
//                         orders[i].symbolAdr
//                     );
//                 }
//             }           
//         }    
//     }             
//     event Trade(address trader1, address trader2, uint amountIn, string symbol, uint256 price, address[] symbolAdr);

//     function trade(address trader1, address trader2, uint amountIn, string memory symbol, uint256 price, address[] memory symbolAdr) public {
//     require(trader1 != address(0), "Trader 1 address is invalid");
//     require(trader2 != address(0), "Trader 2 address is invalid");
//     require(amountIn > 0, "Amount must be greater than 0");         
//     // Check liquidity
//     (uint[] memory amounts) = router.getAmountsOut(amountIn, symbolAdr);
//     if (amounts[0] < amountIn) {
//         // Liquidity check failed, don't execute the trade
//         return;
//     }

//     // Execute the trade
//     // ...

//     // Emit the Trade event
//     emit Trade(trader1, trader2, amountIn, symbol, price, symbolAdr);
//     }
// }


// // pragma solidity ^0.6.0;
// pragma solidity ^0.8.0;
// import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint shares;
//         address[] symbolAdr;
//     }

//     IUniswapV2Router02 public router;
//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     constructor (address _router) public {
//         router = IUniswapV2Router02(_router);
//     }
 
//     function addOrder(string memory _symbol, uint256 _price, uint _shares, address[] memory _symbolAdr) public {
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares, _symbolAdr);
//         orderCount++;
//     }

//     function min(uint a, uint b) internal pure returns (uint) {
//         return a < b ? a : b;

//     }   
//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))) {
//                     uint amountIn = min(orders[i].shares, orders[j].shares);
//                     // Check liquidity
//                     (uint[] memory amounts) = router.getAmountsOut(orders[i].shares, orders[i].symbolAdr);
//                     (uint[] memory amounts2) = router.getAmountsOut(orders[j].shares, orders[j].symbolAdr);
//                    if (amounts[0] < amountIn) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                    if (amounts2[0] < amountIn) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                     // Execute the trade
//                     orders[i].shares -= amountIn;
//                     orders[j].shares -= amountIn;
//                     emit Trade(orders[i].trader, orders[j].trader, amountIn, orders[i].symbol, orders[i].price, orders[i].symbolAdr);
//                 }
//             }
//         }
//     }
//     event Trade(address trader1, address trader2, uint amountIn, string symbol, uint256 price, address[] symbolAdr);

//     function trade(address trader1, address trader2, uint amountIn, string memory symbol, uint256 price, address[] memory symbolAdr) public {
//         require(trader1 != address(0), "Trader 1 address is invalid");
//         require(trader2 != address(0), "Trader 2 address is invalid");
//         require(amountIn > 0, "Amount must be greater than 0");

//         // Check liquidity
//         (uint[] memory amounts) = router.getAmountsOut(amountIn, symbolAdr);
//         if (amounts[0] < amountIn) {
//             // Liquidity check failed, don't execute the trade
//             return;
//         }

//         // Execute the trade
//         // ...
//         // Emit the Trade event
//         emit Trade(trader1, trader2, amountIn, symbol, price, symbolAdr);
//     }

// }

// pragma solidity ^0.8.0;

// import "https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/interfaces/IUniswapV3Router.sol";

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//         address[] symbolAdr;
//     }
//     IUniswapV3Router public router;
//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     constructor (address _router) public {
//         router = IUniswapV3Router(_router);
//     }

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares, address[] memory _symbolAdr) public {
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares, _symbolAdr);
//         orderCount++;
//     }

//     function min(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }   
//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))) {
//                     uint256 shares = min(orders[i].shares, orders[j].shares);
//                     uint[] memory path = [orders[i].symbolAdr[0], orders[j].symbolAdr[0]];
//                     uint[] memory output = new uint[](2);
//                     uint[] memory inputAmount = [shares, 0];
//                     if (router.swapOutputAmount(output, path, inputAmount) != shares) {
//                         // Liquidity check failed, don't execute the trade
//                         continue;
//                     }
//                     // Execute the trade
//                     orders[i].shares -= shares;
//                     orders[j].shares -= shares;
//                     emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//                 }
//             }
//         }
//     }
//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
// }



// pragma solidity ^0.8.0;

// // import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Pair.sol";

// import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol";
// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//     }

//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares) public {
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares);
//         orderCount++;
//     }

//     function mint(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))){
//                     uint256 shares = mint(orders[i].shares, orders[j].shares);
//                     // Check the liquidity of the trading pair
//                     IUniswapV2Pair pair = IUniswapV2Pair(getPairAddress(orders[i].symbol));
//                     uint liquidity = pair.liquidity();
//                     if (liquidity >= shares) {
//                         // Execute the trade
//                         orders[i].shares -= shares;
//                         orders[j].shares -= shares;
//                         emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//                     } else {
//                         // Insufficient liquidity
//                         emit InsufficientLiquidity(orders[i].symbol);
//                     }
//                 }
//             }
//         }
//     }

//     function getPairAddress(string memory symbol) internal view returns (address) {
//         // Return the address of the Uniswap pair contract for the given symbol
//         // Replace this dummy code with the actual API call to the Uniswap DEX
//     }

//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
//     event InsufficientLiquidity(string symbol);
// }


// pragma solidity ^0.8.0;

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//     }

//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares) public {
//         require(getLiquidity(_symbol) >= _shares, "Not enough liquidity in the trading pair");
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares);
//         orderCount++;
//     }

//     function mint(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))){
//                     uint256 shares = mint(orders[i].shares, orders[j].shares);
//                     orders[i].shares -= shares;
//                     orders[j].shares -= shares;
//                     emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//                 }
//             }
//         }
//     }

//     function getLiquidity(string memory _symbol) public view returns (uint256) {
//         // Replace the dummy code with the actual API call to the DEX
//         // to retrieve the liquidity of the trading pair
//         uint256 liquidity;
//         (bool success, uint256 l) = externalContract.getLiquidity(_symbol);
//         require(success, "Failed to retrieve liquidity from the DEX");
//         liquidity = l;
//         return liquidity;
//     }

//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
// }



// pragma solidity ^0.8.0;

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//     }

//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares) public {
//         // orders[orderCount] = Order(_symbol, _shares);
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares);
//         orderCount++;
//     }

//     function mint(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))){
//                     uint256 shares = mint(orders[i].shares, orders[j].shares);
//                     // Check liquidity
//                     if (getLiquidity(orders[i].symbol) >= shares) {
//                         // Execute the trade
//                         orders[i].shares -= shares;
//                         orders[j].shares -= shares;
//                         emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//                     }
//                 }
//             }
//         }
//     }

//     function getLiquidity(string memory symbol) public view returns (uint256) {
//         uint256 liquidity = 0;
//         for (uint i = 0; i < orderCount; i++) {
//             if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(symbol))) {
//                 liquidity += orders[i].shares;
//             }
//         }
//         return liquidity;
//     }

//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
// }





// pragma solidity ^0.8.0;

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//     }

//     mapping (uint => Order) public orders;
//     uint public orderCount;

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares) public {
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares);
//         orderCount++;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))) {
//                     uint256 shares = mint(orders[i].shares, orders[j].shares);
//                     executeTrade(i, j, shares);
//                 }
//             }
//         }
//     }

//     function executeTrade(uint i, uint j, uint256 shares) internal {
//         // Check liquidity of the trading pair before executing trade
//         if (!checkLiquidity(orders[i].symbol, shares)) {
//             // If liquidity check fails, do not execute trade
//             return;
//         }
//         // Deduct shares from both orders
//         orders[i].shares -= shares;
//         orders[j].shares -= shares;
//         // Notify both traders of the trade
//         emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//     }

//     function checkLiquidity(string memory symbol, uint256 shares) internal view returns (bool) {
//         // Add code to check the liquidity of the trading pair
//         // Example: return (getLiquidity(symbol) >= shares);
//         return true;
//     }

//     function mint(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
// }


// pragma solidity ^0.8.0;

// contract DarkPool {
//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//     }

//     mapping (uint => Order) public orders;
//     mapping (address => uint[]) public traderOrders;
//     uint public orderCount;

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares) public {
//         // orders[orderCount] = Order(_symbol, _shares);
//         orders[orderCount] = Order(msg.sender, _symbol, _price, _shares);
//         orderCount++;
//     }

//     function getTraderOrders(address _trader) public view returns (uint[] memory) {
//         return traderOrders[_trader];
//     }
    
//     function getOrderDetails(uint orderId) public view returns (address trader, string memory symbol, uint256 price, uint256 shares) {
//         Order storage order = orders[orderId];
//         trader = order.trader;
//         symbol = order.symbol;
//         price = order.price;
//         shares = order.shares;
//     }

//     function min(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     // function subt(uint256 a, uint256 b) internal pure returns (uint256) {
//     //     return a - b;
//     // }
    
//     function cancelOrder(uint orderId) public {
//         require(orders[orderId].trader == msg.sender, "Only the trader who created the order can cancel it.");
//         delete orders[orderId];
//         orderCount--;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orderCount; i++) {
//             for (uint j = i + 1; j < orderCount; j++) {
//                 if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(orders[j].symbol)) && 
//                 keccak256(abi.encodePacked(orders[i].price)) == keccak256(abi.encodePacked(orders[j].price))){
//                     uint256 shares = min(orders[i].shares, orders[j].shares);
//                     // Execute the trade
//                     orders[i].shares -= shares;
//                     orders[j].shares -= shares;
//                     // orders[i].shares = orders[i].shares.subt(shares);
//                     // orders[j].shares = orders[j].shares.subt(shares);
//                     emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//                 }
//             }
//         }
//     }


//     function checkLiquidity(string memory _symbol) public view returns (uint256) {
//         uint256 liquidity = 0;
//         for (uint i = 0; i < orderCount; i++) {
//             if (keccak256(abi.encodePacked(orders[i].symbol)) == keccak256(abi.encodePacked(_symbol))) {
//                 liquidity += orders[i].shares;
//             }
//         }
//         return liquidity;
//     }

//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
// }


// pragma solidity ^0.8.0;

// // import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
// // import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol";
// contract DarkPool {
//     // using SafeMath for uint256;
//     // using Math for uint256;
//     uint256 private value;

//     struct Order {
//         address trader;
//         string symbol;
//         uint256 price;
//         uint256 shares;
//     }

//     Order[] public orders;
//     // mapping (uint => Order) public orders;

//     function addOrder(string memory _symbol, uint256 _price, uint256 _shares) public {
//         orders.push(Order(msg.sender, _symbol, _price, _shares));
//     }

//     function mint(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     function subt(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a - b;
//     }

//     function matchOrders() public {
//         for (uint i = 0; i < orders.length; i++) {
//             for (uint j = i + 1; j < orders.length; j++) {
//                 if (orders[i].symbol == orders[j].symbol &&
//                     orders[i].price == orders[j].price) {
//                     uint256 shares = mint(orders[i].shares, orders[j].shares);
//                     orders[i].shares = orders[i].shares.subt(shares);
//                     orders[j].shares = orders[j].shares.subt(shares);
//                     emit Trade(orders[i].trader, orders[j].trader, shares, orders[i].symbol, orders[i].price);
//                 }
//             }
//         }
//     }


//     event Trade(address trader1, address trader2, uint256 shares, string symbol, uint256 price);
// }




// write a full version of above code with more functionality 

// pragma solidity ^0.8.0;
// // pragma solidity ^0.9.0;

// contract AirbnbLike {

//     string public constant name = "DNG Token";
//     string public constant symbol = "DNG";
//     uint256 public constant decimals = 18;
//     uint256 public totalSupply = 10000;





//     // Define the structure for a property
//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//         bool isAvailable; // Add this property

//     }

//     // Define the structure for a review
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }

//     // Define the structure for a booking
//     struct Booking {
//         uint256 startDate;
//         uint256 endDate;
//         address renter;
//         uint256 amount;
//     }

//     // Define the structure for a dispute
//     struct Dispute {
//         bytes32 propertyId;
//         address renter;
//         string reason;
//         uint256 status; // 0 = pending, 1 = resolved
//     }

//     // Define the structure for a user
//     struct User {
//         uint256 reputationScore;
//         uint256 numberOfRatings;
//     }

//     // Mapping to store the allowed transfer of tokens between two addresses
//     mapping (address => mapping (address => uint256)) public allowed;

//     // Mapping to store properties
//     mapping(bytes32 => Property) public properties;

//     // Mapping to store reviews
//     mapping(bytes32 => Review[]) public reviews;

//     // Mapping to store bookings
//     mapping (bytes32 => Booking[]) public bookings;

//     // Mapping to store balance of each address
//     mapping(address => uint256) public balanceOf;

//     // Mapping to store disputes
//     mapping (uint256 => Dispute) public disputes;


//     // Mapping to store users
//     mapping (address => User) public users;

//     // mapping(bytes32 => Property) public properties;
//     // mapping(uint256 => Dispute) public disputes;
//     uint256 public propertyCount;
//     uint256 disputeCounter = 0;  

//     mapping (bytes32 => Property) public propertyIdToPropertyMap;


//     // Event for adding property
//     event PropertyAdded(
//         string name,
//         string description,
//         string addressP,
//         uint256 pricePerNight
//     );

//     // Event for user rating
//     event UserRated(
//         address user,
//         uint256 rating
//     );

//     // Event for booking made
//     event BookingMade(
//         bytes32 propertyId,
//         uint256 startDate,
//         uint256 endDate,
//         uint256 amount
//     );

//     // Event for stay reviewed
//     event StayReviewed(
//         bytes32 propertyId,
//         uint256 rating,
//         string review
//     );

//     // Event for refund requested
//     event RefundRequested(
//         bytes32 propertyId
//     );

//     // Event for tokens transferred
//     event TokensTransferred(
//         address from,
//         address to,
//         uint256 value
//     );

//     // Event for tokens approved
//     event TokensApproved(
//         address spender,
//         uint256 value
//     );

//     function addProperty(
//         bytes32 propertyId, 
//         string memory _name, 
//         string memory _description, 
//         string memory _address, 
//         uint256 _pricePerNight, 
//         bytes32[] memory _images, 
//         bytes32[] memory _documents,
//         // uint256 price
//         bool price
//     ) public {
//         require(
//             properties[propertyId].owner == address(0) ||
//             keccak256(abi.encodePacked(name)) == propertyId, 
//             "Property already exists"
//         );
//         properties[propertyId] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             price,
//             true
//         );
//         propertyCount++;
//     }


//     // function addProperty(
//     //     string memory _name,
//     //     string memory _description,
//     //     string memory _address,
//     //     uint256 _pricePerNight,
//     //     bytes32[] memory _images,
//     //     bytes32[] memory _documents
        
//     // ) public {
//     //     properties[keccak256(abi.encodePacked(_name))] = Property(
//     //         _name,
//     //         _description,
//     //         _address,
//     //         _pricePerNight,
//     //         msg.sender,
//     //         _images,
//     //         _documents,
//     //         false
//     //     );
//     // }

//     // function addProperty(
//     //     bytes32 propertyId, 
//     //     string memory name, 
//     //      price
         
//     //     ) public {
//     //     require(properties[propertyId].owner == address(0), "Property already exists");
//     //     properties[propertyId] = Property(
//     //         propertyId, 
//     //         msg.sender, 
//     //         , price, 
//     //         true);
//     //     propertyCount++;
//     // }

//     function toggleAvailability(bytes32 propertyId) public {
//         Property storage property = properties[propertyId];
//         require(property.owner == msg.sender, "Only the property owner can perform this action");
//         property.isAvailable = !property.isAvailable;
//     }

//     // function addProperty(bytes32 propertyId, string memory name, uint256 price) public {
//     //     require(properties[propertyId].owner == address(0), "Property already exists");
//     //     properties[propertyId] = Property(propertyId, msg.sender, name, price, true);
//     //     propertyCount++;
//     // }       

//     function rateUser(address user, uint256 rating) public {
//         User storage userData = users[user];
//         userData.reputationScore = (userData.reputationScore * userData.numberOfRatings + rating) / (userData.numberOfRatings + 1);
//         userData.numberOfRatings++;
//     }

// //    function raiseDispute(bytes32 propertyId, string memory reason) public {
// //         Property storage property = properties[propertyId];
// //         require(property.owner != address(0), "Property does not exist");
        
// //         uint256 disputeId = keys(disputes).length;
// //         disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);
// //     } 
//     // function raiseDispute(bytes32 propertyId, string memory reason) public {
//     // // check if the property exists
//     // if (properties[propertyId].owner == address(0)) {
//     //     revert("Property does not exist");
//     // }

//     // // get the number of disputes and use it as the index for the new dispute
//     // uint256 disputeId = disputes.length;
//     // disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);
//     // }

//     function raiseDispute(bytes32 propertyId, string memory reason) public {
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         disputeCounter++;
//         disputes[disputeCounter] = Dispute(propertyId, msg.sender, reason, 0);
//     }

//     // function raiseDispute(bytes32 disputeHash, uint256 disputeValue) public {
//     //     require(disputes[disputeHash] == address(0), "Dispute already exists");
//     //     disputes[disputeHash] = msg.sender;
//     //     disputeValues[disputeHash] = disputeValue;

//     //     uint256 disputeId = disputeCount;
//     //     disputeCount++;
//     //     disputeIds[msg.sender].push(disputeId);
//     // }


//     function resolveDispute(uint256 disputeId, uint256 resolution) public {
//         Dispute storage dispute = disputes[disputeId];
//         require(dispute.status == 0, "Dispute already resolved");
        
//         dispute.status = resolution;  
//     }
    
//     function makeBooking(bytes32 propertyId, uint256 startDate, uint256 endDate, uint256 amount) public {
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         bookings[propertyId].push(Booking(startDate, endDate, msg.sender, amount));
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
    
//     function transfer(address to, uint256 value) public {
//         require(balanceOf[msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer failed.");
//         balanceOf[msg.sender] -= value;
//         balanceOf[to] += value;
//     }
    
//     function approve(address spender, uint256 value) public {
//         require(balanceOf[msg.sender] >= value, "Approval failed.");
//         allowed[msg.sender][spender] = value;
//     }
    
//     function transferFrom(address from, address to, uint256 value) public {
//         require(balanceOf[from] >= value && allowed[from][msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer from failed.");
//         balanceOf[from] -= value;
//         allowed[from][msg.sender] -= value;
//         balanceOf[to] += value;
//     }

//     // function getProperties() public view returns (bytes32[] memory) {
//     //     // bytes32[] memory propertyIds = new bytes32[](properties.length);
//     //     bytes32[] propertyIds = keys(propertyIdToPropertyMap);
//     //     // bytes32[] memory propertyIds = new bytes32[](properties.length);
//     //     //bytes32[] propertyIds = propertyIdToPropertyMap;
//     //     uint256 i = 0;
//     //     for (uint j = 0; j < properties.length; j++) {
//     //         propertyIds[i++] = properties[j].id;
//     //     }
//     //     return propertyIds;
//     // }

//     // function getPropertyIds() public view returns (bytes32[] memory) {
//     //     bytes32[] memory propertyIds = new bytes32[](propertyIdToPropertyMap.length);
//     //     uint i = 0;
//     //     for (uint j = 0; j < propertyIdToPropertyMap.length; j++) {
//     //         propertyIds[i] = propertyIdToPropertyMap[j]; // keys(propertyIdToPropertyMap)[j];// ; //keys(propertyIdToPropertyMap)[j];
//     //         i++;
//     //     }
//     //     return propertyIds;
//     // }


//     // function getPropertyIds() public view returns (bytes32[] memory) {
//     //     bytes32[] memory propertyIds = new bytes32[](propertyIdToPropertyMap.length);
//     //     uint i = 0;
//     //     for (bytes32 propertyId : keys(propertyIdToPropertyMap)) {
//     //         propertyIds[i] = propertyId;
//     //         i++;
//     //     }
//     //     return propertyIds;
//     // }


//     // function getPropertyIds() public view returns (bytes32[] memory) {
//     //     bytes32[] memory propertyIds = new bytes32[](propertyIdToPropertyMap.length);
//     //     uint i = 0;
//     //     for (bytes32 propertyId : keys(propertyIdToPropertyMap)) {
//     //         propertyIds[i] = propertyId;
//     //         i++;
//     //     }
//     //     return propertyIds;
//     // }


//     // mapping (bytes32 => Property) public propertyIdToPropertyMap;
//     // // function getPropertyIds() public view returns (bytes32[] memory) {
//     //     bytes32[] memory propertyIds = new bytes32[](propertyIdToPropertyMap.length);
//     //     uint i = 0;
//     //     for (uint j = 0; j < propertyIdToPropertyMap.length; j++) {
//     //         propertyIds[i] = keys(propertyIdToPropertyMap)[j];
//     //         i++;
//     //     }
//     //     return propertyIds;
//     // }



//     // function getPropertyIds() public view returns (bytes32[] memory) {
//     //     bytes32[] memory propertyIds = new bytes32[](propertyIdToPropertyMap.length);
//     //     uint i = 0;
//     //     for (bytes32 propertyId in keys(propertyIdToPropertyMap)) {
//     //         propertyIds[i] = propertyId;
//     //         i++;
//     //     }
//     //     return propertyIds;
//     // }

//     function getDisputes(bytes32 propertyId) public view returns (Dispute[] memory) {
//         Dispute[] memory result = new Dispute[](propertyCount);
//         uint256 resultIndex = 0;

//         for (uint256 i = 0; i < disputes.length; i++) {
//             if (disputes[i].propertyId == propertyId) {
//                 result[resultIndex] = disputes[i];
//                 resultIndex++;
//             }
//         }

//         return result;
//     }


// }

// pragma solidity ^0.8.0;
// contract AirbnbLike {

//     string public constant name = "DNG Token";
//     string public constant symbol = "DNG";
//     uint256 public constant decimals = 18;
//     uint256 public totalSupply = 10000;

//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }

//     struct Booking {
//         uint256 startDate;
//         uint256 endDate;
//         address renter;
//     }

//     struct Dispute {
//         bytes32 propertyId;
//         address renter;
//         string reason;
//         uint256 status; // 0 = pending, 1 = resolved
//     }

//     struct User {
//         uint256 reputationScore;
//         uint256 numberOfRatings;
//     }
    
//     mapping (address => mapping (address => uint256)) public allowed;

//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;

//     mapping (bytes32 => Booking[]) public bookings;
    
//     mapping(address => uint256) public balanceOf;

//     mapping (uint256 => Dispute) public disputes;

//     mapping (address => User) public users;

//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }

//     function rateUser(address user, uint256 rating) public {
//         User storage userData = users[user];
//         userData.reputationScore = (userData.reputationScore * userData.numberOfRatings + rating) / (userData.numberOfRatings + 1);
//         userData.numberOfRatings++;
//     }

//     // function raiseDispute(bytes32 propertyId, string memory reason) public {
//     //     Property storage property = properties[propertyId];
//     //     require(property.owner != address(0), "Property does not exist");
        
//     //     uint256 disputeId = keys(disputes).length;
//     //     disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);
//     // }

//     function resolveDispute(uint256 disputeId, uint256 resolution) public {
//         Dispute storage dispute = disputes[disputeId];
//         require(dispute.status == 0, "Dispute already resolved");
        
//         dispute.status = resolution;
//     }
    
//     function makeBooking(bytes32 propertyId, uint256 startDate, uint256 endDate) public {
//     Property storage property = properties[propertyId];
//     require(property.owner != address(0), "Property does not exist");
    
//     bookings[propertyId].push(Booking(startDate, endDate, msg.sender));
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
    
//     function transfer(address to, uint256 value) public {
//         require(balanceOf[msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer failed.");
//         balanceOf[msg.sender] -= value;
//         balanceOf[to] += value;
//     }
    
//     function approve(address spender, uint256 value) public {
//         require(balanceOf[msg.sender] >= value, "Approval failed.");
//         allowed[msg.sender][spender] = value;
//     }
    
//     function transferFrom(address from, address to, uint256 value) public {
//         require(balanceOf[from] >= value && allowed[from][msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer from failed.");
//         balanceOf[from] -= value;
//         allowed[from][msg.sender] -= value;
//         balanceOf[to] += value;
//     }

//     // function getProperties() public view returns (bytes32[] memory) {
//     //     bytes32[] memory propertyIds = new bytes32[](properties.length);
//     //     uint256 i = 0;
//     //     for (bytes32 propertyId in properties) {
//     //         propertyIds[i++] = propertyId;
//     //     }
//     //     return propertyIds;
//     // }
// }

// pragma solidity ^0.8.0;
// contract AirbnbLike {

//     string public constant name = "DNG Token";
//     string public constant symbol = "DNG";
//     uint256 public constant decimals = 18;
//     uint256 public totalSupply = 10000;

//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }

//     struct Booking {
//         uint256 startDate;
//         uint256 endDate;
//         address renter;
//     }

//     struct Dispute {
//         bytes32 propertyId;
//         address renter;
//         string reason;
//         uint256 status; // 0 = pending, 1 = resolved
//     }

//     struct User {
//         uint256 reputationScore;
//         uint256 numberOfRatings;
//     }
    
//     mapping (address => mapping (address => uint256)) public allowed;

//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;

//     mapping (bytes32 => Booking[]) public bookings;
    
//     mapping(address => uint256) public balanceOf;

//     mapping (uint256 => Dispute) public disputes;

//     mapping (address => User) public users;

//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }

//     function rateUser(address user, uint256 rating) public {
//         User storage userData = users[user];
//         userData.reputationScore = (userData.reputationScore * userData.numberOfRatings + rating) / (userData.numberOfRatings + 1);
//         userData.numberOfRatings++;
//     }

//     function addBooking(bytes32 propertyId, uint256 startDate, uint256 endDate) public {
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
//         bookings[propertyId].push(Booking(startDate, endDate, msg.sender));
//     }

//     function refundRequest(bytes32 propertyId) public {
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
//         property.refundRequested = true;
//     }
    
//     function getProperty(bytes32 propertyId) public view returns (
//         string memory name,
//         string memory description,
//         string memory addressP,
//         uint256 pricePerNight,
//         address owner,
//         bytes32[] memory images,
//         bytes32[] memory documents,
//         bool refundRequested
//     ) {
//         Property storage property = properties[propertyId];
//         name = property.name;
//         description = property.description;
//         addressP = property.addressP;
//         pricePerNight = property.pricePerNight;
//         owner = property.owner;
//         images = property.images;
//         documents = property.documents;
//         refundRequested = property.refundRequested;
//     }
    
//     function getUser(address user) public view returns (uint256 reputationScore, uint256 numberOfRatings) {
//         User storage userData = users[user];
//         reputationScore = userData.reputationScore;
//         numberOfRatings = userData.numberOfRatings;
//     }
// }



// pragma solidity ^0.8.0;
// contract AirbnbLike {

//     string public constant name = "DNG Token";
//     string public constant symbol = "DNG";
//     uint256 public constant decimals = 18;
//     uint256 public totalSupply = 10000;

//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }

//     struct Booking {
//         uint256 startDate;
//         uint256 endDate;
//         address renter;
//     }

//     struct Dispute {
//         bytes32 propertyId;
//         address renter;
//         string reason;
//         uint256 status; // 0 = pending, 1 = resolved
//     }

//     struct User {
//         uint256 reputationScore;
//         uint256 numberOfRatings;
//     }
    
//     mapping (address => mapping (address => uint256)) public allowed;

//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;

//     mapping (bytes32 => Booking[]) public bookings;
    
//     mapping(address => uint256) public balanceOf;

//     mapping (uint256 => Dispute) public disputes;

//     mapping (address => User) public users;

//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }

//     function rateUser(address user, uint256 rating) public {
//         User storage userData = users[user];
//         userData.reputationScore = (userData.reputationScore * userData.numberOfRatings + rating) / (userData.numberOfRatings + 1);
//         userData.numberOfRatings++;
//     }

//     // function raiseDispute(bytes32 propertyId, string memory reason) public {
//     //     Property storage property = properties[propertyId];
//     //     require(property.owner != address(0), "Property does not exist");
        
//     //     // uint256 disputeId = disputes.count;
//     //     uint256 disputeId = keys(disputes).length;

//     //     disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);
//     // }

//     function resolveDispute(uint256 disputeId, uint256 resolution) public {
//         Dispute storage dispute = disputes[disputeId];
//         require(dispute.status == 0, "Dispute already resolved");
        
//         dispute.status = resolution;
//     }

//     // function makeBooking(bytes32 propertyId, uint256 startDate, uint256 endDate) public {
    
//     function makeBooking(bytes32 propertyId, uint256 startDate, uint256 endDate) public {
//     Property storage property = properties[propertyId];
//     require(property.owner != address(0), "Property does not exist");
    
//     bookings[propertyId].push(Booking(startDate, endDate, msg.sender));
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
    
//     function transfer(address to, uint256 value) public {
//         require(balanceOf[msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer failed.");
//         balanceOf[msg.sender] -= value;
//         balanceOf[to] += value;
//     }
    
//     function approve(address spender, uint256 value) public {
//         require(balanceOf[msg.sender] >= value, "Approval failed.");
//         allowed[msg.sender][spender] = value;
//     }
    
//     function transferFrom(address from, address to, uint256 value) public {
//         require(balanceOf[from] >= value && allowed[from][msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer from failed.");
//         balanceOf[from] -= value;
//         allowed[from][msg.sender] -= value;
//         balanceOf[to] += value;
//     }
// }


// pragma solidity ^0.8.0;

// contract AirbnbLike {

//     string public constant name = "DNG Token";
//     string public constant symbol = "DNG";
//     uint256 public constant decimals = 18;
//     uint256 public totalSupply = 10000;

//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }

//     struct Booking {
//     uint256 startDate;
//     uint256 endDate;
//     address renter;
//     }

//     struct Dispute {
//     bytes32 propertyId;
//     address renter;
//     string reason;
//     uint256 status; // 0 = pending, 1 = resolved
//     }

//     struct User {
//         uint256 reputationScore;
//         uint256 numberOfRatings;
//     }
    
//     mapping (address => mapping (address => uint256)) public allowed;

//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;

//     mapping (bytes32 => Booking[]) public bookings;
    
 
//     mapping(address => uint256) public balanceOf;

//     mapping (uint256 => Dispute) public disputes;

//     mapping (address => User) public users;

//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }

    // function getProperty(bytes32 propertyId) public view returns (
    //     string memory name,
    //     string memory description,
    //     string memory addressP,
    //     uint256 pricePerNight,
    //     address owner,
    //     bytes32[] memory images,
    //     bytes32[] memory documents,
    //     bool refundRequested
    // ) {
    //     Property storage property = properties[propertyId];
    //     name = property.name;
    //     description = property.description;
    //     addressP = property.addressP;
    //     pricePerNight = property.pricePerNight;
    //     owner = property.owner;
    //     images = property.images;
    //     documents = property.documents;
    //     refundRequested = property.refundRequested;
    // }

    // function getUser(address user) public view returns (uint256 reputationScore, uint256 numberOfRatings) {
    //     User storage userData = users[user];
    //     reputationScore = userData.reputationScore;
    //     numberOfRatings = userData.numberOfRatings;
    // }

//     function rateUser(address user, uint256 rating) public {
//         User storage userData = users[user];
//         userData.reputationScore = (userData.reputationScore * userData.numberOfRatings + rating) / (userData.numberOfRatings + 1);
//         userData.numberOfRatings++;
//     }

//     function raiseDispute(bytes32 propertyId, string memory reason) public {
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // uint256 disputeId = disputes.length++;
//         // disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);

//         // uint256 disputeId = disputes.keys().length;
//         uint256 disputeId = disputes.count;
//         // disputes[disputeId] = dispute;
//         disputes[disputeId] = Dispute(propertyId, msg.sender, reason, 0);

//     }

//     function resolveDispute(uint256 disputeId, uint256 resolution) public {
//         Dispute storage dispute = disputes[disputeId];
//         require(dispute.status == 0, "Dispute already resolved");
        
//         dispute.status = resolution;
//     }

//     function makeBooking(bytes32 propertyId, uint256 startDate, uint256 endDate) public {
//     Property storage property = properties[propertyId];
//     require(property.owner != address(0), "Property does not exist");
    
//     bookings[propertyId].push(Booking(startDate, endDate, msg.sender));
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
    
//     function transfer(address to, uint256 value) public {
//         require(balanceOf[msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer failed.");
//         balanceOf[msg.sender] -= value;
//         balanceOf[to] += value;
//     }
    
//     function approve(address spender, uint256 value) public {
//         require(balanceOf[msg.sender] >= value, "Approval failed.");
//         allowed[msg.sender][spender] = value;
//     }
    
//     function transferFrom(address from, address to, uint256 value) public {
//         require(balanceOf[from] >= value && allowed[from][msg.sender] >= value && balanceOf[to] + value >= balanceOf[to], "Transfer from failed.");
//         balanceOf[from] -= value;
//         allowed[from][msg.sender] -= value;
//         balanceOf[to] += value;
//     }
// }


// contract Token {
//     string public constant name = "AirbnbLike Token";
//     string public constant symbol = "ALT";
//     uint256 public constant decimals = 18;
//     uint256 public totalSupply;
    
//     mapping(address => uint256) public balanceOf;
//     address public owner;
    
//     constructor(uint256 _totalSupply) public {
//         owner = msg.sender;
//         totalSupply = _totalSupply;
//         balanceOf[owner] = totalSupply;
//     }
    
//     function transfer(address _to, uint256 _value) public {
//         require(balanceOf[msg.sender] >= _value && _value > 0, "Not enough balance");
//         balanceOf[msg.sender] -= _value;
//         balanceOf[_to] += _value;
//     }
// }


// contract AirbnbLike {

//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }
    
//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;
    
//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
// }

// contract AirbnbLike {
    
//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }
    
//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;
    
//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
// }





// pragma solidity ^0.8.0;


// contract AirbnbLike {
//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }
    
//     struct Review {
//         uint256 rating;
//         string review;
//         address renter;
//     }
    
//     mapping(bytes32 => Property) public properties;
//     mapping(bytes32 => Review[]) public reviews;
    
//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
        
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }
    
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
// }

// contract AirbnbLike {
//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bytes32 rentalAgreement;
//     }

//     mapping(bytes32 => Property) public properties;
    
//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents,
//         bytes32 _rentalAgreement
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             _rentalAgreement
//         );
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         // ...
//     }
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Request the refund
//         // ...
//     }
// }


// contract AirbnbLike {
//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//         bool refundRequested;
//     }

//     mapping(bytes32 => Property) public properties;
    
//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents,
//             false
//         );
//     }

//      function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         reviews[propertyId].push(Review(rating, review, msg.sender));
//     }   
//     // function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//     //     // Ensure that the property exists
//     //     Property storage property = properties[propertyId];
//     //     require(property.owner != address(0), "Property does not exist");
        
//     //     // Add the review
//     //     // ...
//     // }
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");

//         // Ensure that the refund has not already been requested
//         require(!property.refundRequested, "Refund has already been requested");
        
//         // Request the refund
//         property.refundRequested = true;
//     }
// }




// contract AirbnbLike {
//     struct Property {
//         string name;
//         string description;
//         string addressP;
//         uint256 pricePerNight;
//         address owner;
//         bytes32[] images;
//         bytes32[] documents;
//     }

//     mapping(bytes32 => Property) public properties;
    
//     function addProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint256 _pricePerNight,
//         bytes32[] memory _images,
//         bytes32[] memory _documents
//     ) public {
//         properties[keccak256(abi.encodePacked(_name))] = Property(
//             _name,
//             _description,
//             _address,
//             _pricePerNight,
//             msg.sender,
//             _images,
//             _documents
//         );
//     }
    
//     function reviewStay(bytes32 propertyId, uint256 rating, string memory review) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Add the review
//         // ...
//     }
    
//     function requestRefund(bytes32 propertyId) public {
//         // Ensure that the property exists
//         Property storage property = properties[propertyId];
//         require(property.owner != address(0), "Property does not exist");
        
//         // Request the refund
//         // ...
//     }
// }


// contract Airbnb {
//     struct Property {
//         string name;
//         string description;
//         address propertyAddress;
//         uint pricePerNight;
//         address owner;
//         string[] images;
//         string[] documents;
//     }
//     struct Rental {
//         Property property;
//         uint rentalPeriod;
//         address renter;
//     }
//     struct Review {
//         uint rating;
//         string description;
//         address renter;
//     }
//     mapping (bytes32 => Property) private properties;
//     mapping (bytes32 => Rental) private rentals;
//     mapping (bytes32 => Review) private reviews;
//     address owner;

//     constructor() public {
//         owner = msg.sender;
//     }

//     function uploadProperty(
//         string memory _name,
//         string memory _description,
//         string memory _address,
//         uint _pricePerNight,
//         string[] memory _images,
//         string[] memory _documents
//     ) public {
//         require(msg.sender == owner, "Only the owner can upload properties.");
//         properties[keccak256(_name)] = Property(_name, _description, _address, _pricePerNight, msg.sender, _images, _documents);
//     }

//     function rentProperty(string memory _propertyName, uint _rentalPeriod) public {
//         Property memory property = properties[keccak256(_propertyName)];
//         require(property.owner != msg.sender, "Cannot rent your own property.");
//         rentals[keccak256(_propertyName)] = Rental(property, _rentalPeriod, msg.sender);
//     }

//     function reviewProperty(string memory _propertyName, uint _rating, string memory _description) public {
//         Property memory property = properties[keccak256(_propertyName)];
//         Rental memory rental = rentals[keccak256(_propertyName)];
//         require(rental.renter == msg.sender, "Only renters can review properties.");
//         reviews[keccak256(_propertyName)] = Review(_rating, _description, msg.sender);
//     }

//     function refund(string memory _propertyName) public {
//         require(msg.sender == owner, "Only the owner can initiate refunds.");
//         Property memory property = properties[keccak256(_propertyName)];
//         Rental memory rental = rentals[keccak256(_propertyName)];
//         Review memory review = reviews[keccak256(_propertyName)];
//         require(review.rating < 3, "Refund only possible if property does not meet standards.");
//         rental.renter.transfer(rental.property.pricePerNight * rental.rentalPeriod);
//     }
// }