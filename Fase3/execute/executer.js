
const RootExecuter = async (root, ast, env, gen) => {
    const instructions = root?.textSection ?? [];
    /*await instructions.forEach(async inst => {
        console.log("ejecutando instrucciones");
        inst.execute(ast, env, gen);       
    });*/
    for (let index = 0; index < instructions.length; index++) {
        index=instructions[index].execute(ast,env,gen, index,instructions);
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