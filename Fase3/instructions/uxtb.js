class Uxtb extends Instruction{
    constructor(linea, columna, id, op1, op2, op3){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.op1=op1;
        this.op2=op2;
        this.op3=op3;
    }

    async execute(ast, env, gen, index, inst){
        gen.addQuadruple("UXTB", this.op2, this.op3, null, this.op1);
        if(this.op3===null){//uxtb w1, x0

            let newValue
            // Validar tipo de valor
            if(this.value instanceof Expression) newValue = this.op2?.execute(ast, env, gen);
            else newValue = ast.registers?.getRegister(this.op2);
            if(newValue===null) newValue = ast.registers?.getRegister32(this.op2);
            // Validaciones
            if (newValue === null) ast.setNewError({ msg: `El valor de asignación es incorrecto.`, line: this.line, col: this.col});
            // Set register
            let setReg = ast.registers?.setRegister(this.op1, newValue);
            if(setReg===null)setReg = ast.registers?.setRegister32(this.op1, newValue);
            if (setReg === null) ast.setNewError({ msg: `El registro de destino es incorrecto.`, line: this.line, col: this.col});
        
        }
        return index;
    }
}