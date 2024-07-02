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
        if(indice<0) return -1;
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

    async stdout(ast, env, gen, index){ // Salida estándar 
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

    async stderr(ast, env, gen, index){ // Salida de errores estándar
        // ToDo:
        return index;
    }
}