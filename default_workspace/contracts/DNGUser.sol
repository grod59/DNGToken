// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./DNG.sol";

contract DNGUser {
    DNG public dng;

    constructor() public {
        dng = new DNG();
    }

    function testTransfer() public {
        // Check initial balance of Alice
        uint256 initialAliceBalance = dng.balanceOf(address(this));

        // Transfer 100 tokens from Alice to Bob
        address bob = address(0x1234567890123456789012345678901234567890);
        dng.transfer(bob, 100);

        // Check final balance of Alice
        uint256 finalAliceBalance = dng.balanceOf(address(this));

        // Ensure that Alice's balance decreased by 100
        // assert(initialAliceBalance - 100 == finalAliceBalance, "Alice's balance should decrease by 100");
    }

    function testApprove() public {
        // Check initial allowance of Alice
        address spender = address(0x1234567890123456789012345678901234567890);
        uint256 initialAllowance = dng.allowance(address(this), spender);

        // Approve 100 tokens to be spent by Bob
        dng.approve(spender, 100);

        // Check final allowance of Alice
        uint256 finalAllowance = dng.allowance(address(this), spender);

        // Ensure that Alice's allowance increased by 100
        // assert(initialAllowance + 100 == finalAllowance, "Alice's allowance should increase by 100");
    }

    function testTransferFrom() public {
        // Check initial balance of Bob
        address bob = address(0x1234567890123456789012345678901234567890);
        uint256 initialBobBalance = dng.balanceOf(bob);

        // Transfer 100 tokens from Alice to Bob using allowance
        dng.transferFrom(address(this), bob, 100);

        // Check final balance of Bob
        uint256 finalBobBalance = dng.balanceOf(bob);

        // Ensure that Bob's balance increased by 100
        // assert(initialBobBalance + 100 == finalBobBalance, "Bob's balance should increase by 100");
    }

    function testStoreData() public {
        // Store data
        bytes memory data = "This is some test data";
        dng.storeData(data);

        // Get data hash
        bytes32 dataHash = dng.getDataHash();

        // Get stored data
        bytes memory storedData = dng.getData(dataHash);

        // Ensure that the stored data matches the original data
        // assert(storedData == data, "Stored data should match original data");
    }
}

contract DNGUser2 {
    DNG dng = new DNG();

    address alice = address(0x1234567890123456789012345678901234567890);
    address bob = address(0x2345678901234567890123456789012345678901);
    address charlie = address(0x3456789012345678901234567890123456789012);

    function testTransfer() public {
        uint256 initialAliceBalance = dng.balanceOf(alice);
        dng.transfer(bob, 100);
        uint256 finalAliceBalance = dng.balanceOf(alice);
        uint256 bobBalance = dng.balanceOf(bob);

        // assert.equal(initialAliceBalance - 100, finalAliceBalance, "Alice's balance should decrease by 100");
        // assert.equal(bobBalance, 100, "Bob's balance should be 100");
    }

    function testApprove() public {
        dng.approve(charlie, 200);
        uint256 charlieAllowance = dng.allowance(alice, charlie);
        // assert.equal(charlieAllowance, 200, "Charlie's allowance should be 200");
    }

    function testTransferFrom() public {
        uint256 initialAliceBalance = dng.balanceOf(alice);
        uint256 initialCharlieBalance = dng.balanceOf(charlie);
        dng.transferFrom(alice, charlie, 200);
        uint256 finalAliceBalance = dng.balanceOf(alice);
        uint256 finalCharlieBalance = dng.balanceOf(charlie);

        // assert.equal(initialAliceBalance - 200, finalAliceBalance, "Alice's balance should decrease by 200");
        // assert.equal(finalCharlieBalance, initialCharlieBalance + 200, "Charlie's balance should increase by 200");
    }

    function testStoreData() public {
        bytes32 dataHash;
        dng.storeData("Hello, World!");
        // dng.storeData("Hello, World!", dataHash);
        // assert.equal(dataHash, keccak256("Hello, World!"), "Data hash should match");
    }

    function testGetDataHash() public {
        bytes32 dataHash = dng.getDataHash();
        // assert.equal(dataHash, keccak256("Hello, World!"), "Data hash should match");
    }

    function testGetData() public {
        bytes32 dataHash = dng.getDataHash();
        bytes memory data = dng.getData(dataHash);
        // assert.equal(data, "Hello, World!", "Data should match");
    }
}

