{
  function joinChars(chars) {
    return chars.join("");
  }
}

programa = inicio

inicio = (_ directivas _)* 

directivas = _ etq:et (nums/string)? _ fin instrucciones* // Directivas con números o cadenas
            / _ etq:et id:ID dospuntos _ fin instrucciones* // Directivas con IDs y dos puntos
            / _ etq:et id:ID _ fin instrucciones* // Directivas con IDs
            / _ etq1:et etq2:et _ fin instrucciones* // Directivas con dos etiquetas
            / _ id:ID dospuntos _ fin instrucciones* // IDs con dos puntos
             /instrucciones// Fin de línea para directivas sin más especificación

instrucciones =  //REGISTROS
	_ op:"mov "i rd:rpg coma _ rs1:rpg _ fin // Instrucción de movimiento
	/_ op:"mov "i rd:rpg coma _ rs1:entero _ fin
    /_ op:"mov "i rd:rpg coma _ rs1:decimal _ fin
    /_ op:"mov "i rd:rpg coma _ rs1:ID _ fin
	/_ op:"mov "i rd:rpg coma rs1:char _ fin
    /_ op:"fmov "i rd:rpf coma rs1:regF _ fin
                  
     //instrucciones de salto y rama
    /_ op:"BL "i _ id:ID _ fin  //llamdo de funcion/subrutina que retorna algo
    /_ op: "B "i _ id:ID _ fin  //salto a una etiqueta id incondicional
    /_ op:"RET"i //retorna de una funcion
    //sobre la pila
    /_ op:"SVC "i _ rd:("#"? entero) _ fin 
    /_ op: "MRS "i _ pila coma _ rd: rpg _ fin 
    / _ op: "MRS "i _ rd:rpg coma _ pila _ fin 
    //comparador
    /_ op: "CMP "i _ rd:rpg coma _ rs1:(nums/rpg) _ fin 
    //operadores relacionales
    /_ op: "BEQ "i _ rd:ID _ fin 
    /_ op: "BNE "i _ rd:ID _ fin 
    /_ op: "BGT "i _ rd:ID _ fin 
    /_ op: "BLT "i _ rd:ID _ fin 
    /_ op:"B.EQ "i _ rd:ID _ fin 
    /_ op:"B.GT "i _ rd:ID _ fin 
    /_ op:"B.LT "i _ rd:ID  _ fin //salto condicional
    /_ op:"B.NE "i _ rd:ID _ fin 
        //Declaraciones
    /_ id:ID _ dospuntos _ et _ (nums/string) _ fin 
    //Operadores
    /_ op: "ADD "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums)_ fin  
    /_ op: "SUB "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    /_ op: "MUL "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    /_ op: "UDIV "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    /_ op: "SDIV "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    //Operadores Logicos
    /_ op: "AND "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    /_ op: "ORR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    /_ op: "EOR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
    /_ op: "MVN "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin 
	//Operadores de Desplazamiento:
    /_ op: "LSL "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) _ fin 
    /_ op: "LSR "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) _ fin 
    /_ op: "ASR "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) _ fin 
    /_ op: "ROR "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) _ fin 
    //carda datos
    /_ op: "LDR "i _ rd:rpg coma _ "[" op1:(rpg)"]" _ fin 
    /_ op: "LDR "i _ rd:rpg coma _ "="_ id:(ID) _ fin 
    /_ op: "LDRB "i _ rd:rpg coma _ "[" op1:(rpg)"]" _ fin 
    /_ op: "LDP "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg)"]" _ fin 
   //almacenar datos
    /_ op: "STR "i _ rd:rpg coma _ "[" op1:(rpg)"]" _ fin 
    /_ op: "STRB "i _ rd:rpg coma _ "[" op1:(rpg)"]" _ fin 
    /_ op: "STP "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg)"]" _ fin 
	/ fin
et = palabraReservada " "? _

nums = _ decimal
        / _ entero
        / _ flotante

caracter = "'" char:[a-z] "'"
char "char"= _ "#" caracter

regF = _ num:flotante
       / _ rg:rpf
       / _ id:ID

