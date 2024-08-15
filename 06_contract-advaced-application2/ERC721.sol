// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165{
    function supportsInterface(bytes4 interfaceID)
        external 
        view 
        returns(bool);
}

interface IERC721 is IERC165{
    /*
    功能：查询特定地址 _owner 拥有的 NFT 数量。
    参数：_owner：要查询的地址。
    返回值：返回该地址拥有的代币数量（uint256 类型）。
    */
    function balanceOf(address _owner)external view returns(uint256 balance); 
    
    /*
    功能：查询指定 tokenId 的 NFT 的当前所有者。
    参数：tokenId：要查询的 NFT 的唯一标识符。
    返回值：返回拥有该 NFT 的地址（address 类型）。
    */
    function ownerOf(uint256 tokenId)external view returns(address); 

    /*
    功能：安全地转移一个 NFT 从地址 _from 到地址 _to。
    参数：
        _from：当前拥有该 NFT 的地址。
        _to：目标地址，NFT 将转移到该地址。
        tokenId：要转移的 NFT 的唯一标识符。 
        注意：这会触发 ERC-721 标准中的 onERC721Received 回调函数，以确保 _to 地址能够正确接收 NFT。  
    */
    function safeTransferFrom(address _from, address _to, uint256 tokenId)external ;

    /*
    功能：安全地转移一个 NFT 从地址 _from 到地址 _to，并传递额外的数据。
    参数：
        _from：当前拥有该 NFT 的地址。
        _to：目标地址，NFT 将转移到该地址。
        tokenId：要转移的 NFT 的唯一标识符。
        data：附加的数据（bytes 类型），可以用于额外的信息传递。
    注意：与前一个函数类似，这会触发 onERC721Received 回调函数，但允许传递额外的数据。
    */
    function safeTransferFrom(address _from, 
        address _to, 
        uint256 tokenId, 
        bytes calldata data
    )external ;
    /*
    功能：转移一个 NFT 从地址 _from 到地址 _to。
    参数：
        _from：当前拥有该 NFT 的地址。
        _to：目标地址，NFT 将转移到该地址。
        tokenId：要转移的 NFT 的唯一标识符。
    注意：此函数不安全，因为它不检查目标地址是否能够接收 NFT，这可能会导致资产丢失。推荐使用 safeTransferFrom。
    */
    function TransferFrom(address _from, address _to, uint256 tokenId)external ;

    /*
    功能：授权 _to 地址可以转移 tokenId 对应的 NFT。
    参数：
        to：被授权的地址。
        tokenId：被授权的 NFT 的唯一标识符。
    注意：只允许 NFT 的所有者或被授权的操作员调用。    
    */
    function approve(address _to, uint256 tokenId)external ;

    /*
    功能：查询 tokenId 对应的 NFT 的当前授权地址。
    参数：
        tokenId：要查询的 NFT 的唯一标识符。
    返回值：返回被授权的地址（address 类型）。
    */
    function getApproved(uint256 tokenId) external view returns(address operator);

    /*
    功能：设置或取消对所有 NFT 的操作授权。 
    参数：
        operator：要授权或取消授权的地址。
        approved：授权标志（true 表示授权，false 表示取消授权）。
    注意：允许对所有 NFT 批量授权或撤销授权。    
    */
    function setApprovalsAll(address operator, bool approved) external;

    /*
    功能：查询 owner 地址是否授权了 operator 地址对其所有 NFT 进行操作。
    参数：
        owner：NFT 的拥有者地址。
        operator：要查询的操作员地址。
        返回值：返回 true 表示授权，false 表示未授权。  
    */
    function isApprovalsAll(address owner,address operator) external returns(bool);
}

interface IERC721Reciever{
    /*
    onERC721Received 是 ERC-721 标准中定义的一个回调函数，主要用于确保在安全地转移 NFT（不可替代代币）时，
    目标合约能够正确处理这些代币。这是为了保证 NFT 在转移过程中不会被丢失或无法处理。    
    */
    function OnIERC721Reciever(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    )external returns(bytes4);
}

