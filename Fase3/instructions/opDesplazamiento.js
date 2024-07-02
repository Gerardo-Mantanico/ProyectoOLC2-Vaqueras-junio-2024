class opDesplazamiento extends Instruction {

    constructor(line, col, id, operador, op1, op2, op3) {
        super();
        this.line = line;
        this.col = col;
        this.id=id;
        this.operador = operador.trim().toLowerCase();
        this.op1=op1;
        this.op2=op2;
        this.op3=op3;
    }

    execute(ast, env, gen, index, inst){
        let obj=this.obtenerValor(ast,env,gen,this.op2);
        let bin=obj?.value?? obj;
        obj=this.obtenerValor(ast,env,gen,this.op3);
        let desplazamiento = obj?.value?? obj;
        let num=parseInt(bin.slice(2), 2);
        let newValue="";
        let desp;
        if (this.operador === "asr") {
            desp = num >> desplazamiento;
            newValue =  desp;
            console.log("0b" + "0".repeat(desplazamiento) + desp.toString(2));
        }else if(this.operador === "lsr"){
            desp = num >>> desplazamiento;
            newValue =  desp;
            console.log("0b" + "0".repeat(desplazamiento) + desp.toString(2));
        }
        else if(this.operador === "lsl"){
            desp = num << desplazamiento;
            newValue =  desp;
            console.log("0b" + "0".repeat(desplazamiento) + desp.toString(2));
        }else if(this.operador === "ror"){
            newValue=this.ror(num,desplazamiento);
        }
        let setReg = ast.registers?.setRegister32(this.op1, newValue);
        if (setReg === null) ast.setNewError({ msg: `El registro de destino ${this.r1} es incorrecto.`, line: this.linea, col: this.columna });
        return index;
    }
    ror(num, bits){
        const totalBits = 64; // Trabajamos con enteros de 32 bits
        bits = bits % totalBits; // Aseguramos que bits esté dentro del rango de 0 a 31
        return (num >>> bits) | (num << (totalBits - bits));
    }
    obtenerValor(ast, env, gen, op) {
        if (op instanceof Expression) {
            return op?.execute(ast, env, gen);
        } else {
            let valor = ast.registers?.getRegister(op);
            if (valor === null) valor = ast.registers?.getRegister32(op);
            return valor;
        }
    }
}