pila = "PSP"
        / "MSP"

rpg "registros proposito general"= ("x0"i / "w0"i)
      / ("x4"i / "w4"i)
      / ("x5"i / "w5"i)
      / ("x6"i / "w6"i)
      / ("x7"i / "w7"i)
      / ("x8"i / "w8"i)
      / ("x9"i / "w9"i)
      / ("x10"i / "w10"i)
      / ("x11"i / "w11"i)
      / ("x12"i / "w12"i)
      / ("x13"i / "w13"i)
      / ("x14"i / "w14"i)
      / ("x15"i / "w15"i)
      / ("x16"i / "w16"i)
      / ("x17"i / "w17"i)
      / ("x18"i / "w18"i)
      / ("x19"i / "w19"i)
      / ("x20"i / "w20"i)
      / ("x21"i / "w21"i)
      / ("x22"i / "w22"i)
      / ("x23"i / "w23"i)
      / ("x24"i / "w24"i)
      / ("x25"i / "w25"i)
      / ("x26"i / "w26"i)
      / ("x27"i / "w27"i)
      / ("x28"i / "w28"i)
      / ("x29"i / "w29"i)
      / ("x30"i / "w30"i)
      / ("x1"i / "w1"i)
      / ("x2"i / "w2"i)
      / ("x3"i / "w3"i)
      / ("LR"i)

rpf "registros flotantes"= "d0"i
       / "d4"i
       / "d5"i
       / "d6"i
       / "d7"i
       / "d8"i
       / "d9"i
       / "d10"i
       / "d11"i
       / "d12"i
       / "d13"i
       / "d14"i
       / "d15"i
       / "d16"i
       / "d17"i
       / "d18"i
       / "d19"i
       / "d20"i
       / "d21"i
       / "d22"i
       / "d23"i
       / "d24"i
       / "d25"i
       / "d26"i
       / "d27"i
       / "d28"i
       / "d29"i
       / "d30"i
       / "d31"i
       / "d1"i
       / "d2"i
       / "d3"i
       
palabraReservada = ".global"
                 / ".text"
                 / ".data"
                 / ".bss"
                 / ".ascii"
                 / ".asciz"
                 / ".byte"
                 / ".comm"
                 / ".section"
                 / ".align"
                 / ".quad"
                 / ".short"
                 / ".word"
                 / ".float"
                 / ".double"
                 / ".zero"
                 / ".file"
                 / ".globl"
                 / ".ident"
                 / ".local"
                 / ".size"
                 / ".type"
                 / ".end"
                 / ".p2align"
                 / ".skip"
                 / ".space"
                 / ".balign"
                 / ".equ"
                 / ".if"
                 / ".else"
                 / ".endif"
                 / ".macro"
                 / ".endm"
                 / ".include"
                 / ".rept"
                 / ".endr"
                 / ".pushsection"
                 / ".popsection"

string "texto"= "\"" chars:[^\"]* "\"" { return joinChars(chars); }

entero "entero"= _ "#" i:[0-9]+ { return parseInt(i.join(""), 10); }
        / _ i:[0-9]+ { return parseInt(i.join(""), 10); }

decimal "decimal"= _ "#" "0x" i:[0-9A-Fa-f]+
         / _ "0x" i:[0-9A-Fa-f]+

flotante "flotante"= _ "#" i:[0-9]+ "." d:[0-9]+ { return parseFloat(i.join("") + "." + d.join("")); }
         / _ i:[0-9]+ "." d:[0-9]+ { return parseFloat(i.join("") + "." + d.join("")); }

coma "coma" = _ "," { return ","; }
dospuntos "dos puntos"= ":"

fin "FinLinea"= ["\n"]+

ID "ID"= [a-zA-Z_][a-zA-Z0-9_]*

_ "ignored"= (comentario / [ \t\r])*

comentario = "/*" chars:[^*]* "*/" _ { return { type: "comentario", text: joinChars(chars) }; }
           / inComent chars:[^\n]* _ { return { type: "comentario", text: joinChars(chars) }; }

inComent = "//"
         / ";"
