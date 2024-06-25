const editorContainer = document.getElementById("editorContainer");
const ConsoleResul = document.getElementById("ConsoleResul");
const windowList = document.getElementById("windowList");
let editors = [], codigo = [], result, currentEditorIndex = -1;
let indice = 0;

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
function consoleWindow() {
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
        theme: 'moxer',
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
        setIndice(index);
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


const cleanEditor = () => {
    codigo[indice].setValue("");
}


// Agrega una ventana de edición cuando se hace clic en el botón
var btnAddWindow = document.createElement("button");
btnAddWindow.className = "btn-add";
btnAddWindow.dataset.position = "bottom";
btnAddWindow.dataset.tooltip = "Agregar ventana";
btnAddWindow.textContent = "+"
btnAddWindow.addEventListener("click", addEditorWindow);
editorContainer.appendChild(btnAddWindow);


// Función para obtener el valor actual de indice
function getCodigoIndice() {
    return codigo[indice];
}

// Función para actualizar el valor de indice
function setIndice(value) {
    indice = value;
}

function getConsoleResult(){
    return result;
}
export default {
    addEditorWindow,
    consoleWindow,
    cleanEditor,
    codigo,
    editors,
    getCodigoIndice,
    getConsoleResult
}

