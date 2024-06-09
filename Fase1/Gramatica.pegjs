{
  function joinChars(chars) {
    return chars.join("");
  }
}

programa = inicio

inicio= _ coment* directiva

directiva = _".global " id:ID _ end (instrucciones)* directiva//.global _start
			/_".global " id:ID _ end (instrucciones)*
            / _ dv1:et " " _ dv2:et _ end (instrucciones)* directiva //.section .data
            /_ dv1:et " " _ dv2:et _ end (instrucciones)*
            /_ dv1:et " " _ id:ID dospuntos _ end (instrucciones)* directiva //.text id1:
            /_ dv1:et " " _ id:ID dospuntos (instrucciones)*
            / _ id:ID dospuntos _ end (instrucciones)* directiva //etiquetas
            /_ id:ID dospuntos _ end (instrucciones)*
            / _
            
            

et =".section"
    /".data"
    /".text"
    /".rodata"
    /".asciz"
    /".word"
    /".quart"
    /".byte"
    /".rodata"
    /".ascii"
instrucciones
  =  // registros
     _ op:"MOV " rd:rpg coma rs1:regD fin
     /_ op:"MOV " rd:rpg coma rs1:regE fin
     /_ op:"FMOV " rd:rpf coma rs1:regF fin
    //instrucciones de salto y rama
    /_ op:"BL " _ id:ID fin //llamdo de funcion/subrutina que retorna algo
    /_ op: "B " _ id:ID fin //salto a una etiqueta id incondicional
    /_ op:"RET" _ fin //retorna de una funcion
    
    //sobre la pila
    /_ op:"SVC " _ rd:("#"entero/entero) _ fin
    /_ op: "MRS "_ pila coma _ rd: rpg fin
    / _ op: "MRS "_ rd:rpg coma _ pila fin
    
    //comparador
    /_ op: "CMP " _ rd:rpg coma _ rs1:(nums/rpg) fin
    //operadores relacionales
    /_ op: "BEQ " _ rd:ID fin
    /_ op: "BNE " _ rd:ID fin
    /_ op: "BGT " _ rd:ID fin
    /_ op: "BLT " _ rd:ID fin
    /_ op:"B.EQ " _ rd:ID fin
    /_ op:"B.GT " _ rd:ID fin
    /_ op:"B.LT " _ rd:ID fin //salto condicional
    /_ op:"B.NE " _ rd:ID fin
    
    //Declaraciones
    /_ id:ID _ dospuntos _ et _ (nums/string) fin
    //Operadores
    /_ op: "ADD "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "SUB "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "MUL "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "UDIV "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "SDIV "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    //Operadores Logicos
    /_ op: "AND "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "ORR "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "EOR "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
    /_ op: "MVN "_ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) fin
	//Operadores de Desplazamiento:
    /_ op: "LSL "_ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) fin
    /_ op: "LSR "_ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) fin
    /_ op: "ASR "_ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) fin
    /_ op: "ROR "_ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) fin
    //carda datos
    /_ op: "LDR "_ rd:rpg coma _ "[" op1:(rpg)"]" fin
    /_ op: "LDR "_ rd:rpg coma _ "="_ id:(ID) fin
    /_ op: "LDRB "_ rd:rpg coma _ "[" op1:(rpg)"]" fin
    /_ op: "LDP "_ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg)"]" fin
   //almacenar datos
    /_ op: "STR "_ rd:rpg coma _ "[" op1:(rpg)"]" fin
    /_ op: "STRB "_ rd:rpg coma _ "[" op1:(rpg)"]" fin
    /_ op: "STP "_ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg)"]" fin
    
    //ignoraciones
    / _ coment 
    / _ end
    

nums = _"#"decimal
        /_ decimal
		/_ "#" entero
        / _ entero
		/_ "#" flotante
        /_ flotante
        
regD "registroDecimal" = _"#"decimal
						/ _ rpg
						/ _ ID
regE "registro Entero"= _ rpg
       /_ "#" entero
       /_ ID
regF "registroFlotante" = _ "#" flotante
	   /_ rpf
       /_ ID
		
pila "pila"= "PSP"
		/"MSP"
rpg "registroPropositogeneral"
			= "x0"i
            /"x4"i
            /"x5"i
            /"x6"i
            /"x7"i
            /"x8"i
            /"x9"i
            /("x10"i)
            /"x11"i
            /"x12"i
            /"x13"i
            /"x14"i
            /"x15"i
            /"x16"i
            /"x17"i
            /"x18"i
            /"x19"i
            /"x20"i
            /"x21"i
            /"x22"i
            /"x23"i
            /"x24"i
            /"x25"i
            /"x26"i
            /"x27"i
            /"x28"i
            /"x29"i
            /"x30"i
            /"x1"i
            /"x2"i
            /"x3"i
            /"LR"
rpf "registroPuntoFlotante" 
		= 	"d0"i
            /"d4"i
            /"d5"i
            /"d6"i
            /"d7"i
            /"d8"i
            /"d9"i
            /"d10"i
            /"d11"i
            /"d12"i
            /"d13"i
            /"d14"i
            /"d15"i
            /"d16"i
            /"d17"i
            /"d18"i
            /"d19"i
            /"d20"i
            /"d21"i
            /"d22"i
            /"d23"i
            /"d24"i
            /"d25"i
            /"d26"i
            /"d27"i
            /"d28"i
            /"d29"i
            /"d30"i
            /"d31"i
        	/"d1"i
            /"d2"i
            /"d3"i

entero "entero"
  = _ i:[0-9]+ { return parseInt(i.join(""), 10); }
decimal "decimal" 
			=_ "0x"i[0-9A-Fa-f]+

flotante "flotante" =
			i:[0-9]+ (.[0-9]+)* { return parseFloat(i.join(""), 10); }

coment "comentario"
  = _ inComent chars:[^\n]* end { return { type: "comentario", text: joinChars(chars) }; }

inComent "IC"
  = "//"
  / ";"

coma "coma"
  = _ "," { return ","; }
dospuntos "dospuntos" = ":"

ID "ID"
  = ([_]*[a-z]+[0-9]*[_]*)*

fin "endLine"
  = coment
  / _ end

end "newline"
  = "\n" { return "\n"; }
string "string"
  = "\"" chars:[^\"]* "\"" { return chars.join(""); }

_ "ignorar"
  = [ \t]*