// pragma solidity ^0.8.0;

// import "./DNG.sol";

contract DNGUser3 {
    // DNG dng;

    DNG dng = new DNG();

    // constructor() public {
    //     dng = DNG(0x123456);
    // }

    function testTransfer() public {
        uint256 initialAliceBalance = dng.balanceOf(address(this));
        uint256 initialBobBalance = dng.balanceOf(address(0x234567));
        dng.transfer(address(0x234567), 100);
        uint256 finalAliceBalance = dng.balanceOf(address(this));
        uint256 finalBobBalance = dng.balanceOf(address(0x234567));
        // assert.equal(initialAliceBalance - 100, finalAliceBalance, "Alice's balance should decrease by 100");
        // assert.equal(initialBobBalance + 100, finalBobBalance, "Bob's balance should increase by 100");
    }

    function testApprove() public {
        uint256 initialSpenderAllowance = dng.allowance(address(this), address(0x345678));
        dng.approve(address(0x345678), 200);
        uint256 finalSpenderAllowance = dng.allowance(address(this), address(0x345678));
        // assert.equal(initialSpenderAllowance + 200, finalSpenderAllowance, "Spender's allowance should increase by 200");
    }

    function testTransferFrom() public {
        uint256 initialOwnerBalance = dng.balanceOf(address(this));
        uint256 initialSpenderBalance = dng.balanceOf(address(0x456789));
        uint256 initialAllowance = dng.allowance(address(this), address(0x456789));
        dng.transferFrom(address(this), address(0x456789), 50);
        uint256 finalOwnerBalance = dng.balanceOf(address(this));
        uint256 finalSpenderBalance = dng.balanceOf(address(0x456789));
        uint256 finalAllowance = dng.allowance(address(this), address(0x456789));
        // assert.equal(initialOwnerBalance - 50, finalOwnerBalance, "Owner's balance should decrease by 50");
        // assert.equal(initialSpenderBalance + 50, finalSpenderBalance, "Spender's balance should increase by 50");
        // assert.equal(initialAllowance - 50, finalAllowance, "Allowance should decrease by 50");
    }

    function testStoreData() public {
        bytes32 dataHash;
        dng.storeData2("Hello, World!", dataHash);
        bytes memory storedData = dng.getData(dataHash);
        // assert.equal(storedData, "Hello, World!", "Stored data should be 'Hello, World!'");
    }
}

// contract DNGUser3 {
//     DNG dng = DNG(0x123456);

//     function testTransfer() public {
//         uint256 initialAliceBalance = dng.balanceOf(address(this));
//         uint256 initialBobBalance = dng.balanceOf(address(0x234567));
//         dng.transfer(address(0x234567), 100);
//         uint256 finalAliceBalance = dng.balanceOf(address(this));
//         uint256 finalBobBalance = dng.balanceOf(address(0x234567));
//         assert.equal(initialAliceBalance - 100, finalAliceBalance, "Alice's balance should decrease by 100");
//         assert.equal(initialBobBalance + 100, finalBobBalance, "Bob's balance should increase by 100");
//     }

//     function testApprove() public {
//         uint256 initialSpenderAllowance = dng.allowance(address(this), address(0x345678));
//         dng.approve(address(0x345678), 200);
//         uint256 finalSpenderAllowance = dng.allowance(address(this), address(0x345678));
//         assert.equal(initialSpenderAllowance + 200, finalSpenderAllowance, "Spender's allowance should increase by 200");
//     }

