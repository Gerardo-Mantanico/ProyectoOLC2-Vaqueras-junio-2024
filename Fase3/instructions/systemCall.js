class SystemCall extends Instruction {

    constructor(line, col, id, arg) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.arg = arg;
    }

    execute(ast, env, gen, index, inst) {
        console.log("ejecutando la instruccion: "+index+" de "+inst?.length)
        let indice=index;
        // Obteniendo parámetros de la llamada
        let regtemp0 = ast?.registers?.getRegister('x0');
        // Comprobando acción a realizar
        if(regtemp0.value === 0)  indice = this.stdin(ast, env, gen, indice);  // Se maneja una salida del sistema
        if(regtemp0.value === 1) indice=  this.stdout(ast, env, gen, indice);  // Se maneja una salida del sistema
        if(regtemp0.value === 2) indice= this.stderr(ast, env, gen, indice);  // Se maneja una salida del sistema
        if(regtemp0.value ===-100) indice = this.writeFiles(ast,env,gen,index,this.linea,this.columna);
        if(indice<0) return -1;
        return index;
    }


    writeFiles(ast, env, gen, index, linea, columna){
        let regtemp8 = ast?.registers?.getRegister('x8');
        let regTemp2 = ast?.registers?.getRegister('x2');
        let regTemp3 = ast?.registers?.getRegister('x3');
        let value=ast?.registers?.getRegister('x1');
        if(regtemp8.value===56){
            if(regTemp2.value===101 && regTemp3.value===777){//hay permisos escritura
                env.O_WRONLY=1;
                env.O_CREATE=1;
                env.content=value.value;
            }
            else if(regTemp2.value===0){//permisos lectura
                env.O_RDONLY=1;
                env.content=value.value;
            }else{
                ast.setNewError({ msg: `No hay permisos de apertura para leer o escribir archivos`, linea, columna});
            }
        }
        if(regtemp8.value===64){//escritura
            if(env.O_WRONLY===1 && env.O_CREATE===1){
                let contenido = value.value.substring(0,regTemp2.value);
                let arch = new Archivo(this.valorText(contenido),env.content);
                arch.write();
                ast?.setConsole("Archivo guardado con exito \n");
                //console.log("listo para escribir en: "+env.content + ", el archivo: "+contenido);
            }else{
                ast.setNewError({ msg: `No se han dado permisos para escribir archivo `, linea, columna});   
            }
        }
        if(regtemp8.value===63){//lectura
            value.value="Text mex"
            let sym = value;
            console.log("listo para almacenar texto de "+regTemp2.value +" caracteres em " +
            +sym.value  +".");
            ast?.setConsole("Archivo leido con exito\n")
            Archivo.read((content) => {
                document.getElementById("ConsoleResul").setValue("Hola mundoooo");
                value.value=content
                console.log(content);
            });
        }
        if(regtemp8.value===57){//close files
            env.O_RDONLY=0;
            env.O_WRONLY=0;
            env.O_CREATE=0;
            env.content="";
        }


        return index;
    }

    stdin(ast, env, gen, index){ // Entrada estándar
        let regtemp8 = ast?.registers?.getRegister('x8');
        let ind = index;
        // Validar número de llamada al sistema
        if(regtemp8.value === 63){ // read
            // realizando una lectura en el sistema
            console.log("entrando en stdin")
            const stdInputText = prompt("Ingresa el campo de texto:");
            console.log("Palabra ingresada:", stdInputText);
            
            console.log("saliendo de await")
            const idBuffer = ast?.registers?.getRegister('x1')?.id;
            let length = ast?.registers?.getRegister('x2');
            // Creando nuevo simbolo
            let sym = new Symbolo(this.line, this.col, idBuffer, Type.ASCIZ, '');
            // Agregando valores segun tamaño
            for (let i = 0; i < length.value; i++) {
                sym.value += stdInputText[i] ?? '';
            }
            // Guardando la data obtenida
            env.setVariable(ast, this.line, this.col, idBuffer, sym);
        }
         
        if(regtemp8.value === 93){ // end
            ind=-1;
        }
        return ind;
    }

     stdout(ast, env, gen, index){ // Salida estándar 
        let regtemp8 = ast?.registers?.getRegister('x8');
        // Validar número de llamada al sistema
        if(regtemp8.value === 64){ // write
            let msg = ast?.registers?.getRegister('x1');
            console.log(msg.value);
            let length = ast?.registers?.getRegister('x2');
            let strMsg = msg.value?? msg;
            //length.value = Math.min(length.value, strMsg.length);
            if(typeof strMsg==='number'){
                ast?.setConsole(strMsg);
                return;
            }
            for (let i = 0; i < length.value; i++) {
                try {
                    if (strMsg[i] === '\\' && strMsg[i + 1] === 'n') {
                        ast?.setConsole("\n");
                        i++; // Saltar la 'n' después de la '\'
                    } else {
                        ast?.setConsole(strMsg[i]?? '');
                    }
                } catch (error) {
                    console.log(error)
                    // Manejo de errores (puedes agregar lógica aquí si es necesario)
                }
            }            
        }
        return index;
    }

     stderr(ast, env, gen, index){ // Salida de errores estándar
        // ToDo:
        return index;
    }

    valorText(contenido){
        console.log(contenido)
        let v="";
        for (let i = 0; i < contenido.length; i++) {
           try {
            if (contenido[i] === '\\' && contenido[i + 1] === 'n') {
                v+="\n";
                i++; // Saltar la 'n' después de la '\'
            } else {
                v+=contenido[i]?? '';
            }
           } catch (error) {
            
           }
            
        }
        return v;
    }
}