document.addEventListener("DOMContentLoaded", function () {
    const editorContainer = document.getElementById("editorContainer");
    const ConsoleResul = document.getElementById("ConsoleResul");
    const windowList = document.getElementById("windowList");
    let editors = [], codigo = [], result, currentEditorIndex = -1, indice = 0;
    // Obtén una referencia al cuerpo de la tabla
    var tableBody = $('#errorTable tbody');
    const errors = [];
    let cont=1;

    $(document).ready(function () {
        $('.tabs').tabs();
        $("select").formSelect();
        $('.tooltipped').tooltip();
    });


    // Función para agregar una nueva ventana de edición
    function addEditorWindow() {
        var newEditor = document.createElement("div");
        newEditor.className = "editor";
        newEditor.style.height = "72vh";
        editorContainer.appendChild(newEditor);

        // Inicializa CodeMirror en la nueva ventana
        var editor = CodeMirror(newEditor, {
            lineNumbers: true,
            styleActivateLine: true,
            matchBrackets: true,
            theme: "moxer",
            mode: "text/x-rustsrc",
            value: ""
        });


        // Oculta todas las ventanas excepto la última
        for (var i = 0; i < editors.length - 1; i++) {
            editors[i].style.display = "none";
        }

        // Agrega la nueva ventana al arreglo de editores
        editors.push(newEditor);
        codigo.push(editor);

        // Muestra la nueva ventana
        showEditorWindow(editors.length - 1);
        updateWindowList();
    }
    // Función para agregar  la consola
    function consolaWindow() {
        var newEditor1 = document.createElement("div");
        newEditor1.className = "resultado";
        newEditor1.style.height = "75.5vh";
        ConsoleResul.appendChild(newEditor1);

        // Inicializa CodeMirror en la nueva ventana
        result = CodeMirror(newEditor1, {
            lineNumbers: true,
            lineNumbers: true,
            styleActivateLine: true,
            matchBrackets: true,
            theme: 'moxer',
            mode: "text/x-rustsrc"
        });
    }


    // Función para agregar una nueva ventana de edición
    function resultConsola() {
        var newEditor = document.createElement("div");
        newEditor.className = "editor";
        newEditor.style.height = "70vh";
        editorContainer.appendChild(newEditor);
        // Inicializa CodeMirror en la nueva ventana
        var editor = CodeMirror(newEditor, {
            lineNumbers: true,
            lineNumbers: true,
            styleActivateLine: true,
            matchBrackets: true,
            theme: 'dracula',
            mode: "javascript",
        });
        
        // Oculta todas las ventanas excepto la última
        for (var i = 0; i < editors.length - 1; i++) {
            editors[i].style.display = "none";
        }

        // Agrega la nueva ventana al arreglo de editores
        editors.push(newEditor);

        // Muestra la nueva ventana
        showEditorWindow(editors.length - 1);
        updateWindowList();
    }


    // Función para actualizar la lista de ventanas
    function updateWindowList() {
        windowList.innerHTML = "";
        for (var i = 0; i < editors.length; i++) {
            var listItem = document.createElement("div");
            listItem.className = "windowListItem";
            var setCurrentButton = document.createElement("button");
            setCurrentButton.textContent = "Windows" + (i + 1);
            setCurrentButton.className = "btn-windows"
            setCurrentButton.onclick = createSetCurrentButtonClickHandler(i);
            var closeButton = document.createElement("button");
            closeButton.className = "btn-close";
            closeButton.dataset.position = "bottom";
            closeButton.onclick = createCloseButtonClickHandler(i);
            listItem.appendChild(setCurrentButton);
            listItem.appendChild(closeButton);
            listItem.appendChild(btnAddWindow);
            windowList.appendChild(listItem);
        }

    }

    // Función para crear el controlador de eventos de clic para un botón "Ventana Actual"
    function createSetCurrentButtonClickHandler(index) {
        return function () {
            showEditorWindow(index);
        };
    }

    // Función para mostrar una ventana de edición específica
    function showEditorWindow(index) {
        if (index >= 0 && index < editors.length) {
            // Oculta todas las ventanas
            for (var i = 0; i < editors.length; i++) {
                editors[i].style.display = "none";
            }
            editors[index].style.display = "block";
            currentEditorIndex = index;
            indice = index;
        }
    }


    // Función para crear el controlador de eventos de clic para un botón "x"
    function createCloseButtonClickHandler(index) {
        return function () {
            deleteEditorWindow(index);
        };
    }

    // Función para eliminar una ventana de edición
    function deleteEditorWindow(index) {
        editorContainer.removeChild(editors[index]);
        editors.splice(index, 1);
        currentEditorIndex = Math.min(currentEditorIndex, editors.length - 1);
        showEditorWindow(currentEditorIndex);
        updateWindowList();
    }

    /*---------------------------------------------------- */

    const cleanEditor = (index) => {
        codigo[index].setValue("");
    }

    const openFile = async (index) => {
        const { value: file } = await Swal.fire({
            title: 'Select File',
            input: 'file',
            inputAttributes: {
                accept: '.s' // Limita la selección de archivos a .s
            }
        })
        if (!file) return
        let reader = new FileReader();
        reader.onload = (e) => {
            const file = e.target.result;
            codigo[index].setValue(file);
        }
        reader.onerror = (e) => {
            console.log("Error to read file", e.target.error)
        }
        reader.readAsText(file)
    }

    const saveFile = async (fileName, extension, index) => {
        if (!fileName) {
            const { value: name } = await Swal.fire({
                title: 'Enter File name',
                input: 'text',
                inputLabel: 'File name',
                showCancelButton: true,
                inputValidator: (value) => {
                    if (!value) {
                        return 'You need to write something!'
                    }
                }
            })
            fileName = name;
        }
        if (fileName) {
            const primerEditor = codigo[index];
            const text = primerEditor.getValue();
            download(`${fileName}.${extension}`, text)
        }
    }

    const download = (name, content) => {
        let blob = new Blob([content], { type: 'text/plain;charset=utf-8' })
        let link = document.getElementById('download');
        link.href = URL.createObjectURL(blob);
        link.setAttribute("download", name)
        link.click()
    }

    /* ----------------------------------------*/

    function isLexicalError(found) {
        const validIdentifier = /^[a-zA-Z_$][a-zA-Z0-9_$]*$/;
        const validInteger = /^[0-9]+$/;
        const validCommentSingleLine = /^\/\/[^\n]*$/; // Comentarios de una sola línea
        const validCommentMultiLine = /^\/\*[^*]*\*\/$/; // Comentarios de varias líneas
        const palabraReserved = /^\.[a-zA-Z_$][a-zA-Z0-9_$]*$/;
        const et = /^[a-zA-Z_$][a-zA-Z0-9_$]*:$/;
        const reg = /^[#]?([x|X|d|D|w|W]|[0-9]+)$/;
        const symbols = /^[:;,]$/;
    
        if (found) {
            if (!validIdentifier.test(found) && 
                !validInteger.test(found) && 
                !palabraReserved.test(found) && 
                !symbols.test(found) &&
                !validCommentSingleLine.test(found) && 
                !validCommentMultiLine.test(found)&&
                !et.test(found)&&
                !reg.test(found)) {
                return "Lexico"; // Error léxico
            }
        }
        return "Sintactico"; // Error sintáctico
    }


    const analysis = async (index) => {
        cont=1;
        const primerEditor = codigo[index];
        const text = primerEditor.getValue();
        var msj = document.getElementById("msj");
        tableBody.empty();
        result.setValue("");
        let start = performance.now();
        let resultado = PEGFASE1.parse(text);
        let end = performance.now();
        let err = extractErrors(resultado); 
        if (err.length > 0) {
            msj.textContent = "Unsuccessfully.";
            msj.style.backgroundColor = "#ff8c8c";
            let output="El codigo tiene errores \n";
            for (let i = 0; i < err.length; i++) {
                err[i].tipo = isLexicalError(err[i].found);
                console.log(err[i].found);
                
                //llenado de tabla de errores
                table(err[i].mensaje,err[i].linea, err[i].columna,err[i].tipo);
            }
            for (let i = 0; i < err.length; i++) {
                output += `Tipo: ${err[i].tipo}, Mensaje: ${err[i].mensaje}, Línea: ${err[i].linea}, Columna: ${err[i].columna}\n`;
            }
            result.setValue(output);
            
        } else {
            msj.textContent = "successfully. Time: " + (end - start) + " ms";
            msj.style.backgroundColor = "#a6ffa6";
            result.setValue("Codigo correctamente compilado!\n\n");
        }
    }


    const generateCst = (CstObj) => {
        // Creando el arreglo de nodos
        let nodes = new vis.DataSet(CstObj.Nodes);
        // Creando el arreglo de conexiones
        let edges = new vis.DataSet(CstObj.Edges);
        // Obteniendo el elemento a imprimir
        let container = document.getElementById('mynetwork');
        // Agregando data y opciones
        let data = {
            nodes: nodes,
            edges: edges
        };
    
        let options = {
            layout: {
                hierarchical: {
                    direction: "UD",
                    sortMethod: "directed",
                },
            },
            nodes: {
                shape: "box"
            },
            edges: { 
                arrows: "to",
            },
        };
    
        // Generando grafico red
        let network = new vis.Network(container, data, options);
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
  
    // Agrega una ventana de edición cuando se hace clic en el botón
    var btnAddWindow = document.createElement("button");
    btnAddWindow.className = "btn-add";
    btnAddWindow.dataset.position = "bottom";
    btnAddWindow.dataset.tooltip = "Agregar ventana";
    btnAddWindow.textContent = "+"
    btnAddWindow.addEventListener("click", addEditorWindow);
    editorContainer.appendChild(btnAddWindow);
    const btnOpen = document.getElementById('btn__open'),
        btnSave = document.getElementById('btn__save'),
        btnClean = document.getElementById('btn__clean'),
        btnShowCst = document.getElementById('btn__showCST'),
        btnAnalysis = document.getElementById('btn__analysis');

    btnOpen.addEventListener('click', () => openFile(indice));
    btnSave.addEventListener('click', () => saveFile("file", "s", indice));
    btnClean.addEventListener('click', () => cleanEditor(indice));
    //btnShowCst.addEventListener('click', () => localStorage.setItem("dot", dotStringCst));
    btnAnalysis.addEventListener('click', () => analysis(indice));


    // Agrega una ventana de edición por defecto al cargar la página
    addEditorWindow();
    consolaWindow();

});