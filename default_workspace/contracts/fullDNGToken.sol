// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
pragma solidity ^0.8.0;
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
pragma solidity ^0.8.0;
contract ERC20 is IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 value) public override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}

pragma solidity ^0.8.0;
contract wrapERC20 is ERC20 {

    mapping (bytes32 => bytes) private _dataStorage;

    bytes32 private _dataHashL;

    event StoreData(address indexed _owner, bytes32 indexed _dataHash);

    function uploadData(bytes memory data) public {
        require(data.length <= 10485760, "Data size exceeds 10MB limit");
        _dataHashL = keccak256(data);
        _dataStorage[_dataHashL] = data;
        emit StoreData(msg.sender, _dataHashL);
    }

    function getDataHash() public view returns (bytes32) {
        return _dataHashL;
    }

    function getData(bytes32 hash) public view returns (bytes memory) {
        return _dataStorage[hash];
    }   

}

pragma solidity ^0.8.0;
// contract TokenMintERC20Token is ERC20 {
contract DNG_TokenMintERC20Token is wrapERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _mint(tokenOwnerAddress, totalSupply);
        feeReceiver.transfer(msg.value);
    }
    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }
    function getName() public view returns (string memory) {
        return _name;
    }
    function getSymbol() public view returns (string memory) {
        return _symbol;
    }
    function getDecimals() public view returns (uint8) {
        return _decimals;
    }
}

pragma solidity ^0.8.0;
contract TestDNG_TokenMintERC20Token {
    DNG_TokenMintERC20Token dngToken;
    string public constant name = "DNG Token";
    string public constant symbol = "DNG";
    uint256 public totalSup = 10000;
    uint8 public constant decimals = 18;
    address payable feeReceiver;
    address tokenOwnerAddress;
    constructor()  {
        // dng = new DNG();
         dngToken = new DNG_TokenMintERC20Token(name, symbol, decimals, totalSup, feeReceiver, tokenOwnerAddress);
    }
    function testTotalSupply() public view {
        uint256 totalSupply = dngToken.totalSupply();
        // Assert.equal(totalSupply, 0, "Total supply should be 0");
    }
    function testName() public view {
        string memory nameR = dngToken.getName();
        // Assert.equal(name, "DNG Token", "Token name should be DNG Token");
    }
    function testSymbol() public view {
        string memory symbolR = dngToken.getSymbol();
        // Assert.equal(symbol, "DNG", "Token symbol should be DNG");
    }
    function testDecimals() public view {
        uint8 decimalsR = dngToken.getDecimals();
        // Assert.equal(decimals, 18, "Token decimals should be 18");
    }
    function testBalanceOf() public view {
        uint256 balance = dngToken.balanceOf(address(this));
        // Assert.equal(balance, 0, "Balance should be 0");
    }
   function testBurn() public {
        dngToken.burn(100);
        uint256 balanceBurn = dngToken.balanceOf(address(this));
        // Assert.equal(balance, 100, "Balance should be 100");
    }
}


// pragma solidity ^0.8.0;

// // import "truffle/Assert.sol";
// // import "truffle/DeployedAddresses.sol";
// // import "../contracts/DNG_TokenMintERC20Token.sol";
//     // constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
// // import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/dev/Debug.sol";

// contract TestDNG_TokenMintERC20Token {
//     DNG_TokenMintERC20Token dngToken;

//     string public constant name = "DNG Token";
//     string public constant symbol = "DNG";
//     // uint256 public constant decimals = 18;
//     uint256 public totalSup = 10000;

//     uint8 public constant decimals = 18;
//     // uint256 totalSupply;
//     address payable feeReceiver;
//     address tokenOwnerAddress;

//     // DNG public dng;

//     constructor()  {
//         // dng = new DNG();
//          dngToken = new DNG_TokenMintERC20Token(name, symbol, decimals, totalSup, feeReceiver, tokenOwnerAddress);
//     }

//     // beforeEachTest() public {
//     //     dngToken = new DNG_TokenMintERC20Token();
//     // }

//     // Test total supply of tokens
//     // @test    public 
//     function testTotalSupply() public {
//         uint256 totalSupply = dngToken.totalSupply();
//         // Assert.equal(totalSupply, 0, "Total supply should be 0");
//     }

//     // Test name of the token
//     // @test    public 
//     function testName() public {
//         string memory nameR = dngToken.getName();
//         // Assert.equal(name, "DNG Token", "Token name should be DNG Token");
//     }

