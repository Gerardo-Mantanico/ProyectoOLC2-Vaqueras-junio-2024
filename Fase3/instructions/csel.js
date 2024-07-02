class Csel extends Instruction{
    constructor(linea, columna, id,op1,op2,op3,et){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.op1=op1;
        this.op2=op2;
        this.op3=op3;
        this.et=et;

    }
    execute(ast, env, gen, index, inst){
        let obj = this.obtenerValor(ast,env,gen,this.op2);//si se cumple
        let obj1 = this.obtenerValor(ast,env,gen,this.op3);//sino se cumple

        let tag = this.et;

        let val1 = obj?.value?? obj;
        let val2 = obj1?.value?? obj1;
        if(tag==="eq"){//si los valores son iguales
            if(env.Z===1) this.setValue(ast,env,gen,this.op1,val1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,val2,this.linea,this.columna);
        }else if(tag==="ne"){//si los valores no son iguales
            if(env.Z===0) this.setValue(ast,env,gen,this.op1,val1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,val2,this.linea,this.columna);  
        }else if(tag==="gt"){//si el primer valor es mayor que el segundo
            if(env.Z===0 && env.N===0) this.setValue(ast,env,gen,this.op1,val1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,val2,this.linea,this.columna);  
        }else if(tag==="lt"){//si el primer valor es menor que el segundo
            if(env.Z===0 && env.N===1) this.setValue(ast,env,gen,this.op1,val1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,val2,this.linea,this.columna);  
        }else if(tag==="ge"){//si el primer valor es mayor o igual que el segundo
            if((env.Z===1)||env.N=== env.V) this.setValue(ast,env,gen,this.op1,val1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,val2,this.linea,this.columna);  
        }else if(tag==="le"){//si el primer valor es mayor o igual que el segundo
            if((env.Z===1)||env.N !== env.V) this.setValue(ast,env,gen,this.op1,val1,this.linea,this.columna);
            else this.setValue(ast,env,gen,this.op1,val2,this.linea,this.columna);  
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
    obtenerValor(ast, env, gen, op) {
        if (op instanceof Expression) {
            return op?.execute(ast, env, gen);
        } else {
            let valor = ast.registers?.getRegister(op);
            if (valor === null) valor = ast.registers?.getRegister32(op);
            return valor;
        }
    }
}