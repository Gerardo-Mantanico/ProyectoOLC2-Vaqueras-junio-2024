class LogicOperation extends Instruction{
    constructor(linea, columna, id,operacion, r1,r2,r3){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.operacion=operacion;
        this.r1=r1;
        this.r2=r2;
        this.r3=r3;
    }

    execute(ast, env, gen, index, inst){
        let obj=this.obtenerValor(ast,env,gen,this.r2);
        let num1 = obj?.value?? obj;

        obj=this.obtenerValor(ast,env,gen,this.r3);
        let num2 = obj?.value?? obj;

        let bin1 = this.binario(num1,this.linea,this.columna,8);
        let bin2 = this.binario(num2,this.linea,this.columna,8);

        let bms1=parseInt(bin1.substring(2),2);
        let bms2=parseInt(bin2.substring(2),2);
        let value=this.operacionLogica(env,this.operacion,bms1,bms2);
        if (value !== null) {
            let setReg = ast.registers?.setRegister(this.r1, value);
            if (setReg === null) setReg = ast.registers?.setRegister32(this.r1, value);
            if (setReg === null) ast.setNewError({ msg: `El registro de destino ${this.r1} es incorrecto.`, line: this.linea, col: this.columna });
        }
        return{
            Index:index,
            line: this.linea
        } 
        

    }

    operacionLogica(env,operacion, bms1, bms2) {
        operacion = operacion.trim().toLowerCase();
        if (operacion === "and") {
            return bms1 & bms2
        } else if (operacion === "orr") {
            return bms1 | bms2;
        } else if (operacion === "eor") {
            return bms1 ^ bms2;
        } else if (operacion === "bic") {
            return bms1 & ~bms2;
        }
        else if (operacion === "ands") {
            let result = bms1 & bms2;
            let resBin = result.toString(2);
            let msb = (result >> (resBin.length - 1)) & 1;//bit mas significativo
            env.Z = result===0? 1:0;
            env.N = msb===1? 1 :0;
            env.C=0;
            env.V=0;
           return result;
        }
        return null;  // En caso de que la operación no sea reconocida
    }
    

    binario(num, line, col, width){

        if (typeof num !== 'number' || !Number.isInteger(num)) {
            ast?.setNewError({ msg: `El texto ${num} no puede onvertirse a Binario.`, line, col});
            return null;
        }
        return '0b'+num.toString(2).padStart(width, '0');
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