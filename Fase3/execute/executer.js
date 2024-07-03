
const RootExecuter = async (root, ast, env, gen) => {
    const instructions = root?.textSection ?? [];
    for (let index = 0; index < instructions.length; index++) {
        let resultado =instructions[index].execute(ast,env,gen, index,instructions);
        //console.log("linea "+resultado.Index);
        index=resultado.Index;
        if(index<0){//significa el final de las instrucciones
            index=instructions.length+1;
            console.log("se ha llamado a exit del sistema")
        }
    }
}
const DataSectionExecuter = async (root, ast, env, gen) => {
    const instructions = root?.dataSection ?? [];
    await instructions.forEach(async inst => {
        inst.execute(ast, env, gen);
    });
}

// debug


const RootExecuterDegug = (root, ast, env, gen, index) => {
    const instructions = root?.textSection ?? [];
    console.log("tamano "+instructions.length);
    if(index<instructions.length){
        let resultado = instructions[index].execute(ast, env, gen, index, instructions);
        if (resultado === undefined) {
            console.log('El resultado es undefined, haciendo algo...');
            return instructions[index+1].execute(ast, env, gen, index, instructions).line;
        } else {
            console.log("linea "+resultado.Index);
            if (resultado.index < 0) {
                resultado.index = instructions.length + 1;
                console.log("Se ha llamado a exit del sistema");
            }
            return resultado.line;
        }
    }
    else{
        console.log("paso");
        return -1}
}
               


const DataSectionExecuterDegug = (root, ast, env, gen, index) => {
    const instructions = root?.dataSection ?? [];
    let inst = instructions[index];
    if (index < instructions.length) {
        console.log(inst.line);
        inst.execute(ast, env, gen);
        return {
            line: inst.line,
            state: true
        };
    }
    else{
        return {
            state: false
        }
    }
   
}
