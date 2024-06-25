
function table(msj,linea,columna,text){
    var newData = [
        {
            "No.": cont++,
            "Description": msj,
            "Row":  linea,
            "Column": columna,
            "Type": text
        }
    ];     
    // Itera sobre los nuevos datos y agrega cada uno como una nueva fila a la tabla
    newData.forEach(function(data) {
        var row = $('<tr>');
        Object.keys(data).forEach(function(key) {
            row.append($('<td>').text(data[key]));
        });
        tableBody.append(row);
    });
}
        
function extractErrors(inputArray) {
    const errors = [];
    function processArray(array) {
        for (const item of array) {
            if (Array.isArray(item)) {
                processArray(item); // Recursively process nested arrays
            } else if (item && typeof item === 'object' && item.type === 'error') {
                const errorObj = {
                    tipo: item.type,
                    mensaje: item.message,
                    linea: item.location.start.line,
                    columna: item.location.start.column,
                    found: item.found // Assumes the location object has a 'found' property with the token
                };
                errors.push(errorObj); // Extract and store the error information
            }
        }
    }
    msj
    processArray(inputArray);
    return errors;
}

function extractErrorss(inputArray) {
    function processArray(array) {
        for (const item of array) {
            if (Array.isArray(item)) {
                processArray(item); // Recursively process nested arrays
            } else if (item && typeof item === 'object' && item.type === 'error') {
                
                const msj = `${item.message}`;
                const linea =  `${item.location.start.line}`;
                const columna=` ${item.location.start.column}`;
                table(msj,linea,columna,"Sintactico");
           
            }
        }
    }
    processArray(inputArray);
    return errors;
}

function runCode(resultado) {
    
    try {
        let errors = extractErrors(resultado);
        let output = "Errores encontrados:\n";  
        for (let index = 0; index < errors.length; index++) {
            output += errors[index] + "\n";
        }
        
    } catch (error) {
        console.error('Error al analizar el código:', error);
       
    }
}


function convertLocation(location) {
    return CodeMirror.Pos(location.line - 1, location.column - 1);
  }
