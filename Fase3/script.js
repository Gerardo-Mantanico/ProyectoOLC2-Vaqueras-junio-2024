import openFile from "./util/downloader.js";
import windows from "./util/windows.js";
import saveFile from "./util/export.js";
import { generateCst } from "./cst/generateCst.js";
import { clearQuadTable, addDataToQuadTable } from "./table/QuadTable.js";
import { isLexicalError } from "./lexical/lexical.js"
import { table, tableBody } from "./table/tableError.js"
import { llegarTablaRegistros, tablereg, tablereg32 } from "./table/tableRegister.js"
let contLinea = 0, type = 0;
var msj = document.getElementById("msj");
let ast1 = new Ast();                          // Creando ast auxiliar
let env1 = new Environment(null, 'Global');    // Creando entorno global
let gen1 = new Generator();                    // Creando generador
let result;
function analysis(codigo, consoleResult) {
    clearQuadTable();
    clearTable();
    clearast();
    consoleResult.setValue("");
    try {
        let ast = new Ast();                          // Creando ast auxiliar
        let env = new Environment(null, 'Global');    // Creando entorno global
        let gen = new Generator();                    // Creando generador
        let start = performance.now();                // Obteniendo árbol
        result = PEGFASE1.parse(codigo);
        let end = performance.now();
        //ejecutar el data section
        DataSectionExecuter(result, ast, env, gen);
        //ejecutar las demas instrucciones
        RootExecuter(result, ast, env, gen);
        // nextLine(result, ast, env, gen);
        // Generando gráfica
        generateCst(result.CstTree);
        // Generando cuádruplos
        addDataToQuadTable(gen.getQuadruples());
        // Agregando salida válida en consola
        llegarTablaRegistros(ast.registers.getAllRegisters(), ast.registers.getAllRegisters32Bits());
        if (ast.getErrors()?.length === 0) {
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
            console.log("capturando el error "+e);
             table(e.message, e.location.start.line, e.location.start.column, "Sintátctico");
        }
        document.getElementById('mynetwork').innerHTML = "";
        consoleResult.setValue('Error encontrado:\n' + e);
        msjError();
    }
}

function nextLine() {
    clearTable();
    switch (type) {
        case 0:
            let state = DataSectionExecuterDegug(result, ast1, env1, gen1, contLinea);
            if (state.state) {
                windows.highlightLine(state.line);
                contLinea++;
            }
            else {
                type = 1;
                contLinea = 0;
            }
            break;
        case 1:
            let line = RootExecuterDegug(result, ast1, env1, gen1, contLinea);
            if (line === -1) {
                type = 0;
                contLinea = 0;
                clearast();
         }
            else {
                windows.highlightLine(line);
                contLinea++;
            }
            break;
    }
    llegarTablaRegistros(ast1.registers.getAllRegisters(), ast1.registers.getAllRegisters32Bits());
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
function clearast(){
    ast1 = new Ast();                           
    env1 = new Environment(null, 'Global');     
    gen1 = new Generator();
    contLinea=0;

}