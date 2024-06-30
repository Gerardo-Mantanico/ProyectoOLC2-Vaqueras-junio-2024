let quadTable;
    // Obtén una referencia al cuerpo de la tabla
    var tableBody = $('#errorTable tbody');
    const errors = [];
    let cont=1;


$(document).ready(function () {

    quadTable = newDataTable('#quadTable',
        [{data: "Op"}, {data: "Arg1"}, {data: "Arg2"}, {data: "Arg3"}, {data: "Arg4"},{data: "Result"}],
        []);

    $('.tabs').tabs();
    $("select").formSelect();
    $('.tooltipped').tooltip();


});
const newDataTable = (id, columns, data) => {
    let result = $(id).DataTable({
        responsive: true,
        lengthMenu: [[15, 25, 50, -1], [15, 25, 50, "All"]],
        "lengthChange": true,
        data,
        columns
    });
    $('select').formSelect();
    return result;
}


export const clearQuadTable = () => {
    quadTable.clear().draw();
}

export const addDataToQuadTable = (data) => {
    console.log(data);
    for (let quad of data) {
        console.log(quad.getQuadruple());
        quadTable.row.add(quad?.getQuadruple()).draw();
    }
}
