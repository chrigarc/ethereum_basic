pragma solidity ^0.4.24;

contract Tickets{


    uint32 cantidad;
    mapping(address => uint32) compras;
    address chairperson;
    uint price;

    constructor(uint32 cant, uint _price) public {
        cantidad = cant;
        chairperson = msg.sender;
        price = _price;
    }

    event ReembolsoRealizado(address destino, uint32 c);
    event ReembolsoRechazado(address destino, uint32 c);

    modifier onlyOwner {
        require(msg.sender == chairperson);
        _;
    }

    function disponibles() view public returns (uint32){
        if(cantidad>0){
            return cantidad;
        }
        return 0;
    }

    function suficientes(uint32 c, uint costo) view private returns (bool){
        return (cantidad-c) > 0 && (costo == price*c);
    }

    function comprados() view public returns(uint32){
        return compras[msg.sender];
    }

    function comprar(uint32 c) payable public {
        require(suficientes(c, msg.value));
        chairperson.transfer(msg.value);
        cantidad -= c;
        compras[msg.sender]+=c;
    }

    function reembolso(address destino, uint32 c) onlyOwner payable public returns (bool){
        if(compras[destino]>0 && compras[destino]>=c){
            bool s = destino.send(price*c);
            if(s){
                emit ReembolsoRealizado(destino, c);
                cantidad+=c;
                compras[destino]-=c;
            }else{
                emit ReembolsoRechazado(destino, c);
            }
            return s;
        }
        return false;
    }

    function destruir () onlyOwner public {
        selfdestruct(chairperson);
    }
}
