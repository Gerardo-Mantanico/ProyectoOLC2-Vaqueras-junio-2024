class numOperation extends Instruction{
    constructor(linea, columna,id, operador, op1, op2, op3){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.operador=operador;
        this.op1=op1;
        this.op2=op2;
        this.op3=op3;
    }

    execute(ast, env, gen) {
        console.log(this.operador + ", " + this.op1 + ", "+this.op2 + ", "+ this.op3);
        let val1, val2;
        if(this.op2 instanceof Expression) val1 = this.op2?.execute(ast, env, gen);//si es un primitivo
        else val1=ast.registers?.getRegister(this.op2);//si es un registro
        //hacer logica si es un id o si hay valores de registros de 32 bits
        if(this.op3 instanceof Expression) val2 = this.op3?.execute(ast, env, gen);//si es un primitivo
        else val2= ast.registers?.getRegister(this.op3);
        if(val1===null)val1=ast.registers?.getRegister32(this.op2);
        if(val2===null)val2= ast.registers?.getRegister32(this.op3);
        //hacer mas logica si es un id o o registro de 32 bits
        if (val1 === null) ast.setNewError({ msg: `El valor de asignación para ${this.op2} es incorrecto.`, line: this.linea, col: this.columna});
        if (val2 === null) ast.setNewError({ msg: `El valor de asignación para ${this.op3} es incorrecto.`, line: this.linea, col: this.columna});
        console.log(val1 + ", " +val2 )
        if(val1 != null && val2!=null){
            let newValue=this.nuevoValor(this.operador,val1,val2, this.op2, this.op3);
            /*console.log("Debe hacerse un: "+this.operador);
            console.log("valor de la operacion: " + newValue);*/
            let setReg = ast.registers?.setRegister(this.op1, newValue);
            if(setReg===null) setReg = ast.registers?.setRegister32(this.op1, newValue);
            if (setReg === null) ast.setNewError({ msg: `El registro de destino es incorrecto.`, line: this.linea, col: this.columna});    
        }
    }

    nuevoValor(operador, valor1, valor2, op2, op3){
        if (operador.trim().toLowerCase() === "add" &&
            op2.toLowerCase().includes("x") &&
            (typeof (valor1?.value ?? valor1) === 'string') &&
            (typeof (valor2?.value ?? valor2) === 'number')) {//si esta manejando apuntadores
            let str=valor1?.value ?? valor1;
            let num=valor2?.value ?? valor2;
            return str.substring(num,str.length);           
        }else{
            if (operador.trim().toLowerCase() === "add") {
                return (valor1?.value ?? valor1) + (valor2?.value ?? valor2);
            }else if(operador.trim().toLowerCase() === "sub") {
                return (valor1?.value ?? valor1) - (valor2?.value ?? valor2);
            }else if(operador.trim().toLowerCase() === "mul") {
                return (valor1?.value ?? valor1) * (valor2?.value ?? valor2);
            }else if(operador.trim().toLowerCase() === "sdiv") {
                return (valor1?.value ?? valor1) / (valor2?.value ?? valor2);
            }else if(operador.trim().toLowerCase() === "udiv") {
                return Math.abs((valor1?.value ?? valor1) / (valor2?.value ?? valor2));
            }
        }

    }
}