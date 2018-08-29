pragma solidity ^0.4.24;


contract Seguro{

    struct Asegurado {
        address beneficiario;
        bool vivo;
        bool pagado;
    }

    address juez;
    address owner;
    uint monto;
    uint costo;

    mapping(address => Asegurado) asegurados;

    constructor() public {
        monto = 5 ether;
        costo = 1 ether;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyJudge {
        require(msg.sender == juez);
        _;
    }

    function contratar(address beneficiario) payable public returns(bool){
        if(owner.send(costo)){
            Asegurado storage sender = asegurados[msg.sender];
            sender.beneficiario = beneficiario;
            sender.vivo = true;
            sender.pagado = false;
            return true;
        }
        return false;
    }

    function setJuez(address j) onlyOwner public {
        juez = j;
    }

    function setVivo(address asegurado, bool v) onlyJudge public {
        if(!v){
            asegurados[asegurado].vivo = false;
            asegurados[asegurado].pagado = false;
        }
    }

    function pagar(address asegurado) onlyOwner payable public returns(bool){
        if(msg.value == monto && !asegurados[asegurado].vivo && !asegurados[asegurado].pagado){
            if(asegurados[asegurado].beneficiario.send(msg.value)){
                asegurados[asegurado].pagado = true;
                return true;
            }
        }
        return false;
    }

}
