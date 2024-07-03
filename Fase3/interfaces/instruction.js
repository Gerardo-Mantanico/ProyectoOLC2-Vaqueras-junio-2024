class Instruction {
    // Abstract method
    execute(ast, env, gen, index, inst) {
        throw new Error('El método execute() debe ser implementado');
    }

}