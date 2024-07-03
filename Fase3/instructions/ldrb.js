class Ldrb extends Instruction {

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
        // Obteniendo valor
        /*let newValue = env?.getVariable(ast, this.line, this.col, this.variable);
        // Validando retorno
        if (newValue.type === Type.NULL) return;
        // Set register
        let setReg = ast.registers?.setRegister(this.reg, newValue);
        if (setReg === null) ast.setNewError({ msg: `El registro de destino es incorrecto.`, line: this.line, col: this.col});
        */
       if(this.numDesp===null){//lsrb w1, [x0]
            let valor;
            valor=ast.registers?.getRegister(this.variable);//si es un registro
            console.log("obteniendo valor "+valor);
            let puntero = valor?.puntero;
            const strValue=valor?.value?? valor;
            if(strValue.length<=puntero){//si lo que contiene esta vacio
                ast.setNewError({ msg: `El puntero del registrp ${this.variable} esta al limite.`, line: this.line, col: this.col});
            }else{
                console.log("que trae aca "+strValue[puntero]);
                let ascci = strValue[puntero].charCodeAt(0);
                let setReg = ast.registers?.setRegister32(this.reg, ascci);
                if (setReg === null) ast.setNewError({ msg: `El registro ${reg} de destino es incorrecto.`, line: this.line, col: this.col});
            }
     
       }
       return{
        Index:index,
        line: this.line
    } 
    
    }
}