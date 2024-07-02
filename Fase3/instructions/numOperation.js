class numOperation extends Instruction {
    constructor(linea, columna, id, operador, op1, op2, op3) {
        super();
        this.linea = linea;
        this.columna = columna;
        this.id = id;
        this.operador = operador;
        this.op1 = op1;
        this.op2 = op2;
        this.op3 = op3;
    }

    execute(ast, env, gen, index, inst) {
        console.log(this.operador + ", " + this.op1 + ", " + this.op2 + ", " + this.op3);

        let val1 = this.obtenerValor(ast, env, gen, this.op2);
        let val2 = this.obtenerValor(ast, env, gen, this.op3);

        if (val1 === null) ast.setNewError({ msg: `El valor de asignación para ${this.op2} es incorrecto.`, line: this.linea, col: this.columna });
        if (val2 === null) ast.setNewError({ msg: `El valor de asignación para ${this.op3} es incorrecto.`, line: this.linea, col: this.columna });

        console.log(val1 + ", " + val2);

        if (val1 != null && val2 != null) {
            let newValue = this.nuevoValor(this.operador, val1, val2, this.op2, this.op3, this.op1, ast);

            if (newValue !== null) {
                let setReg = ast.registers?.setRegister(this.op1, newValue);
                if (setReg === null) setReg = ast.registers?.setRegister32(this.op1, newValue);
                if (setReg === null) ast.setNewError({ msg: `El registro de destino es incorrecto.`, line: this.linea, col: this.columna });
            }
        }
        return index;
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

    nuevoValor(operador, valor1, valor2, op2, op3, op1, ast) {
        operador = operador.trim().toLowerCase();
        let val1 = valor1?.value ?? valor1;
        let val2 = valor2?.value ?? valor2;
        console.log( operador + ", "+val1 + ", " + val2);
        try {
            
        if (operador === "add" && op2.toLowerCase().includes("x") && typeof val1 === 'string' && typeof val2 === 'number') {
            let val = ast.registers?.getRegister(op1);
            val.puntero += val2;
            ast.registers?.setRegister(op1, val);
            return null;
        }
        } catch (error) {
            
        }

        switch (operador) {
            case "add":
                return val1 + val2;
            case "sub":
                return val1 - val2;
            case "mul":
                return val1 * val2;
            case "sdiv":
                return val1 / val2;
            case "udiv":
                return Math.abs(val1 / val2);
            default:
                return null;
        }
    }
}
