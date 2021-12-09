pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    //This is to show how many products exist inside my mapping
    uint256 public productCount = 0;
    mapping(uint256 => Product) public products;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Amora Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        //Require a valid name
        require(bytes(_name).length > 0);
        //Require a valid price
        require(_price > 0);
        //Make sure parameters are correct
        //Increment Product Count
        productCount++;
        //Create the product
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );
        //Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint256 _id) public payable {
        // Fetch the Product
        Product memory _product = products[_id];
        // Fetch the owner
        address payable _seller = _product.owner;
        // Make sure the product has a valid _id
        require(_product.id > 0 && _product.id <= productCount);
        //Require that there is enough Ether in the transaction
        require(msg.value >= _product.price);
        //Require that the product has not been purchased already
        require(!_product.purchased);
        //Require That the buyer is not the _seller
        require(_seller != msg.sender);
        // Transfer ownership to the buyer
        _product.owner = msg.sender;
        //Mark as purchased
        _product.purchased = true;
        //update the product
        products[_id] = _product;
        //Pay the seller by sending them Ether
        address(_seller).transfer(msg.value);
        // trigger an event
        emit ProductPurchased(
            productCount,
            _product.name,
            _product.price,
            msg.sender,
            true
        );
    }
}
