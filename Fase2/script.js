import openFile from "./controllers/downloader.js";
import windows from "./controllers/windows.js";
import saveFile from "./controllers/export.js";
import { generateCst } from "./cst/generateCst.js";
import {clearQuadTable,addDataToQuadTable } from "./table/QuadTable.js";
import {isLexicalError} from "./lexical/lexical.js"

const analysis = async (codigo, consoleResult) => {
    clearQuadTable();
    const text = codigo.getValue();
    var msj = document.getElementById("msj");
    // tableBody.empty();
    consoleResult.setValue("");
    try {
        let ast = new Ast();                          // Creando ast auxiliar
        let env = new Environment(null, 'Global');    // Creando entorno global
        let gen = new Generator();                    // Creando generador
        let start = performance.now();                // Obteniendo árbol
        let result = PEGFASE1.parse(text);
        let end = performance.now();
        RootExecuter(result, ast, env, gen);        // Ejecutando instrucciones
        generateCst(result.CstTree);                // Generando gráfica
        addDataToQuadTable(gen.getQuadruples());    // Generando cuádruplos
        consoleResult.setValue("codigo correctamente compilado!!!");       // Agregando salida válida en consola
        msj.textContent = "successfully. Time: " + (end - start) + " ms";
        msj.style.backgroundColor = "#a6ffa6";
    } catch (e) {
        if (isLexicalError(e)){
            info += `<tr><td>1</td><td>${"Léxico"}</td><td>${"Se ha encontrado un caracter que no pertenece al lenguaje: " + e.found}</td><td>${e.location.start.line}</td><td>${e.location.start.column}</td></tr>`
        }else {
            info += `<tr><td>1</td><td>${"Sintátctico"}</td><td>${e.message}</td><td>${e.location.start.line}</td><td>${e.location.start.column}</td></tr>`
        }
        document.getElementById('mynetwork').innerHTML = "";
        consoleResult.setValue('Error encontrado:\n' + e);
        msj.textContent = "Unsuccessfully.";
        msj.style.backgroundColor = "#ff8c8c";
    }
}

const btnOpen = document.getElementById('btn__open'),
    btnSave = document.getElementById('btn__save'),
    btnClean = document.getElementById('btn__clean'),
    btnShowCst = document.getElementById('btn__showCST'),
    btnAnalysis = document.getElementById('btn__analysis');

btnOpen.addEventListener('click', () => openFile.openFile(windows.getCodigoIndice()));
btnSave.addEventListener('click', () => saveFile.saveFile("file", "s", windows.getCodigoIndice()));
btnClean.addEventListener('click', () => windows.cleanEditor());
btnAnalysis.addEventListener('click', () => analysis(windows.getCodigoIndice(), windows.getConsoleResult()));

// Agrega una ventana de edición por defecto al cargar la página
windows.addEditorWindow();
windows.consoleWindow();


