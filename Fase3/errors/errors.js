class Errors{
    constructor(type, description, line, colum){
        console.log("guardando un nuevo error");
        this.type=type;
        this.description=description;
        this.line=line;
        this.colum=colum;
    }
    
    getLine(){
        return this.line;
    }
    getColum(){
        return this.colum;
    }
    getDescription(){
        return this.description;
    }

}