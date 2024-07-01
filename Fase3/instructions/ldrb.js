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

    execute(ast, env, gen) {
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
            console.log(valor);
            const strValue=valor?.value?? valor;
            if(strValue.length===0){//si lo que contiene esta vacio
                ast.setNewError({ msg: `El registro ${this.variable} esta vacio por lo que no se puede agregar byte.`, line: this.line, col: this.col});
            }else{
                let ascci = strValue[0].charCodeAt(0);
                let setReg = ast.registers?.setRegister32(this.reg, ascci);
                if (setReg === null) ast.setNewError({ msg: `El registro ${reg} de destino es incorrecto.`, line: this.line, col: this.col});
            }
     
       }
    }
}