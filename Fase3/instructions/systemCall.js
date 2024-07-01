class SystemCall extends Instruction {

    constructor(line, col, id, arg) {
        super();
        this.line = line;
        this.col = col;
        this.id = id;
        this.arg = arg;
    }

    async execute(ast, env, gen) {
        // Obteniendo parámetros de la llamada
        let regtemp0 = ast?.registers?.getRegister('x0');

        // Comprobando acción a realizar
        if(regtemp0.value === 0) await this.stdin(ast, env, gen);  // Se maneja una salida del sistema
        if(regtemp0.value === 1) await  this.stdout(ast, env, gen);  // Se maneja una salida del sistema
        if(regtemp0.value === 2) await this.stderr(ast, env, gen);  // Se maneja una salida del sistema
    }

    async stdin(ast, env, gen){ // Entrada estándar
        let regtemp8 = ast?.registers?.getRegister('x8');
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
            env.setVariable(ast, this.line, this.col, idBuffer, sym)
        }
    }

    async stdout(ast, env, gen){ // Salida estándar 
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
        if(regtemp8.value === 93){ // end
            return;
        }
    }

    async stderr(ast, env, gen){ // Salida de errores estándar
        // ToDo:
    }
}