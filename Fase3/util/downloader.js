const openFile = async (codigo) => {
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
        codigo.setValue(file);
    }
    reader.onerror = (e) => {
        console.log("Error to read file", e.target.error)
    }
    reader.readAsText(file)
}

export default{
    openFile
}