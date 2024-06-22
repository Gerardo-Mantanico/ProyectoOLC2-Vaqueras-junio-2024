
const RootExecuter = (root, ast, env, gen) => {
    const instructions = root?.textSection ?? [];
    instructions.forEach(inst => {
        inst.execute(ast, env, gen);       
    });
}