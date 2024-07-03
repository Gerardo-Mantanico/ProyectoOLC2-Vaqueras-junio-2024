class Etiqueta extends Instruction{
    constructor(linea, columna,name){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=name;
    }

    execute(ast, env, gen, index, inst) {
        console.log("Iniciando etiqueta: "  + this.id+"indice "+index+ " linea "+this.linea);
        return{
            Index:index,
            line: this.linea
        } 
        
    }
      
}