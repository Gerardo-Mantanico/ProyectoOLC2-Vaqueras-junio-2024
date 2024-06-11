{
  function joinChars(chars) {
    return chars.join("");
  }
}

programa = inicio*

inicio = _ directivas _

directivas = _ etq:et (nums/string) //.ascci "ahahhahaahha"
			/_ etq:et id:ID dospuntos //.global _start:
			/_ etq:et id:ID//.global _start
			/_ etq1:et etq2:et//.global .text
            /_ id:ID dospuntos
            /_ instrucciones

instrucciones = //REGISTROS
		
	  _ op:"mov "i rd:rpg coma rs1:regE 
	 /_ op:"mov "i rd:rpg coma rs1:regD 
     /_ op:"fmov "i rd:rpf coma rs1:regF 
  
     //instrucciones de salto y rama
    /_ op:"BL "i _ id:ID  //llamdo de funcion/subrutina que retorna algo
    /_ op: "B "i _ id:ID  //salto a una etiqueta id incondicional
    /_ op:"RET"i //retorna de una funcion
    //sobre la pila
    /_ op:"SVC "i _ rd:("#"? entero) 
    /_ op: "MRS "i _ pila coma _ rd: rpg 
    / _ op: "MRS "i _ rd:rpg coma _ pila 
    //comparador
    /_ op: "CMP "i _ rd:rpg coma _ rs1:(nums/rpg) 
    //operadores relacionales
    /_ op: "BEQ "i _ rd:ID 
    /_ op: "BNE "i _ rd:ID 
    /_ op: "BGT "i _ rd:ID 
    /_ op: "BLT "i _ rd:ID 
    /_ op:"B.EQ "i _ rd:ID 
    /_ op:"B.GT "i _ rd:ID 
    /_ op:"B.LT "i _ rd:ID  //salto condicional
    /_ op:"B.NE "i _ rd:ID 
        //Declaraciones
    /_ id:ID _ dospuntos _ et _ (nums/string) 
    //Operadores
    /_ op: "ADD "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "SUB "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "MUL "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "UDIV "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "SDIV "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    //Operadores Logicos
    /_ op: "AND "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "ORR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "EOR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
    /_ op: "MVN "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) 
	//Operadores de Desplazamiento:
    /_ op: "LSL "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) 
    /_ op: "LSR "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) 
    /_ op: "ASR "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) 
    /_ op: "ROR "i _ rd:rpg coma _ op1:(rpg) coma _ op2:(nums) 
    //carda datos
    /_ op: "LDR "i _ rd:rpg coma _ "[" op1:(rpg)"]" 
    /_ op: "LDR "i _ rd:rpg coma _ "="_ id:(ID) 
    /_ op: "LDRB "i _ rd:rpg coma _ "[" op1:(rpg)"]" 
    /_ op: "LDP "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg)"]" 
   //almacenar datos
    /_ op: "STR "i _ rd:rpg coma _ "[" op1:(rpg)"]" 
    /_ op: "STRB "i _ rd:rpg coma _ "[" op1:(rpg)"]" 
    /_ op: "STP "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg)"]" 
    

et ="."ID [" "]? _
nums = _ "#"? decimal
        / _ "#"? entero
        /_ "#"?flotante
        
        
caracter  "ascci" = _  "'"char:[a-z]"'"
regD "registroDecimal" = _"#"? num:(decimal)
						/_ "#"caracter
						/ _ rg:rpg
						/ _ id:ID
regE "registro Entero"= _ "#"? num:(entero)
						/_ "#"caracter
                        / rg:rpg
                        /_ id:ID
regF "registroFlotante" = _ "#"? num:flotante
	   /_ rg:rpf
       /_ id:ID
		
pila "pila"= "PSP"
		/"MSP"

rpg "registroPropositogeneral"
			= ("x0"i/"w0"i)
            /("x4"i/"w4"i)
            /("x5"i/"w5"i)
            /("x6"i/"w6"i)
            /("x7"i/"w7"i)
            /("x8"i/"w8"i)
            /("x9"i/"w9"i)
            /("x10"i/"w10"i)
            /("x11"i/"w11"i)
            /("x12"i/"w12"i)
            /("x13"i/"w13"i)
            /("x14"i/"w14"i)
            /("x15"i/"w15"i)
            /("x16"i/"w16"i)
            /("x17"i/"w17"i)
            /("x18"i/"w18"i)
            /("x19"i/"w19"i)
            /("x20"i/"w20"i)
            /("x21"i/"w21"i)
            /("x22"i/"w22"i)
            /("x23"i/"w23"i)
            /("x24"i/"w24"i)
            /("x25"i/"w25"i)
            /("x26"i/"w26"i)
            /("x27"i/"w27"i)
            /("x28"i/"w28"i)
            /("x29"i/"w29"i)
            /("x30"i/"w30"i)
            /("x1"i/"w1"i)
            /("x2"i/"w2"i)
            /("x3"i/"w3"i)
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
            
string "string"
  = "\"" chars:[^\"]* "\"" { return chars.join(""); }

entero "entero"
  = _ i:[0-9]+ { return parseInt(i.join(""), 10); }
decimal "decimal" 
			=_ "0x"i[0-9A-Fa-f]+

flotante "flotante" =
			i:[0-9]+ (.[0-9]+)* { return parseFloat(i.join(""), 10); }

coma "coma"
  = _ "," { return ","; }
dospuntos "dospuntos" = ":"

ID "ID"
  = ([_]*[a-z]+[0-9]*[_]*)*
_ "ignorar"
  = (comentario / [ \t\n\r])*

comentario "comentario" 
  = "/*" chars:[^*]* "*/" _ { return { type: "comentario", text: joinChars(chars) }; }
  / inComent chars:[^\n]* _ { return { type: "comentario", text: joinChars(chars) }; }

inComent "IC"
  = "//"
  / ";"