//     function testTransferFrom() public {
//         uint256 initialOwnerBalance = dng.balanceOf(address(this));
//         uint256 initialSpenderBalance = dng.balanceOf(address(0x456789));
//         uint256 initialAllowance = dng.allowance(address(this), address(0x456789));
//         dng.transferFrom(address(this), address(0x456789), 50);
//         uint256 finalOwnerBalance = dng.balanceOf(address(this));
//         uint256 finalSpenderBalance = dng.balanceOf(address(0x456789));
//         uint256 finalAllowance = dng.allowance(address(this), address(0x456789));
//         assert.equal(initialOwnerBalance - 50, finalOwnerBalance, "Owner's balance should decrease by 50");
//         assert.equal(initialSpenderBalance + 50, finalSpenderBalance, "Spender's balance should increase by 50");
//         assert.equal(initialAllowance - 50, finalAllowance, "Allowance should decrease by 50");
//     }

//     function testStoreData() public {
//         bytes32 dataHash;
//         dng.storeData("Hello, World!", dataHash);
//         bytes memory storedData = dng.getData(dataHash);
//         assert.equal(storedData, "Hello, World!", "Stored data should be 'Hello, World!'");
//     }
// }

// pragma solidity ^0.8.0;

// import "./DNG.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/test/TestHelper.sol";

// contract DNGUser is TestHelper {
//     DNG public dng;

//     constructor() public {
//         dng = new DNG();
//     }

//     function testTransfer() public {
//         uint256 initialAliceBalance = dng.balanceOf(address(this));
//         uint256 initialBobBalance = dng.balanceOf(address(0x0));
//         dng.transfer(address(0x0), 100);
//         uint256 finalAliceBalance = dng.balanceOf(address(this));
//         uint256 finalBobBalance = dng.balanceOf(address(0x0));
//         assert(initialAliceBalance - 100 == finalAliceBalance, "Alice's balance should decrease by 100");
//         assert(initialBobBalance + 100 == finalBobBalance, "Bob's balance should increase by 100");
//     }

//     function testApprove() public {
//         uint256 initialAllowance = dng.allowance(address(this), address(0x0));
//         dng.approve(address(0x0), 200);
//         uint256 finalAllowance = dng.allowance(address(this), address(0x0));
//         assert(initialAllowance + 200 == finalAllowance, "Allowance should increase by 200");
//     }

//     function testTransferFrom() public {
//         uint256 initialSenderBalance = dng.balanceOf(address(this));
//         uint256 initialReceiverBalance = dng.balanceOf(address(0x0));
//         dng.approve(address(0x0), 200);
//         dng.transferFrom(address(this), address(0x0), 100);
//         uint256 finalSenderBalance = dng.balanceOf(address(this));
//         uint256 finalReceiverBalance = dng.balanceOf(address(0x0));
//         assert(initialSenderBalance - 100 == finalSenderBalance, "Sender's balance should decrease by 100");
//         assert(initialReceiverBalance + 100 == finalReceiverBalance, "Receiver's balance should increase by 100");
//     }

//     function testUploadData() public {
//         bytes32 hash = keccak256("Test Data");
//         dng.uploadData("Test Data");
//         bytes memory storedData = dng.getData(hash);
//         assert(storedData == "Test Data", "Stored data should match the uploaded data");
//     }

// }



// pragma solidity ^0.8.0;
// import "./DNG.sol";

// contract DNGUser {
//     DNG dng = new DNG();

//     address alice = address(0x1234567890123456789012345678901234567890);
//     address bob = address(0x2345678901234567890123456789012345678901);
//     address charlie = address(0x3456789012345678901234567890123456789012);

//     function testTransfer() public {
//         uint256 initialAliceBalance = dng.balanceOf(alice);
//         dng.transfer(bob, 100);
//         uint256 finalAliceBalance = dng.balanceOf(alice);
//         uint256 bobBalance = dng.balanceOf(bob);

//         assert.equal(initialAliceBalance - 100, finalAliceBalance, "Alice's balance should decrease by 100");
//         assert.equal(bobBalance, 100, "Bob's balance should be 100");
//     }

//     function testApprove() public {
//         dng.approve(charlie, 200);
//         uint256 charlieAllowance = dng.allowance(alice, charlie);
//         assert.equal(charlieAllowance, 200, "Charlie's allowance should be 200");
//     }

//     function testTransferFrom() public {
//         uint256 initialAliceBalance = dng.balanceOf(alice);
//         uint256 initialCharlieBalance = dng.balanceOf(charlie);
//         dng.transferFrom(alice, charlie, 200);
//         uint256 finalAliceBalance = dng.balanceOf(alice);
//         uint256 finalCharlieBalance = dng.balanceOf(charlie);

