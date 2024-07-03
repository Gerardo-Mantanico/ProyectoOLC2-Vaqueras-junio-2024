class Archivo {
    constructor(contenido, ruta) {
        this.contenido = contenido;
        this.ruta = ruta;
    }

    write() {
        const blob = new Blob([this.contenido], { type: 'text/plain' });

        // Crear una URL para el Blob
        const url = URL.createObjectURL(blob);

        // Crear un enlace para descargar el archivo
        const a = document.createElement('a');
        a.href = url;
        a.download = this.ruta;

        // Simular un clic en el enlace
        document.body.appendChild(a);
        a.click();

        // Remover el enlace del DOM
        document.body.removeChild(a);

        // Liberar la URL del Blob
        URL.revokeObjectURL(url);
    }

    static read(callback) {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'text/plain';

        input.addEventListener('change', () => {
            const file = input.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    callback(e.target.result);
                };
                reader.onerror = (e) => {
                    console.error('Error reading file:', e);
                };
                reader.readAsText(file);
            } else {
                console.error('No file selected');
            }
        });

        input.click();
    }
}

// Ejemplo de uso del método read