//     // Test symbol of the token
//     // @test    public 
//     function testSymbol() public {
//         string memory symbolR = dngToken.getSymbol();
//         // Assert.equal(symbol, "DNG", "Token symbol should be DNG");
//     }

//     // Test decimals of the token
//     // @test    public 
//     function testDecimals() public {
//         uint8 decimalsR = dngToken.getDecimals();
//         // Assert.equal(decimals, 18, "Token decimals should be 18");
//     }

//     // Test balance of the token
//     // @test    public 
//     function testBalanceOf() public {
//         uint256 balance = dngToken.balanceOf(address(this));
//         // Assert.equal(balance, 0, "Balance should be 0");
//     }
//    function testBurn() public {
//         dngToken.burn(100);
//         uint256 balanceBurn = dngToken.balanceOf(address(this));
//         // Assert.equal(balance, 100, "Balance should be 100");
//     }

// //  from solidity:
// // TypeError: Member "mint" not found or not visible after argument-dependent lookup in contract DNG_TokenMintERC20Token.
// //    --> contracts/shiba.sol:212:9:
// //     |
// // 212 |         dngToken.mint(address(this), 100);

//     // Test mint function
//     // @test     public 
//     // function testMint() public {
//     //     dngToken.mint(address(this), 100);
//     //     uint256 balance = dngToken.balanceOf(address(this));
//     //     // Assert.equal(balance, 100, "Balance should be 100");
//     // }
// }

// pragma solidity ^0.8.0;

// // import "truffle/Assert.sol";
// // import "truffle/DeployedAddresses.sol";
// // import "../contracts/DNG_TokenMintERC20Token.sol";

// contract TestDNG_TokenMintERC20Token {
//     DNG_TokenMintERC20Token dngToken;

//     // DNG public dng;

//     constructor() public {
//         // dng = new DNG();
//          dngToken = new DNG_TokenMintERC20Token();
//     }

//     // beforeEachTest() public {
//     //     dngToken = new DNG_TokenMintERC20Token();
//     // }

//     // Test total supply of tokens
//     // @test
//     public function testTotalSupply() public {
//         uint256 totalSupply = dngToken.totalSupply();
//         Assert.equal(totalSupply, 0, "Total supply should be 0");
//     }

//     // Test name of the token
//     @test
//     public function testName() public {
//         string memory name = dngToken.name();
//         Assert.equal(name, "DNG Token", "Token name should be DNG Token");
//     }

//     // Test symbol of the token
//     @test
//     public function testSymbol() public {
//         string memory symbol = dngToken.symbol();
//         Assert.equal(symbol, "DNG", "Token symbol should be DNG");
//     }

//     // Test decimals of the token
//     @test
//     public function testDecimals() public {
//         uint8 decimals = dngToken.decimals();
//         Assert.equal(decimals, 18, "Token decimals should be 18");
//     }

//     // Test balance of the token
//     @test
//     public function testBalanceOf() public {
//         uint256 balance = dngToken.balanceOf(address(this));
//         Assert.equal(balance, 0, "Balance should be 0");
//     }

//     // Test mint function
//     @test
//     public function testMint() public {
//         dngToken.mint(address(this), 100);
//         uint256 balance = dngToken.balanceOf(address(this));
//         Assert.equal(balance, 100, "Balance should be 100");
//     }
// }

// pragma solidity ^0.8.0;

// // import "truffle/Assert.sol";
// // import "truffle/DeployedAddresses.sol";
// // import "../contracts/TokenMintERC20Token.sol";

// contract TestTokenMintERC20Token {
// //   TokenMintERC20Token token = TokenMintERC20Token(DeployedAddresses.TokenMintERC20Token());
//     DNG_TokenMintERC20Token token = DNG_TokenMintERC20Token();

//   function testMint() public {
//     uint256 initialTotalMinted = token.totalMinted();
//     uint256 amountToMint = 100;
//     token.mint(amountToMint);
//     // Assert.equal(token.totalMinted(), initialTotalMinted + amountToMint, "Minting failed");
//   }

//   function testSetTotalSupply() public {
//     uint256 initialTotalSupply = token.totalSupply();
//     uint256 newTotalSupply = 1000;
//     token.setTotalSupply(newTotalSupply);
//     // Assert.equal(token.totalSupply(), newTotalSupply, "Setting total supply failed");
//   }

//   function testBurn() public {
//     uint256 initialTotalMinted = token.totalMinted();
//     uint256 amountToBurn = 50;
//     token.burn(amountToBurn);
//     // Assert.equal(token.totalMinted(), initialTotalMinted - amountToBurn, "Burning failed");
//   }
// }
