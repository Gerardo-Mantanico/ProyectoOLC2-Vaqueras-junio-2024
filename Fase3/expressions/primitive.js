class Primitive extends Expression {

    constructor(line, col, id, name, type, value) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.name = name;
        this.type = type;
        this.value = value;
    }

    execute(ast, env, gen) {
        // Crear simbolo
        return new Symbolo(this.line, this.col, this.name, this.type, this.value);
    }
    getValue(){
        return this.value;
    }
}