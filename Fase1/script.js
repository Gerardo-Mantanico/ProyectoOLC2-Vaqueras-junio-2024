document.addEventListener("DOMContentLoaded", function () {
    const editorContainer = document.getElementById("editorContainer");
    const ConsoleResul = document.getElementById("ConsoleResul");
    const windowList = document.getElementById("windowList");
    let editors = [],codigo = [],result, currentEditorIndex = -1, indice=0;


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
        consola.log("wenas");
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
            // theme: 'moxer',
            mode: "javascript",
            value: "    //Bienvenido al IDE con CodeMirror"
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
            indice=index;
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
        })
        if (!file) return

        let reader = new FileReader();

        reader.onload = (e) => {
            const file = e.target.result;
            console.log(file)
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


    const analysis = async (index) => {
        console.log("index "+index);
        const primerEditor = codigo[index];
        const text = primerEditor.getValue();
        var msj = document.getElementById("msj");
        try {
            let start = performance.now();
            let resultado = PEGFASE1.parse(text);
            let end = performance.now();
            msj.textContent = "successfully. Time: " +( end - start);
            msj.style.backgroundColor = "#a6ffa6";
            result.setValue("Codigo correctamente compilado!\n\n"+resultado.toString());
        } catch (error) {
            result.setValue(error.message);
            msj.textContent = "Unsuccessfully.";
            msj.style.backgroundColor = "#ff8c8c";
        }
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
btnSave.addEventListener('click', () => saveFile("file", "rs", indice));
btnClean.addEventListener('click', () => cleanEditor(indice));
//btnShowCst.addEventListener('click', () => localStorage.setItem("dot", dotStringCst));
btnAnalysis.addEventListener('click', () => analysis(indice));


    // Agrega una ventana de edición por defecto al cargar la página
    addEditorWindow();
    consolaWindow();

});