class Cset extends Instruction{
    constructor(linea, columna, id, reg, et){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.op1=reg;
        this.et=et;
    }
    execute(ast, env, gen, index, inst){
        let tag = this.et;
        if(tag==="eq"){//si los valores son iguales
            if(env.Z===1) this.setValue(ast,env,gen,this.op1,1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,0,this.linea,this.columna);
        }else if(tag==="ne"){//si los valores no son iguales
            if(env.Z===0) this.setValue(ast,env,gen,this.op1,1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,0,this.linea,this.columna);  
        }else if(tag==="gt"){//si el primer valor es mayor que el segundo
            if(env.Z===0 && env.N===0) this.setValue(ast,env,gen,this.op1,1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,2,this.linea,this.columna);  
        }else if(tag==="lt"){//si el primer valor es menor que el segundo
            if(env.Z===0 && env.N===1) this.setValue(ast,env,gen,this.op1,1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,0,this.linea,this.columna);  
        }else if(tag==="ge"){//si el primer valor es mayor o igual que el segundo
            if((env.Z===1)||env.N=== env.V) this.setValue(ast,env,gen,this.op1,1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,0,this.linea,this.columna);  
        }else if(tag==="le"){//si el primer valor es mayor o igual que el segundo
            if((env.Z===1)||env.N !== env.V) this.setValue(ast,env,gen,this.op1,1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,0,this.linea,this.columna);  
        }

        else{
            ast.setNewError({ msg: `La etiqueta ${tag} No es valida.`, line: this.linea, col: this.columna});
        }
        return index;
    }
    setValue(ast,env,gen,reg,value, linea, columna){
        let setReg = ast.registers?.setRegister32(reg, value);
        if (setReg === null) ast.setNewError({ msg: `El registro de destino ${reg} es incorrecto.`, line: linea, col: columna });
        
    }
}