//         assert.equal(initialAliceBalance - 200, finalAliceBalance, "Alice's balance should decrease by 200");
//         assert.equal(finalCharlieBalance, initialCharlieBalance + 200, "Charlie's balance should increase by 200");
//     }

//     function testStoreData() public {
//         bytes32 dataHash;
//         dng.storeData("Hello, World!", dataHash);
//         assert.equal(dataHash, keccak256("Hello, World!"), "Data hash should match");
//     }

//     function testGetDataHash() public {
//         bytes32 dataHash = dng.getDataHash();
//         assert.equal(dataHash, keccak256("Hello, World!"), "Data hash should match");
//     }

//     function testGetData() public {
//         bytes32 dataHash = dng.getDataHash();
//         bytes memory data = dng.getData(dataHash);
//         assert.equal(data, "Hello, World!", "Data should match");
//     }
// }




// pragma solidity ^0.8.0;

// import "./DNG.sol";

// contract DNGUserTest {
//     DNG public dng;


//     constructor(address _dngAddress) public {
//         dng = DNG(_dngAddress);
//     }

//     function testUploadData() public {
//         uint256 dataSize = 10485760;
//         bytes memory data = new bytes(dataSize);
//         for (uint256 i = 0; i < dataSize; i++) {
//             // data[i] = byte(i % 256);
//             data[i] = uint256(i % 256);
//         }
//         dng.uploadData(data);
//         bytes32 dataHash = dng.getDataHash();
//         require(keccak256(data) == dataHash, "uploaded data hash mismatch");
//     }

//     function testStoreData() public {
//         uint256 dataSize = 10_000_000; // 10 MB
//         bytes memory data = new bytes(dataSize);
//         for (uint256 i = 0; i < dataSize; i++) {
//             // data[i] = uint8(i % 256);
//             data[i] = byte(i % 256);
//         }
//         uint256 result = dng.storeData(data);
//         require(result == dataSize, "Store data failed");
//         // emit LogStoreData(data);
//     }

//     function testGetHash() public {
//         bytes32 dataHash = dng.getDataHash();
//         bytes memory storedData = dng.getData(dataHash);
//         require(storedData.length == 10485760, "retrieved data length mismatch");
//     }

//     function testGetData(uint256 index) public view returns (bytes memory) {
//         return dng.getData(index);
//     }
// }

// pragma solidity ^0.8.0;
// import "./DNG.sol";

// // npm install solidity-test-environment;

// // import "solidity-test-environment/TestEnvironment.sol";

// contract DNGUserTest2{
//     DNG public dng;

// // contract DNGUserTest {
// //     DNG public dng;


//     constructor(address _dngAddress) public {
//         dng = DNG(_dngAddress);
//     }


//     // function testTransfer() public {
//     //     address recipient = address(this);
//     //     uint256 value = 100;
//     //     address sender = address(0x0);
//     //     dng.transfer(recipient, value);
//     //     require(dng.balanceOf(recipient) == value, "Transfer failed");
//     //     emit LogTransfer(sender, recipient, value);
//     // }

//     // function testApprove() public {
//     //     address spender = address(this);
//     //     uint256 value = 100;
//     //     address owner = address(0x0);
//     //     dng.approve(spender, value);
//     //     require(dng.allowance[owner][spender] == value, "Approve failed");
//     //     emit LogApprove(owner, spender, value);
//     // }

//     // function testTransferFrom() public {
//     //     address from = address(0x0);
//     //     address to = address(this);
//     //     uint256 value = 100;
//     //     dng.transferFrom(from, to, value);
//     //     require(dng.balanceOf(to) == value, "TransferFrom failed");
//     //     emit LogTransferFrom(from, to, value);
//     // }

