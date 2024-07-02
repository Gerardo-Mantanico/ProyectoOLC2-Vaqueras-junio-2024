class saltoIncondicional extends Instruction{
    constructor(linea, columna, id, salto,et){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.salto=salto.trim().toLowerCase();;
        this.et=et;
    }
    execute(ast, env, gen, index, inst) {
        let indice=-1;
        indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        if(indice===-1)return index;
        return indice;
    }
    existeEtiqueta(ast,inst,id, linea, columna){
        for (let index = 0; index < inst.length; index++) {
            if(inst[index]?.id===id) return index;  
        }
        ast.setNewError({ msg: `La etiqueta ${id} No es existe.`, line: linea, col:columna});
        return -1;
    }
}