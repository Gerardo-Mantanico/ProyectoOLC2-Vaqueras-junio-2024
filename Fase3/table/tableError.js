export var tableBody = $('#errorTable tbody');
export function table(msj,linea,columna,text){
    var newData = [
        {
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
        



