
const saveFile = async (fileName, extension, codigo) => {
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
        const primerEditor = codigo;
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

export default {
    saveFile
}