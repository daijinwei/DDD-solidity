// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractA {
    function foo()public pure virtual returns(string memory){
        return "A";
    }

    function bar()public pure virtual returns(string memory){
        return "A";
    }

}

contract ContractB is ContractA {
    function foo() public pure override returns(string memory){
        return "B";
    }

    function bar() public pure virtual override returns(string memory){
        return "B";
    }
}


contract ContractC is ContractB{
    function bar() public pure override  returns(string memory){
        return "C";
    }
}
