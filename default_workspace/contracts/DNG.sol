// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/cryptography/ECDSA.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol";

contract DNG {
    uint256 public totalSupply = 1e12;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    // mapping(address => mapping(address => uint256)) private allowances;

    mapping (bytes32 => bytes) private dataStorage;
    mapping(bytes32 => bytes) private data2;
    bytes32 private dataHash;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event StoreData(address indexed owner, bytes32 indexed dataHash);
    
    // constructor
    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value && _value > 0, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance2(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value, "Insufficient balance or allowance");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transferFrom2(address _from, address _to, uint256 _value) public {
        require(balanceOf[_from] >= _value, "Not enough balance");
        require(allowance[_from][msg.sender] >= _value, "Not enough allowance");
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
    // function storeData2(bytes memory _data) public {
    //     require(_data.length <= 10485760, "Data size exceeds 10MB limit");
    //     dataHash = keccak256(_data);
    //     dataStorage[dataHash] = _data;
    // }
    function storeData2(bytes memory data, bytes32 dataHash) public {
        require(data.length <= 10 * 1024 * 1024, "Data size exceeds the limit of 10MB");
        dataStorage[dataHash] = data;
        emit StoreData(msg.sender, dataHash);
    }
    function storeData3(bytes memory _data2) public {
        bytes32 dataHash = sha256(_data2);
        data2[dataHash] = _data2;
    }

    function storeData(bytes memory data) public {
        require(data.length <= 10 * 1024 * 1024, "Data size exceeds the limit of 10MB");
        // binary conversion
        bytes32 binaryData = bytes32(data);
        // encryption method
        bytes memory encodedData = abi.encodePacked(binaryData);
        binaryData = keccak256(encodedData);
        // store the data in the blockchain
        bytes32 dataHash = binaryData;
        emit StoreData(msg.sender, dataHash);
    }
    function uploadData(bytes memory data) public {
        require(data.length <= 10485760, "Data size exceeds 10MB limit");
        dataHash = keccak256(data);
        dataStorage[dataHash] = data;
    }

    function getDataHash() public view returns (bytes32) {
        return dataHash;
    }

    function getData(bytes32 hash) public view returns (bytes memory) {
        return dataStorage[hash];
    }   

    function getData2(bytes32 _dataHash) public view returns (bytes memory) {
        return data2[_dataHash];
    }

}


// pragma solidity ^0.8.0;

// contract DNG {
//     uint256 public totalSupply = 1e12;
//     mapping (address => uint256) public balanceOf;
//     mapping (address => mapping (address => uint256)) public allowance;
    
//     // Events
//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event Approval(address indexed owner, address indexed spender, uint256 value);
    
//     // constructor
//     constructor() public {
//         balanceOf[msg.sender] = totalSupply;
//     }
    
//     function transfer(address _to, uint256 _value) public returns (bool) {
//         require(balanceOf[msg.sender] >= _value && _value > 0, "Insufficient balance");
//         balanceOf[msg.sender] -= _value;
//         balanceOf[_to] += _value;
//         emit Transfer(msg.sender, _to, _value);
//         return true;
//     }
    
//     function approve(address _spender, uint256 _value) public returns (bool) {
//         allowance[msg.sender][_spender] = _value;
//         emit Approval(msg.sender, _spender, _value);
//         return true;
//     }
    
//     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
//         require(balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value, "Insufficient balance or allowance");
//         balanceOf[_from] -= _value;
//         balanceOf[_to] += _value;
//         allowance[_from][msg.sender] -= _value;
//         emit Transfer(_from, _to, _value);
//         return true;
//     }
    
//     function storeData(bytes memory data) public {
//         require(data.length <= 10 * 1024 * 1024, "Data size exceeds the limit of 10MB");
//         // binary conversion
//         bytes32 binaryData = bytes32(data);
//         // encryption method can be added here
//         // ...
//         // store the data in the blockchain
//         // ...
//     }
// }
