
export const generateCst = (CstObj) => {
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