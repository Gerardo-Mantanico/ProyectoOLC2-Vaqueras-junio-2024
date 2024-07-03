import openFile from "./util/downloader.js";
import windows from "./util/windows.js";
import saveFile from "./util/export.js";
import { generateCst } from "./cst/generateCst.js";
import { clearQuadTable, addDataToQuadTable } from "./table/QuadTable.js";
import { isLexicalError } from "./lexical/lexical.js"
import { table, tableBody } from "./table/tableError.js"
import { llegarTablaRegistros, tablereg, tablereg32 } from "./table/tableRegister.js"
let arregloDePalabras = "";
let cont = 0, code = "";
var msj = document.getElementById("msj");


function analysis(codigo, consoleResult) {
    clearQuadTable();
    clearTable();
    consoleResult.setValue("");
    try {
        let ast = new Ast();                          // Creando ast auxiliar
        let env = new Environment(null, 'Global');    // Creando entorno global
        let gen = new Generator();                    // Creando generador
        let start = performance.now();                // Obteniendo árbol
        let result = PEGFASE1.parse(codigo);
        let end = performance.now();
        //RootExecuter(result, ast, env, gen);        // Ejecutando instrucciones
        //ejecutar el data section
        DataSectionExecuter(result, ast, env, gen);
        //ejecutar las demas instrucciones
        RootExecuter(result, ast, env, gen);
        // Generando gráfica
        generateCst(result.CstTree);
        // Generando cuádruplos
        addDataToQuadTable(gen.getQuadruples());
        // Agregando salida válida en consola
        llegarTablaRegistros(ast.registers.getAllRegisters(), ast.registers.getAllRegisters32Bits());
        if (ast.getErrors()?.length === 0) {
            console.log(env)
            console.log(ast)
            consoleResult.setValue("codigo correctamente compilado!!!\n" + ast.getConsole());
            msj.textContent = "successfully. Time: " + (end - start).toFixed(2); + " ms";
            msj.style.backgroundColor = "#a6ffa6";
        }
        else {
            consoleResult.setValue('Se encontraron algunos errores en la ejecución.');
            iterarErrores(ast.getErrors());
            msjError();
        }

    } catch (e) {
        if (isLexicalError(e)) {
            table("Se ha encontrado un caracter que no pertenece al lenguaje: " + e.found, e.location.start.line, e.location.start.column, "Lexico");
        } else {
            table(e.message, e.location.start.line, e.location.start.column, "Sintátctico");
        }
        document.getElementById('mynetwork').innerHTML = "";
        consoleResult.setValue('Error encontrado:\n' + e);
        msjError();
    }
}

function nextLine(codigo, consoleResult) {
    if (cont === 0) {
        const text = codigo.getValue();
        arregloDePalabras = text.split("\n").filter(palabra => palabra.trim() !== '');
        lineLocation(consoleResult, arregloDePalabras);
    }
    else {
        if (cont <= arregloDePalabras.length) {
            lineLocation(consoleResult, arregloDePalabras);
        }
        else {
            code = "";
            cont = 0;
        }
    }

}

function lineLocation(consoleResult, arregloDePalabras) {
    code = code + "" + arregloDePalabras[cont] + "\n";
    analysis(code + "\n", consoleResult);
    msj.textContent = arregloDePalabras[cont - 1];
    msj.style.backgroundColor = "#2196f3";
    console.log(code);
    cont++;
}

const btnOpen = document.getElementById('btn__open'),
    btnSave = document.getElementById('btn__save'),
    btnClean = document.getElementById('btn__clean'),
    btnShowCst = document.getElementById('btn__showCST'),
    btnAnalysis = document.getElementById('btn__analysis'),
    btnNextLine = document.getElementById('btn__next');

btnOpen.addEventListener('click', () => openFile.openFile(windows.getCodigoIndice()));
btnSave.addEventListener('click', () => saveFile.saveFile("file", "s", windows.getCodigoIndice()));
btnClean.addEventListener('click', () => windows.cleanEditor());
btnAnalysis.addEventListener('click', () => analysis(windows.getCodigoIndice().getValue(), windows.getConsoleResult()));
btnNextLine.addEventListener('click', () => nextLine(windows.getCodigoIndice(), windows.getConsoleResult()));

// Agrega una ventana de edición por defecto al cargar la página
windows.addEditorWindow();
windows.consoleWindow();

function clearTable() {
    tableBody.empty();
    tablereg.empty();
    tablereg32.empty();
}

function iterarErrores(errors) {
    for (let error of errors) {
        table(error.msg, error.line, error.col, "semántico");
    }
}
function msjError() {
    msj.textContent = "Unsuccessfully.";
    msj.style.backgroundColor = "#ff8c8c";
}
