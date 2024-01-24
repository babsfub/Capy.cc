pragma solidity ^0.8.0;



contract FDP is ERC20, Ownable {
  address public deployer;
  address public lpAddress;
  mapping(address => bool) public blacklists;
  mapping (address => address) public pyramid;
  mapping (address => address[]) public dimaryp;
  uint16[] public fees = [3333, 5000, 5000, 5000, 5000];
  uint16 sellFee = 666;
  uint8 private _depth = 0;

  event Ref(address referred, address referrer);
  event Blacklist(address user, bool isBlacklisted);

  constructor(uint256 _totalSupply) ERC20("FDP Coin", "FDP") {
    _mint(msg.sender, _totalSupply);
    pyramid[msg.sender] = address(this);
  }

  function burnFee() internal {
    uint bal = balanceOf(address(this));
    if (bal > 0)
      _burn(address(this), bal);
  }

  function countRef(address _address) public view returns (uint256) {
    return dimaryp[_address].length;
  }

  function setRef(address _ref) public {
    require(msg.sender != deployer, "Deployer cannot set referrer");
    require(pyramid[msg.sender] == address(0), "Referrer already set");
    require(pyramid[_ref] != address(0), "Referrer does not exist");
    pyramid[msg.sender] = _ref;
    dimaryp[_ref].push(msg.sender);
    burnFee();
    emit Ref(msg.sender, _ref);
  }

  function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
    blacklists[_address] = _isBlacklisting;
    uint256 bal = balanceOf(_address);
    _burn(_address, bal);
    emit Blacklist(_address, _isBlacklisting);
  }

  function setLP(address _lpAddress) external onlyOwner {
    require(lpAddress == address(0), "LP already set");
    lpAddress = _lpAddress;
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256
  ) override internal virtual {
    require(!blacklists[to] && !blacklists[from], "Blacklisted");

    if (lpAddress == address(0)) {
      require(from == owner() || to == owner(), "trading is not started");
      return;
    }
  }

  function _afterTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) override internal virtual {
    if (
      lpAddress == address(0)
      || from == to
      || to == address(this)
      || to == address(0)
      || from == address(0)
      || _depth > 4
    ) {
      _depth = 0;
      return;
    }
    address ref = pyramid[to];
    uint fee = amount * fees[_depth] / 10000;
    if (ref == address(0) || blacklists[ref]) {
      ref = address(this);
      fee *= 2;
    }
    if (to == lpAddress)
      fee = amount * sellFee / 10000;
    if (_depth == 4)
      _depth = 0;
    else {
      _depth++;
      _transfer(to, ref, fee);
    }
    burnFee();
  }

  function burn(uint256 value) external {
    _burn(msg.sender, value);
    burnFee();
  }
}