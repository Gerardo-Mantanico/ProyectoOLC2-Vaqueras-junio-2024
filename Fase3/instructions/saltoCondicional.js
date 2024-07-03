class saltoCondicional extends Instruction{
    constructor(linea, columna, id, salto,et){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.salto=salto.trim().toLowerCase();;
        this.et=et;
    }
    execute(ast, env, gen, index, inst) {
        console.log("ejecutando comparacion: " +this.salto)
        let indice=-1;
        if(this.salto==="blt"||this.salto==="b.lt"){
            if(env.Z===0 && env.N===1) indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        }
        else if(this.salto==="beq"||this.salto==="b.eq"){
            if(env.Z===1) indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        }
        else if(this.salto==="bne"||this.salto==="b.ne"){
            if(env.Z===0) indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        }
        else if(this.salto==="bgt"||this.salto==="b.gt"){
            if(env.Z===0 && env.N===0) indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        }
        else if(this.salto==="bge"||this.salto==="b.ge"){
            if(env.Z===1||env.N=== env.V) indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        }
        else if(this.salto==="ble"||this.salto==="b.le"){
            if((env.Z===1)||env.N !== env.V) indice=this.existeEtiqueta(ast,inst,this.et,this.linea, this.columna);//existe la etiqueta   
        }
        if(indice===-1){
            return{
                Index:index,
                line: this.linea
            } 
            
        }
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