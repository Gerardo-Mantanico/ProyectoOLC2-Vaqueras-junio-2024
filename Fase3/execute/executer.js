
const RootExecuter = async (root, ast, env, gen) => {
    const instructions = root?.textSection ?? [];
    await instructions.forEach(async inst => {
        console.log("ejecutando instrucciones");
        inst.execute(ast, env, gen);       
    });
}
const DataSectionExecuter = async (root, ast, env, gen) => {
    const instructions = root?.dataSection ?? [];
    await instructions.forEach(async inst => {
        inst.execute(ast, env, gen);
    });
}