//     // // function testStoreData() public {
//     // //     bytes memory data = "Test Data";
//     // //     dng.storeData(data);
//     // //     require(keccak256(data) == dng.getData(0), "Store Data failed");
//     // //     emit LogStoreData(data);
//     // // }
//     function testStoreData() public {
//         uint256 dataSize = 10_000_000; // 10 MB
//         bytes memory data = new bytes(dataSize);
//         for (uint256 i = 0; i < dataSize; i++) {
//             data[i] = uint8(i % 256);
//         }
//         uint256 result = dng.storeData(data);
//         require(result == dataSize, "Store data failed");
//         emit LogStoreData(data);
//     }

//     function testGetData(uint256 index) public view returns (bytes memory) {
//         return dng.getData(index);
//     }

//     function testGetBalance() public {
//         address owner = address(0x0);
//         uint256 balance = dng.balanceOf(owner);
//         require(balance > 0, "Get balance failed");
//         emit LogGetBalance(owner, balance);
//     }

//     function testGetAllowance() public {
//         address owner = address(0x0);
//         address spender = address(this);
//         uint256 allowance = dng.allowance[owner][spender];
//         require(allowance > 0, "Get allowance failed");
//         emit LogGetAllowance(owner, spender, allowance);
//     }

//     event LogTransfer(address sender, address recipient, uint256 value);
//     event LogApprove(address owner, address spender, uint256 value);
//     event LogTransferFrom(address from, address to, uint256 value);
//     event LogStoreData(bytes data);
//     event LogGetBalance(address owner, uint256 balance);
//     event LogGetAllowance(address owner, address spender, uint256 value);
// }

// pragma solidity ^0.8.0;

// import "./DNG.sol";

// contract DNGUserTest {
//     DNG public dng;


//     constructor(address _dngAddress) public {
//         dng = DNG(_dngAddress);
//     }

//     // function testUploadData() public {
//     //     uint256 dataSize = 10485760;
//     //     bytes memory data = new bytes(dataSize);
//     //     for (uint256 i = 0; i < dataSize; i++) {
//     //         data[i] = byte(i % 256);
//     //     }
//     //     dng.uploadData(data);
//     //     bytes32 dataHash = dng.getDataHash();
//     //     require(keccak256(data) == dataHash, "uploaded data hash mismatch");
//     // }

//     function testStoreData() public {
//         uint256 dataSize = 10_000_000; // 10 MB
//         bytes memory data = new bytes(dataSize);
//         for (uint256 i = 0; i < dataSize; i++) {
//             data[i] = uint8(i % 256);
//         }
//         uint256 result = dng.storeData(data);
//         require(result == dataSize, "Store data failed");
//         // emit LogStoreData(data);
//     }
//     function testGetData() public {
//         bytes32 dataHash = dng.getDataHash();
//         bytes memory storedData = dng.getData(dataHash);
//         require(storedData.length == 10485760, "retrieved data length mismatch");
//     }

// //     function testGetData(uint256 index) public view returns (bytes memory) {
// //         return dng.getData(index);
// //     }
// }


// pragma solidity ^0.8.0;

// import "./DNG.sol";

// contract DNGUserTest {
//     DNG private dng;

//     constructor() public {
//         dng = new DNG();
//     }

//     function testUploadData() public {
//     uint256 dataSize = 10485760;
//     bytes memory data = new bytes(dataSize);
//     for (uint256 i = 0; i < dataSize; i++) {
//         data[i] = byte(i % 256);
//     }
//     dng.uploadData(data);
//     bytes32 dataHash = dng.getDataHash();
//     require(keccak256(data) == dataHash, "uploaded data hash mismatch");
//     }

//     function testGetData() public {
//         bytes32 dataHash = dng.getDataHash();
//         bytes memory storedData = dng.getData(dataHash);
//         require(storedData.length == 10485760, "retrieved data length mismatch");
//     }

// }


// pragma solidity ^0.8.0;

// import "./DNG.sol";

// contract DNGUserTest {
//     address owner;
//     DNG dng;

//     constructor() public {
//         owner = msg.sender;
//         dng = new DNG();
//     }

//     function testUploadData() public {
//         uint256 dataSize = 10 * 1024 * 1024; // 10 MB
//         uint256[] memory data = new uint256[](dataSize / 32);
//         for (uint256 i = 0; i < data.length; i++) {
//             data[i] = i;
//         }

//         dng.uploadData(data);

