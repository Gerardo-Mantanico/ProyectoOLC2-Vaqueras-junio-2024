class Environment {

    constructor(previous, id) {
        this.previous = previous;
        this.id = id;
        this.tabla = {};
    }

    saveVariable(ast,line,col,id,Symbol){
        if(id in this.tabla){
            ast.setNewError({msg: `La variable ${id} ya existe`,line,col});
            return;
        }
        this.tabla[id]=Symbol;
    }

    getVariable(ast, line,col,id){
        let tmpEnv =this;
        while(true){
            if(id in tmpEnv.tabla){
                return tmpEnv.tabla[id];
            }
            if(tmpEnv.previous===null){
                break;
            }
            else{
                tmpEnv=tmpEnv.previous;
            }
        }
        ast?.setNewError({msg: `La variable ${id} no existe`,line,col });
        return new Symbol(0,0, '',Type.NULL,null);
    }

    setVariable(ast, line, col, id, sym) {
        let tmpEnv = this;
        while (true) {
            if (id in tmpEnv.tabla) {
                tmpEnv.tabla[id] = sym;
                return sym;
            }
            if (tmpEnv.previous === null) {
                break;
            }
            else {
                tmpEnv = tmpEnv.previous;
            }
        }
        ast?.setNewError ({ msj: `La variable ${id} no existe`,line,col});
        return new Symbol(0,0,'',Type.NULL,null)
    }
}