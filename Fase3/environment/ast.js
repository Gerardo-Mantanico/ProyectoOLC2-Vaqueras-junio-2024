class Ast {
    constructor() {
        this.instructions = [];
        this.console = "";
        this.errors = [];
        this.cstNodes = [];
        this.cstEdges = [];
        this.idCount = 0;
        this.registers = new Registers()
    }


    addNode(label) {
        this.cstNodes.push({
            id: this.idCount,
            label: label,
        });
        this.idCount = this.idCount + 1;
    }

    addEdge(from, to) {
        this.cstEdges.push({
            from: from,
            to: to,
        });
    }

    setNewError(err) {
        this.errors.push(err);
    }

    getErrors(){
        return this.errors;
    }

    getConsole() {
        return this.console;
    }

    setConsole(str) {
        this.console += str;
    }


}