//         uint256[] memory storedData = dng.getData();
//         assert(storedData.length == data.length, "Data length mismatch");
//         for (uint256 i = 0; i < storedData.length; i++) {
//             assert(storedData[i] == data[i], "Data mismatch at index " + i);
//         }
//     }
// }

// nee tuffle env
// pragma solidity ^0.8.0;
// import "./DNG.sol";

// // npm install solidity-test-environment;

// import "solidity-test-environment/TestEnvironment.sol";

// contract DNGUserTest is TestEnvironment {
//     DNG public dng;

// // contract DNGUserTest {
// //     DNG public dng;


//     constructor(address _dngAddress) public {
//         dng = DNG(_dngAddress);
//     }


//     function testTransfer() public {
//         address recipient = address(this);
//         uint256 value = 100;
//         address sender = address(0x0);
//         dng.transfer(recipient, value);
//         require(dng.balanceOf(recipient) == value, "Transfer failed");
//         emit LogTransfer(sender, recipient, value);
//     }

//     function testApprove() public {
//         address spender = address(this);
//         uint256 value = 100;
//         address owner = address(0x0);
//         dng.approve(spender, value);
//         require(dng.allowance[owner][spender] == value, "Approve failed");
//         emit LogApprove(owner, spender, value);
//     }

//     function testTransferFrom() public {
//         address from = address(0x0);
//         address to = address(this);
//         uint256 value = 100;
//         dng.transferFrom(from, to, value);
//         require(dng.balanceOf(to) == value, "TransferFrom failed");
//         emit LogTransferFrom(from, to, value);
//     }

//     // function testStoreData() public {
//     //     bytes memory data = "Test Data";
//     //     dng.storeData(data);
//     //     require(keccak256(data) == dng.getData(0), "Store Data failed");
//     //     emit LogStoreData(data);
//     // }
//     function testStoreData() public {
//         uint256 dataSize = 10_000_000; // 10 MB
//         bytes memory data = new bytes(dataSize);
//         for (uint256 i = 0; i < dataSize; i++) {
//             data[i] = uint8(i % 256);
//         }
//         uint256 result = dng.storeData(data);
//         require(result == dataSize, "Store data failed");
//         emit LogStoreData(data);
//     }

//     function testGetData(uint256 index) public view returns (bytes memory) {
//         return dng.getData(index);
//     }

//     function testGetBalance() public {
//         address owner = address(0x0);
//         uint256 balance = dng.balanceOf(owner);
//         require(balance > 0, "Get balance failed");
//         emit LogGetBalance(owner, balance);
//     }

//     function testGetAllowance() public {
//         address owner = address(0x0);
//         address spender = address(this);
//         uint256 allowance = dng.allowance[owner][spender];
//         require(allowance > 0, "Get allowance failed");
//         emit LogGetAllowance(owner, spender, allowance);
//     }

//     event LogTransfer(address sender, address recipient, uint256 value);
//     event LogApprove(address owner, address spender, uint256 value);
//     event LogTransferFrom(address from, address to, uint256 value);
//     event LogStoreData(bytes data);
//     event LogGetBalance(address owner, uint256 balance);
//     event LogGetAllowance(address owner, address spender, uint256 value);
// }

// pragma solidity ^0.8.0;

// import "./DNG.sol";

// contract DNGUser {
//     DNG public dng;
    
//     constructor(address _dngAddress) public {
//         dng = DNG(_dngAddress);
//     }
    
//     function transfer(address _to, uint256 _value) public returns (bool) {
//         return dng.transfer(msg.sender, _value);
//     }
    
//     function approve(address _spender, uint256 _value) public returns (bool) {
//         return dng.approve(msg.sender, _value);
//     }
    
//     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
//         return dng.transferFrom(_from, _to, _value);
//     }
    
//     function storeData(bytes memory data) public {
//         dng.storeData(data);
//     }
    
//     function getBalance(address _owner) public view returns (uint256) {
//         return dng.balanceOf(_owner);
//     }
    
//     function getAllowance(address _owner, address _spender) public view returns (uint256) {
//         return dng.allowance[_owner][_spender];
//     }
// }
