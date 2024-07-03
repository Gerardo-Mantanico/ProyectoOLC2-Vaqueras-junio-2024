class Strb extends Instruction {

    constructor(line, col, id, reg, variable, numDesp) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.reg = reg;
        this.variable = variable;
        this.numDesp=numDesp;
    }

    execute(ast, env, gen, index, inst) {
        let ndesp=0;
        if(this.numDesp!=null){
            let val = this.obtenerValor(ast,env,gen,this.numDesp);
            ndesp=val?.value?? val;
        }
        if(this.reg.toLowerCase().includes("w")){//strb w1, [x0]
                let val = this.obtenerValor(ast,env,gen,this.reg);
              //  console.log(val);
                let character = String.fromCharCode(val?.value?? val);
                let sym =  ast.registers?.getRegister(this.variable);
                sym.type=Type.ASCIZ;
                let vs="";
                for (let index = 0; index < sym.value.length; index++) {
                    if(index===ndesp){
                        vs+=character;
                    }else{
                        vs+=sym.value[index];
                    }    
                }
                sym.value=vs;
                let setReg = ast.registers?.setRegister(this.variable, sym);
                if (setReg === null) ast.setNewError({ msg: `El registro de destino ${this.r1} es incorrecto.`, line: this.linea, col: this.columna });
        
        }

        return{
            Index:index,
            line: this.line
        } 
        
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