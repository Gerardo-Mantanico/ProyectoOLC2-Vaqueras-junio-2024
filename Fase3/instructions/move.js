class Move extends Instruction {

    constructor(line, col, id, obj, value) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.obj = obj;
        this.value = value;
    }

    execute(ast, env, gen, index, inst) {
        gen.addQuadruple("MOV", this.value?.value, null, null, this.obj);
        if(this.obj.toLowerCase().includes("w") && this.value.length===1){//es un caracter
            let setReg = ast.registers?.setRegister32(this.obj, this.value.charCodeAt(0));
            if (setReg === null) ast.setNewError({ msg: `El registro de destino es incorrecto.`, line: this.line, col: this.col});
        }else{
            let newValue
            // Validar tipo de valor
            if(this.value instanceof Expression) newValue = this.value?.execute(ast, env, gen);
            else newValue = ast.registers?.getRegister(this.value);
            // Validaciones
            if (newValue === null) ast.setNewError({ msg: `El valor de asignación es incorrecto.`, line: this.line, col: this.col});
            // Set register
            let setReg = ast.registers?.setRegister(this.obj, newValue);
            if(setReg===null)setReg = ast.registers?.setRegister32(this.obj, newValue);
            if (setReg === null) ast.setNewError({ msg: `El registro de destino es incorrecto.`, line: this.line, col: this.col});
        
        }
        console.log("ejecutando instrucciones en el indice: "+ index+ "  linea: "+ this.line+ " "+this.obj);
        return{
            Index:index,
            line: this.line
        } 
        
    }
}