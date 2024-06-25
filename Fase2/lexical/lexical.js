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