contract ERC721 is IERC721{
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event Approved(address indexed owner, address indexed spender, uint256 indexed id);
    event ApprovedAll(address indexed owner, address indexed operator, bool indexed approved);

    // 定义状态变量
    // nft（tokenid）属于那个owner
    mapping(uint => address) internal _ownerOf;
    
    // 一个onwer拥有tokenid的数目,一个address有多个nft数量
    mapping(address => uint) internal _balanceOf;

    // 对应代NFT被哪个地址使用。
    mapping(uint => address) internal _approvals;

    // 某一个地址，可以调用所有地址的NFT
    mapping(address => mapping(address => bool)) public _approvalsForAll;

    function supportsInterface(bytes4 interfaceID)
        external 
        pure 
        returns(bool){
            return interfaceID == type(IERC721).interfaceId || interfaceID == type(IERC165).interfaceId;
        }

    function balanceOf(address _owner)external view returns(uint256 balance){
        require(_owner != address(0), "_owner == address 0");
        return _balanceOf[_owner];
    }

    function ownerOf(uint256 tokenId)external view returns(address){
        require(tokenId != 0, "tokenId ==  0");
        return _ownerOf[tokenId];
    }


    function setApprovalsAll(address operator, bool approved) external{
        _approvalsForAll[msg.sender][operator] = approved;
        emit ApprovedAll(msg.sender, operator, approved);
    }

    function approve(address _to, uint256 tokenId)external {
        address _owner = _ownerOf[tokenId];
        require(_owner != address(0) 
            || _approvalsForAll[_owner][msg.sender], 
            "Not authorize");
        _approvals[tokenId] = _to;
        emit Approved(msg.sender, _to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns(address operator){
        require(_ownerOf[tokenId] != address(0), "Token is not exists");
        return _approvals[tokenId];
    }

    function isApprovedOrOwner(address owner, address spender, uint256 tokenId)internal view returns(bool){
        return owner == spender
            || _approvalsForAll[owner][spender]
            || spender == _approvals[tokenId];
    }

    function TransferFrom(address _from, address _to, uint256 tokenId)public {
        require(_from != address(0) || _from == _ownerOf[tokenId], "_from not owner");
        require(_to != address(0), "_to is null");
        require(isApprovedOrOwner(msg.sender, _to, tokenId), "not allowed");
        _balanceOf[_from]--;
        _balanceOf[_to]++;
        _ownerOf[tokenId] = _to;

        delete _approvals[tokenId];
        emit Transfer(_from, _to, tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 tokenId)external {
        TransferFrom(_from, _to, tokenId);
        require(_to.code.length == 0 || IERC721Reciever(_to).OnIERC721Reciever(msg.sender, _from, tokenId, "") == IERC721Reciever.OnIERC721Reciever.selector, "unsafe reciept");
    }

    function safeTransferFrom(address _from, 
        address _to, 
        uint256 tokenId, 
        bytes calldata data
    )external{
             TransferFrom(_from, _to, tokenId);
        require(_to.code.length == 0 || IERC721Reciever(_to).OnIERC721Reciever(msg.sender, _from, tokenId, data) == IERC721Reciever.OnIERC721Reciever.selector, "unsafe reciept");
    }

    function isApprovalsAll(address owner,address operator) external returns(bool){
        return _approvalsForAll[owner][operator];
    }

    function _mint(address _to, uint256 tokenId ) public {
        require(_to != address(0), "address is zero");
        require(_ownerOf[tokenId] == address(0), "token is exists");

        _balanceOf[_to]++;
        _ownerOf[tokenId] = _to;
        emit Transfer(address(0), _to, tokenId);
    }

    function _burst(address _to, uint256 tokenId ) public {
        address _owner = _ownerOf[tokenId];
        require(_owner != address(0), "owner is not exists");

        _balanceOf[_to]--;
        delete _ownerOf[tokenId];
        delete _approvals[tokenId];
        emit Transfer(_owner, address(0),tokenId);
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint256 tokenId)external{
        _mint(to, tokenId);
    }

    function burst( uint256 tokenId)external{
        require(_ownerOf[tokenId] == msg.sender, "not owner");
        _burst(msg.sender, tokenId);
    }
}
