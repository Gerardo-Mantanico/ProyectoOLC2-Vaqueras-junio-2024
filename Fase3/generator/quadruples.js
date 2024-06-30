class Quadruples {
    constructor() {
        this.op = '-';
        this.arg1 = '-';
        this.arg2 = '-';
        this.arg3 = '-';
        this.arg4 = '-';
        this.res = '-';
    }

    getQuadruple() {
        return {
            Op: this.op,
            Arg1: this.arg1,
            Arg2: this.arg2,
            Arg3: this.arg3,
            Arg4: this.arg4,
            Result: this.res,
        };
    }

    setOperator(op){
        if(op) this.op = op;
    }

    getOperator(){
        return this.op;
    }

    setArg1(arg1){
        if(arg1) this.arg1 = arg1;
    }

    getArg1(){
        return this.arg1;
    }

    setArg2(arg2){
        if(arg2) this.arg2 = arg2;
    }

    getArg2(){
        return this.arg2;
    }

    setArg3(arg3){
        if(arg3) this.arg3 = arg3;
    }

    getArg3(){
        return this.arg3;
    }
    setArg4(arg4){
        if(arg4) this.arg4 = arg4;
    }

    getArg4(){
        return this.arg4;
    }
    setArg5(arg5){
        if(arg5) this.arg5 = arg5;
    }

    getArg5(){
        return this.arg5;
    }
    setResult(res){
        if(res) this.res = res;
    }

    getResult(){
        return this.res;
    }

}