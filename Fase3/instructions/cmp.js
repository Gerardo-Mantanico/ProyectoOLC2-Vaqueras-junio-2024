class Cmp extends Instruction{
    constructor(linea, columna, id,reg1, reg2){
        super();
        this.linea=linea;
        this.columna=columna;
        this.id=id;
        this.reg1=reg1;
        this.reg2=reg2;
    }

    execute(ast, env, gen, index, inst) {
        let obj = this.obtenerValor(ast,env,gen,this.reg1);
        let obj1 = this.obtenerValor(ast,env,gen,this.reg2);

        let val1 = obj?.value?? obj;
        let val2 = obj1?.value?? obj1;

        let cmp = val1-val2;
        env.Z = (cmp === 0) ? 1 : 0;
        env.N=(cmp < 0) ? 1 : 0;
        env.C=0;
        env.V=0;
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
}