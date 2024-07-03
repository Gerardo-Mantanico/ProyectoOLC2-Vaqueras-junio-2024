class Declaration extends Instruction {

    constructor(line, col, id, name, type, exp) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.name = name;
        this.type = type;
        this.exp = exp;
    }

    execute(ast, env, gen, index, inst) {
        gen.addQuadruple(this.type, this.exp.getValue(), null, null, this.name);
        // Obtener valor
        let sym = this.exp.execute(ast, env, gen);
        // Validar tipo
        if(this.type !== sym?.type){
            if(!this.consideraciones(sym)){
                ast.setNewError({ 
                    msg: `El tipo de dato de ${this.name} es incorrecto.`, 
                    line: this.line,
                    col: this.col
                });
                return;
            }
        }
        // Guardar en entorno
        env.saveVariable(ast, this.line, this.col, this.name, sym);
        return{
            Index:index,
            line: this.line
        } 
        
    }

    consideraciones(sym){
        if((this.type==".ascii"&&sym.type==".asciz")||
        (this.type==".space"&&sym.type==".word")||
        (this.type==".skip"&&sym.type==".word")){
            sym.type=this.type;
            return true;
        }
        return false;
    }
}