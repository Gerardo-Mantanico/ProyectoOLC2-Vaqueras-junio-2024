{
  let dataSection=[];
  let instructions=[];
  let errors=[];
 
  function joinChars(chars) {
    return chars.join("");
  }
  function addDataSection(ins) {
    ins.forEach(e => {
      if(e!=null){
        dataSection.push(e);
      }
    });
  }
  function addInstructions(ins) {
    ins.forEach(inst => {
      if(inst!=null){
        instructions.push(inst); 
      }
    });
  }
  function reportError(location, expected) {
    return {
      found:expected,
      type: "error",
      message: `In the token ${expected}< at line ${location.start.line}, column ${location.start.column}`,
      location: location
    };
  }


   // Creando cst 
  let cst = new Cst();
  // Agregar nodos
  function newPath(idRoot, nameRoot, nodes) {
    cst.addNode(idRoot, nameRoot);
    for (let node of nodes) {
      if (typeof node !== "string"){
        cst.addEdge(idRoot, node?.id);
        continue;
      }
      let newNode = cst.newNode();
      cst.addNode(newNode, node);
      cst.addEdge(idRoot, newNode);
    }
  }
}


inicio = _ dir:directivas* _ {
  let idInst = cst.newNode();
  newPath(idInst, "Directiva", dir);
  let idRoot = cst.newNode();
  newPath(idRoot, 'Start', [{id:idInst}]);

  return new Root("", dataSection, instructions, cst);  
  
}

directivas
  = _ etq:et _ fin ins:instrucciones* // Directivas con números o cadenas
  {
    let idInst = cst.newNode();
    newPath(idInst, etq, ins);
    let idRoot = cst.newNode();
    newPath(idRoot, etq, [{ id:idInst }]);
    addDataSection(ins);
    return new TextSection(idRoot, 'TextSection', etq, ins);
  }
  / _ etq:et id:ID dospuntos _ fin ins:instrucciones* // Directivas con IDs y dos puntos
  {
    let idInst = cst.newNode();
    newPath(idInst, id, ins);
    let idRoot = cst.newNode();
    newPath(idRoot, etq, [{ id:idInst }]);
    addInstructions(ins);
    return new TextSection(idRoot, 'TextSection', id, ins);
  }
  /_ etq:et id:ID _ fin ins:instrucciones*{
    let idInst = cst.newNode();
    newPath(idInst, id, ins);
    let idRoot = cst.newNode();
    newPath(idRoot, etq, [{ id:idInst }]);
    addInstructions(ins);
    return new TextSection(idRoot, 'TextSection', id, ins);

  } 
  // Directivas con IDs
  / _ etq1:et etq2:et _ fin ins:instrucciones* // Directivas con dos etiquetas
  {
    let idInst = cst.newNode();
    newPath(idInst, etq2, ins);
    let idRoot = cst.newNode();
    newPath(idRoot, etq1+" "+etq2, [{ id:idInst }]);
    addInstructions(ins);
    return new TextSection(idRoot, 'TextSection', etq1+""+etq2, ins);
  }
  / _ id:ID dospuntos _ fin ins:instrucciones* // IDs con dos puntos
  {
    const loc = location()?.start;
    let idInst = cst.newNode();
    newPath(idInst, id+":", ins);
    let idRoot = cst.newNode();
    newPath(idRoot,"Inicio Etiqueta", [{ id:idInst }]);
    let et=new Etiqueta(loc?.line,loc?.column,id);
    instructions.push(et);
    addInstructions(ins);
    return new TextSection(idRoot, 'TextSection', id, ins);
  }// Fin de línea para directivas sin más especificación
  /ins:instrucciones {}
  /ErrorRecovery

instrucciones
  // REGISTROS
  = _ op:"mov "i rd:rpg coma _ rs1:rpg _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['mov', rd, 'COMA', rs1]);
    return new Move(loc?.line, loc?.column, idRoot, rd, rs1);
  }

  / _ op:"mov "i rd:rpg coma _ rs1:entero _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['mov', rd, 'COMA', rs1]);
    return new Move(loc?.line, loc?.column, idRoot, rd, rs1);
  }

  / _ op:"mov "i rd:rpg coma _ rs1:decimal _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['mov', rd, 'COMA', rs1]);
    return new Move(loc?.line, loc?.column, idRoot, rd, rs1);
  }

  / _ op:"mov "i rd:rpg coma _ rs1:ID _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['mov', rd, 'COMA', rs1]);
    return new Move(loc?.line, loc?.column, idRoot, rd, rs1);
  }
  / _ op:"mov "i rd:rpg coma _ rs1:char _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['mov', rd, 'COMA', rs1]);
    return new Move(loc?.line, loc?.column, idRoot, rd, rs1);
  }
  /_ op:"movk "i rd:rpg coma _ rs1:rpg _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movk', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movk', rd, rs1, null, null);
  }
  / _ op:"movk "i rd:rpg coma _ rs1:entero _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movk', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movk', rd, rs1, null, null);
  }
  / _ op:"movk "i rd:rpg coma _ rs1:decimal _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movk', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movk', rd, rs1, null, null);
  }
  / _ op:"movk "i rd:rpg coma _ rs1:ID _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movk', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movk', rd, rs1, null, null);
  }
  / _ op:"movk "i rd:rpg coma rs1:char _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movk', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movk', rd, rs1, null, null);
  }
  /_ op:"movn "i rd:rpg coma _ rs1:rpg _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movk', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movk', rd, rs1, null, null);
  }
  / _ op:"movn "i rd:rpg coma _ rs1:entero _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movn', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movn', rd, rs1, null, null);
  }
  / _ op:"movn "i rd:rpg coma _ rs1:decimal _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movn', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movn', rd, rs1, null, null);
  }
  / _ op:"movn "i rd:rpg coma _ rs1:ID _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movn', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movn', rd, rs1, null, null);
  }
  / _ op:"movn "i rd:rpg coma _ rs1:char _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movn', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movn', rd, rs1, null, null);
  }
  /_ op:"movz "i rd:rpg coma _ rs1:rpg _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movz', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movz', rd, rs1, null, null);
  }
  / _ op:"movz "i rd:rpg coma _ rs1:entero _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movz', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movz', rd, rs1, null, null);
  }
  / _ op:"movz "i rd:rpg coma _ rs1:decimal _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movz', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movz', rd, rs1, null, null);
  }
  / _ op:"movz "i rd:rpg coma _ rs1:ID _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movz', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movz', rd, rs1, null, null);
  }
  / _ op:"movz "i rd:rpg coma _ rs1:char _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['movz', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'movz', rd, rs1, null, null);
  }
  / _ op:"fmov "i rd:rpf coma _ rs1:regF _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['fmov', rd, 'COMA', rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'fmov', rd, rs1, null, null);
  }

  // Instrucciones de salto y rama
  / _ op:"BL "i _ id:ID _ fin // Llamado de función/subrutina que retorna algo
{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['BL', id]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'BL', id, null, null, null);
}
  / _ op:"B "i _ id:ID _ fin // Salto a una etiqueta ID incondicional
  {
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['B', id]);
    return new saltoIncondicional(loc?.line, loc?.column, idRoot,op, id);
  }
  / _ op:("RET"i/"ERET"i) _ fin // Retorna de una función
  {
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', [op]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', op, null, null, null, null);
  }

  / _ op:"Bcc "i _ id:ID _ fin
  {
     const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['Bcc',id]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'Bcc', id, null, null, null);
  }

  / _ op:"BLR "i _ id:ID _ fin
  {
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['BLR', id]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'BLR', id, null, null, null);
  }
  / _ op:"BR "i _ id:ID _ fin
  {
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['BR',id]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'BR', id, null, null, null);
  }

  / _ op:"CBNZ "i _ rd:rpg coma _ rs1:(rpg/nums/ID) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['CBNZ',rd,rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'BLR', rd, rs1, null, null);
  }

  / _ op:"CBZ "i _ rd:rpg coma _ rs1:(rpg/nums/ID) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['CBZ',rd,rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'CBZ', rd, rs1, null, null);
  }

  / _ op:"TBNZ "i _ rd:rpg coma _ rs1:(rpg/nums/ID) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['TBNZ',rd,rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'TBNZ', rd, rs1, null, null);
  }
  / _ op:"TBZ "i _ rd:rpg coma _ rs1:(rpg/nums/ID) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Branch Instructions', ['TBZ',rd,rs1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Branch Instructions', 'TBZ', rd, rs1, null, null);
  }


  //INSTRUCCIONES ATOMICAS
  / _ op:"CAS "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Atomic Instructions', ['CAS',rs1,'COMA',rs2,'COMA', rs3]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CAS', rs1, rs2, rs3, null);
  }
  / _ op:"CASA "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Atomic Instructions', ['CASA',rs1,'COMA',rs2,'COMA', rs3]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASA', rs1, rs2, rs3, null);
  }
  / _ op:"CASL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Atomic Instructions', ['CASL',rs1,'COMA',rs2,'COMA', rs3]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASL', rs1, rs2, rs3, null);
  }
/*  / _ op:"CASAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin*/

    / _ op:"CASAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASAL', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASAL', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASB', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASH', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASAB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASAB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASAB', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASAH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASAH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASAH', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASLB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASLB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASLB', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASLH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASLH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASLH', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASALB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASALB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASALB', rs1, rs2, rs3, null);
    }
    
    / _ op:"CASALH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASALH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASALH', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAB', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAH', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDALB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDALB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDALB', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDALH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDALH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDALH', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAAB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAAB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAAB', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAAH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAAH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAAH', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDA "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDA', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDA', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAA "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAA', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAA', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAL', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAL', rs1, rs2, rs3, null);
    }
    
    / _ op:"LDAAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['LDAAL', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'LDAAL', rs1, rs2, rs3, null);
    }
    
    / _ op:"SWP "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['SWP', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'SWP', rs1, rs2, rs3, null);
    }
    
    / _ op:"SWPB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['SWPB', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'SWPB', rs1, rs2, rs3, null);
    }
    
    / _ op:"SWPH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['SWPH', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'SWPH', rs1, rs2, rs3, null);
    }
    
    / _ op:"SWPAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['SWPAL', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'SWPAL', rs1, rs2, rs3, null);
    }
    
    / _ op:"SWPA "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['SWPA', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'SWPA', rs1, rs2, rs3, null);
    }
    
    / _ op:"SWPAAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['SWPAAL', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'SWPAAL', rs1, rs2, rs3, null);
    }
    
   /*  / _ op:"STo "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin */ 
    / _ op:"STo "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STo', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STo', rs1, rs2, null, null);
    }
    
    / _ op:"STAB "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STAB', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STAB', rs1, rs2, null, null);
    }
    
    / _ op:"STAH "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STAH', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STAH', rs1, rs2, null, null);
    }
    
    / _ op:"STALB "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STALB', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STALB', rs1, rs2, null, null);
    }
    
    / _ op:"STALH "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STALH', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STALH', rs1, rs2, null, null);
    }
    
    / _ op:"STAAB "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STAAB', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STAAB', rs1, rs2, null, null);
    }
    
    / _ op:"STAAH "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STAAH', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STAAH', rs1, rs2, null, null);
    }
    
    / _ op:"STAL "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STAL', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STAL', rs1, rs2, null, null);
    }
    
    / _ op:"STA "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STA', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STA', rs1, rs2, null, null);
    }
    
    / _ op:"STAAL "i _ rs1:(rpg/nums/ID) coma _ "["rs2:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['STAAL', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'STAAL', rs1, rs2, null, null);
    }
/*  / _ op:"CASP "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) coma _ "["rs5:(rpg/nums/ID) "]" _ fin */

    / _ op:"CASP "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) coma _ "["rs5:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASP', rs1, 'COMA', rs2,'COMA',rs3,'COMA',rs4,'COMA',rs5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASP', rs1, rs2, rs3, rs4,rs5);
    }
    
    / _ op:"CASPA "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) coma _ "["rs5:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASPA', rs1, 'COMA', rs2,'COMA',rs3,'COMA',rs4,'COMA',rs5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASPA', rs1, rs2, rs3, rs4,rs5);
    }
    
    / _ op:"CASPL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) coma _ "["rs5:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASPL', rs1, 'COMA', rs2,'COMA',rs3,'COMA',rs4,'COMA',rs5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASPL', rs1, rs2, rs3, rs4,rs5);
    }
    
    / _ op:"CASPAL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) coma _ "["rs5:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Atomic Instructions', ['CASPAL', rs1, 'COMA', rs2,'COMA',rs3,'COMA',rs4,'COMA',rs5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Atomic Instructions', 'CASPAL', rs1, rs2, rs3, rs4,rs5);
    }
    

  //INSTRUCCIONES CONDICIONALES
  / _ op:"CSET "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CSET', rs1, 'COMA', rs2]);
      return new Cset(loc?.line, loc?.column, idRoot, rs1, rs2);
  }
  / _ op:"CSETM "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CSETM', rs1, 'COMA', rs2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CSETM', rs1, rs2, null, null,null);
  }
  / _ op:"CINC "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CINC', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CINC', rs1, rs2, rs3, null,null);
  }
  / _ op:"CINV "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CINV', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CINV', rs1, rs2, rs3, null,null);
  }
  / _ op:"CNEG "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) _ fin{
    const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CNEG', rs1, 'COMA', rs2, 'COMA', rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CNEG', rs1, rs2, rs3, null,null);
  }

  / _ op:"CCMN "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CCMN', rs1, 'COMA', rs2, 'COMA', rs3,'COMA',rs4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CCMN', rs1, rs2, rs3, rs4,null);
  }
  / _ op:"CCMP "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) _ fin{
       const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CCMP', rs1, 'COMA', rs2, 'COMA', rs3,'COMA',rs4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CCMP', rs1, rs2, rs3, rs4,null);
  }
  
  / _ op:"CSEL "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) _ fin{
       const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CSEL', rs1, 'COMA', rs2, 'COMA', rs3,'COMA',rs4]);
      return new Csel(loc?.line, loc?.column, idRoot,rs1, rs2, rs3, rs4);
  }
  / _ op:"CSINC "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CSINC', rs1, 'COMA', rs2, 'COMA', rs3,'COMA',rs4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CSINC', rs1, rs2, rs3, rs4,null);
  }
  / _ op:"CSINV "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CSINV', rs1, 'COMA', rs2, 'COMA', rs3,'COMA',rs4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CSINV', rs1, rs2, rs3, rs4,null);
  }
  / _ op:"CSNEG "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ rs3:(rpg/nums/ID) coma _ rs4:(rpg/nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Conditional Instructions', ['CSNEG', rs1, 'COMA', rs2, 'COMA', rs3,'COMA',rs4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Conditional Instructions', 'CSNEG', rs1, rs2, rs3, rs4,null);
  }

  // Sobre la pila
  / _ op:"SVC "i _ rd:(entero) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['SVC', rd]);
      return new SystemCall(loc?.line, loc?.column, idRoot, rd);
  }
  / _ op: "MRS "i _ pi:pila coma _ rd: rpg _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['MRS', pi,'COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'MRS', pi, rd, null, null,null);
  }

  / _ op: "MRS "i _ rd:rpg coma _ pi:pila _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['MRS', rd,'COMA',pi]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'MRS', rd, pi,null, null,null);
  }
  / _ op: "MRS "i _ rd:"SPSel" coma _ en:entero _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['MRS', rd,'COMA',en]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'MRS', rd, en, null, null,null);
  }
  / _ op: "MRS "i _ rd:"DAIFSet" coma _ entero _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['MRS', pi,'COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'MRS', pi, rd, null, null,null);
  }
  / _ op: "MRS "i _ rd:"DAIFClr" coma _ en:entero _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['MRS', rd,'COMA',en]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'MRS', rd, en, null, null,null);
  }
  / _ op: "NOP"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['NOP']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'NOP', null, null, null, null,null);
  }
  / _ op: "SEV"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['SEV']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'SEV', null, null, null, null,null);
  }
  / _ op: "SEVL"i _ fin{
       const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['SEVL']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'SEVL', null, null, null, null,null);
  }
  / _ op: "NOP"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['NOP']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'NOP', null, null, null, null,null);
  }
  / _ op:"SMC "i _ rd:(entero) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['SMC', rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'SMC', rd, null, null, null,null);
  }
  / _ op: "WFE"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['WFE']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'WFE', null, null, null, null,null);
  }
  / _ op: "WFI"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['WFI']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'WFI', null, null, null, null,null);
  }
  / _ op: "YIELD"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['YIELD']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'YIELD', null, null, null, null,null);
  }

  // Comparador
  / _ op: "CMP "i _ rd:(rpg/nums) coma _ rs1:(nums/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Comparador', ['CMP',rd,'COMA',rs1]);
      return new Cmp(loc?.line, loc?.column, idRoot, rd, rs1);
  }
  / _ op: "CMN "i _ rd:rpg coma _ rs1:(nums/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Comparador', ['CMN',rd,'COMA',rs1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Comparador', 'CMN', rd, rs1, null, null,null);
  }

  // Operadores relacionales
   / _ op:"BEQ "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['BEQ',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"BNE "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['BNE',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"BGT "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['BGT',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"BLT "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['BLT',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"B.EQ "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['B.EQ',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"B.GT "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['B.GT',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"B.LT "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['B.LT',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
    / _ op:"B.NE "i _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', ['B.NE',rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
    }
    
  //Mas
  / _ op: ("BCS "i/"B.CS "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BHS "i/"B.HS "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BCC "i/"B.CC "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BLO "i/"B.LO "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BMI "i/"B.MI "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BPL "i/"B.PL "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BVS "i/"B.VS "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BVC "i/"B.VC "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BHI "i/"B.HI "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }
  / _ op: ("BLS "i/"B.LS "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
  }
  / _ op: ("BGE "i/"B.GE "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
  }
  / _ op: ("BLE "i/"B.LE "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new saltoCondicional(loc?.line, loc?.column, idRoot,op, rd);
  }
  / _ op: ("BAL "i/"B.AL "i) _ rd:ID _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Operadores relacionales', [op,rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Operadores relacionales', op, rd, null,null,null);
  }


  // Declaraciones
  / _ id:ID _ dospuntos  fin?  _ etq:et _ v:(nums/string) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Declaraciones', [id,etq,v]);
      let ins = new Declaration(loc?.line, loc?.column, idRoot, id,etq,v);
      //instructions.push(ins);
      return ins;
  }

  // Operadores
  / _ op: "ADD "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Arithmetic', ['add', rd, 'COMA', op1, 'COMA', op2]);
    return new numOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "SUB "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Arithmetic', ['sub', rd, 'COMA', op1, 'COMA', op2]);
    return new numOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "MUL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Arithmetic', ['mul', rd, 'COMA', op1, 'COMA', op2]);
    return new numOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "UDIV "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Arithmetic', ['udiv', rd, 'COMA', op1, 'COMA', op2]);
    return new numOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "SDIV "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
    const loc = location()?.start;
    const idRoot = cst.newNode();
    newPath(idRoot, 'Arithmetic', ['sdiv', rd, 'COMA', op1, 'COMA', op2]);
    return new numOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }
	//MAS OPERADORES
     / _ op: "NEG "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['NEG',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'NEG',op1,op2,null,null,null);
    }
     / _ op: "NGC "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['NGC',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'NGC',op1,op2,null,null,null);
    }
	   / _ op: "ADR "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila/ID)  _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['NGC',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'ADR',rd,op1,null,null,null);
    }

     / _ op: "ADRP "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila/ID)  _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['ADRP',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'ADRP',rd,op1,null,null,null);
    }
     / _ op: "MNEG "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['MNEG',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'MNEG',rd,op1,op2,null,null);
    }
     / _ op: "ADC "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['ADC',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'ADC',rd,op1,op2,null,null);
    }
  
    / _ op:"SMADDL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SMADDL',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SMADDL',rd,op1,op2,op3,null);
    }
    / _ op:"SMSUBL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SMSUBL',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SMSUBL',rd,op1,op2,op3,null);
    }
    / _ op:"UMADDL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['UMADDL',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'UMADDL',rd,op1,op2,op3,null);
    }
    / _ op:"UMSUBL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['UMSUBL',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'UMSUBL',rd,op1,op2,op3,null);
    }
    / _ op:"MADD "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['MADD',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'MADD',rd,op1,op2,op3,null);
    }
    / _ op:"MSUB "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['MSUB',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'MSUB',rd,op1,op2,op3,null);
    }

    / _ op:"SBC "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SBC',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SBC',rd,op1,op2,null,null);
    }
    / _ op:"SDIV "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SDIV',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SDIV',rd,op1,op2,null,null);
    }
    / _ op:"SMNEGL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SMNEGL',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SMNEGL',rd,op1,op2,null,null);
    }
    / _ op:"SMULH "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SMULH',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SMULH',rd,op1,op2,null,null);
    }
    / _ op:"SMULL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['SMULL',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'SMULL',rd,op1,op2,null,null);
    }

    / _ op:"UMNEGL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['UMNEGL',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'UMNEGL',rd,op1,op2,null,null);
    }
    / _ op:"UMULH "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['UMULH',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'UMULH',rd,op1,op2,null,null);
    }
    
    / _ op:"UMULL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Arithmetic', ['UMULL',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Arithmetic', 'UMULL',rd,op1,op2,null,null);
    }


    //INSTRUCCIONES DE MANIPULACION DE BITS
 / _ op:"BFI "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['BFI',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'BFI',rd,op1,op2, op3,null);
    }
    
    / _ op:"BFXIL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['BFXIL',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'BFXIL',rd,op1,op2, op3,null);
    }
    
    / _ op:"EXTR "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['EXTR',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'EXTR',rd,op1,op2, op3,null);
    }
    
    / _ op:"BFIZ "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['BFIZ',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'BFIZ',rd,op1,op2,op3,null);
    }
    
    / _ op:"SBFIZ "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SBFIZ',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SBFIZ',rd,op1,op2, op3,null);
    }
    
    / _ op:"UFIZ "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UFIZ',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UFIZ',rd,op1,op2, op3,null);
    }
    
    / _ op:"BFX  "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['BFX ',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'BFX ',rd,op1,op2, op3,null);
    }
    
    / _ op:"SBFX "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SBFX',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SBFX',rd,op1,op2, op3,null);
    }
    
    / _ op:"UBFX "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UBFX',rd,'COMA',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UBFX',rd,op1,op2, op3,null);
    }
    
  / _ op:"CLS "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['CLS',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'CLS',op1,op2, null,null,null);
    }
    
    / _ op:"CLZ "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['CLZ',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'CLZ',op1,op2, null,null,null);
    }
    
    / _ op:"RBIT "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['RBIT',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'RBIT',op1,op2, null,null,null);
    }
    
    / _ op:"REV "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['REV',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'REV',op1,op2, null,null,null);
    }
    
    / _ op:"REV16 "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['REV16',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'REV16',op1,op2, null,null,null);
    }
    
    / _ op:"REV32 "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['REV32',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'REV32',op1,op2, null,null,null);
    }
    
    / _ op:"SXTB "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTB',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTB',op1,op2, null,null,null);
    }
    
    / _ op:"SXTH "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTH',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTH',op1,op2, null,null,null);
    }
    
    / _ op:"UXTB "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTB',op1,'COMA',op2]);
      return new Uxtb(loc?.line, loc?.column, idRoot,op1,op2,null);
    }
    
    / _ op:"UXTH "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTH',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UXTH',op1,op2, null,null,null);
    }
    
    / _ op:"SXTW "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTW',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTW',op1,op2, null,null,null);
    }
    
    / _ op:"UXTW "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTW',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UXTW',op1,op2, null,null,null);
    }
    
    / _ op:"UXTX "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTX',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UXTX',op1,op2, null,null,null);
    }
    
    / _ op:"SXTX "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTX',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTX',op1,op2, null,null,null);
    }
    
/*3*// _ op: "SXTB "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTB',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTB',op1,op2,op3,null,null);
    }
/*3*// _ op: "UXTB "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila) coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTB',op1,'COMA',op2,'COMA',op3]);
      return new Uxtb(loc?.line, loc?.column, idRoot,op1,op2,op3);
    }
/*3*// _ op: "SXTW "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila)coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTW',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTW',op1,op2,op3,null,null);
    }
/*3*// _ op: "UXTW "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila)coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTW',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UXTW',op1,op2,op3,null,null);
    }
/*3*// _ op: "UXTX "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila)coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['UXTX',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'UXTX',op1,op2,op3,null,null);
    }
/*3*// _ op: "SXTX "i _ op1:(rpg/pila) coma _ op2:(rpg/nums/pila)coma _ op3:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'IDMD BITS', ['SXTX',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'IDMD BITS', 'SXTX',op1,op2,op3,null,null);
    }

  // Operadores lógicos y DESPLAZAMIENTO O MOVIMIENTO
  / _ op: "AND "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['and', rd, 'COMA', op1, 'COMA', op2]);
    return new LogicOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "ANDS "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['ands', rd, 'COMA', op1, 'COMA', op2]);
    return new LogicOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "ORR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['orr', rd, 'COMA', op1, 'COMA', op2]);
    return new LogicOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "EOR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['eor', rd, 'COMA', op1, 'COMA', op2]);
    return new LogicOperation(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "MVN "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['mvn', rd, 'COMA', op1, 'COMA', op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'mvn', rd, op1, op2, null);
  }

  / _ op: "LSL "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['lsl', rd, 'COMA', op1, 'COMA', op2]);
    return new opDesplazamiento(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "LSR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['lsr', rd, 'COMA', op1, 'COMA', op2]);
    return new opDesplazamiento(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "ASR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['asr', rd, 'COMA', op1, 'COMA', op2]);
    return new opDesplazamiento(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }

  / _ op: "ROR "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['ror', rd, 'COMA', op1, 'COMA', op2]);
    return new opDesplazamiento(loc?.line, loc?.column, idRoot, op, rd, op1, op2);
  }
    
  / _ op: "BIC "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['bic', rd, 'COMA', op1, 'COMA', op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'bic', rd, op1, op2, null);
  }

  / _ op: "BICS "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['bics', rd, 'COMA', op1, 'COMA', op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'bics', rd, op1, op2, null);
  }

  / _ op: "EON "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['eon', rd, 'COMA', op1, 'COMA', op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'eon', rd, op1, op2, null);
  }

  / _ op: "ORN "i _ rd:rpg coma _ op1:(rpg/nums) coma _ op2:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['orn', rd, 'COMA', op1, 'COMA', op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'orn', rd, op1, op2, null);
  }

  / _ op: "TST "i _ rd:rpg coma _ op1:(rpg/nums) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Logic', ['tst', rd, 'COMA', op1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Logic', 'tst', rd, op1, null, null);
  }
  
  // Carga de datos y almacenamiento

  / _ op: "LDR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID) _ coma _ op2:(nums/rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldr', rd, 'COMA', op1,'COMA',op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'ldr', rd, op1, op2, null);
  }

  / _ op: "LDRB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID) _ coma _ op2:(nums/rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldrb', rd, 'COMA', op1,'COMA',op2]);
    return new Ldrb(loc?.line, loc?.column, idRoot, rd, op1,op2); 
  }
  
  / _ op: "LDR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldr', rd, 'COMA', op1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'ldr', rd, op1, null, null);
  }
  / _ op: "LDR "i _ rd:rpg coma _ "="_ id:(ID) _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldr', rd, 'COMA', id]);
    return new Ldr(loc?.line, loc?.column, idRoot, rd, id); 
  }
  / _ op: "LDRB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldrb', rd, 'COMA', op1]);
    return new Ldrb(loc?.line, loc?.column, idRoot, rd, op1,null);   }
  / _ op: "LDRSB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldrsb', rd, 'COMA', op1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'ldrsb', rd, op1, null, null);
  }
  / _ op: "LDP "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldp', rd, 'COMA', op1,'COMA',op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'ldp', rd, op1, op2, null);
  }

  / _ op: "STR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['str', rd, 'COMA', op1]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'str', rd, op1,null, null);
  }

  / _ op: "STR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID) _ coma _ op2:(nums/rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['str', rd, 'COMA', op1,'COMA',op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'str', rd, op1, op2, null);
  }
  / _ op: "STRB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['strb', rd, 'COMA', op1]);
    return new Strb(loc?.line, loc?.column, idRoot, rd, op1, null);
  }
  / _ op: "STRB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID) _ coma _ op2:(nums/rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['strb', rd, 'COMA', op1,'COMA',op2]);
    return new Strb(loc?.line, loc?.column, idRoot, rd, op1, op2);
  }
  / _ op: "STP "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['stp', rd, 'COMA', op1,'COMA',op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'stp', rd, op1, op2, null);
  }
  
  / _ op: "LDPSW "i _ rd:rpg coma _ op1:rpg coma _ "[" op2:(rpg/pila/ID)"]" _ fin{
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'Load and Store Instructions', ['ldpsw', rd, 'COMA', op1,'COMA',op2]);
    return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'ldpsw', rd, op1, op2, null);
  }
  /*  / _ op: "LDUR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin */
    / _ op:"LDUR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDUR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDUR', rd, op1, null,null,null);
    }
    
    / _ op:"LDURB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDURB',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDURB', rd, op1, null,null,null);
    }
    
    / _ op:"LDURH "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDURH',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDURH', rd, op1, null,null,null);
    }
    
    / _ op:"LDURS "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDURS',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDURS', rd, op1, null,null,null);
    }
    
    / _ op:"LDURSB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDURSB',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDURSB', rd, op1, null,null,null);
    }
    
    / _ op:"LDURSH "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDURSH',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDURSH', rd, op1, null,null,null);
    }
    
    / _ op:"LDAR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDAR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDAR', rd, op1, null,null,null);
    }
    
    / _ op:"LDURSW "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['LDURSW',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'LDURSW', rd, op1, null,null,null);
    }
    
    / _ op:"PRFM "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['PRFM',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'PRFM', rd, op1, null,null,null);
    }
    
    / _ op:"STUR "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['STUR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'STUR', rd, op1, null,null,null);
    }
    
    / _ op:"STURB "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['STURB',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'STURB', rd, op1, null,null,null);
    }
    
    / _ op:"STURH "i _ rd:rpg coma _ "[" op1:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Load and Store Instructions', ['STURH',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Load and Store Instructions', 'STURH', rd, op1, null,null,null);
    }
    




    
  //Modos de direccionamiento (addr)
  / _ op: "LDPSW "i _ op1:rpg coma _ op2:rpg coma _ "[" op3:(rpg/pila/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['LDPSW',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'LDPSW', op1, op2, op3,null,null);
    }
  / _ op: "LDPSW "i _ op1:rpg coma _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]""!"? _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['LDPSW',op1,'COMA',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'LDPSW', op1, op2, op3,op4,null);
    }
  / _ op: "LDPSW "i _ op1:rpg coma _ op2:rpg coma _ "[" op3:(rpg/ID) "]" coma _ op4:(nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['LDPSW',op1,'COMA',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'LDPSW', op1, op2, op3,op4,null);
    }
  / _ op: "PRFM "i _ op1:("PLDL1KEEP"i/"PSTL1STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'PRFM', op1, op3, null,null,null);
    }

  / _ op: "PRFM "i _ op1:("PSTL1KEEP"i/"PLDL2KEEP"i) coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['PRFM',op1,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'PRFM', op1, op3, op4,null,null);
    }
  / _ op: "LDUR "i _ op1:rpg coma _ "[" op3:(rpg/ID) "]" coma _ op4:(nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['LDUR',op1,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'LDUR', op1, op3, op4,null,null);
    }
  / _ op: "SDUR "i _ op1:rpg coma _ "[" op3:(rpg/ID) "]" coma _ op4:(nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['SDUR',op1,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'SDUR', op1, op3, op4,null,null);
    }
  / _ op: "STR "i  _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]"("!")? _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['STR',op1,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'STR', op1, op3, op4,null,null);
    }
  / _ op: "LDR "i  _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]"("!")? _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['LDR',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'LDR', op2, op3, op4,null,null);
    }
  / _ op: "PRFM "i _ op1:("PLDL1KEEP"i) coma _ "[" op2:(rpg/ID) coma _ op3:(nums/rpg/ID) coma _ op4:("LSL"/"SXTW"/"SXTX"/rpg) coma _ op5:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['PRFM',op1,'COMA',op2,'COMA',op3,'COMA',op4,'COMA',op5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'PRFM', op1, op2, op3,op4,op5);
    }
  / _ op: "PRFM "i _ op1:("PSTL1KEEP"i) coma _ "[" op2:(rpg/ID) coma _ op3:(nums/rpg/ID) coma _ op4:("LSL"/"SXTW"/"SXTX"/rpg) coma _ op5:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['PRFM',op1,'COMA',op2,'COMA',op3,'COMA',op4,'COMA',op5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'PRFM', op1, op2, op3,op4,op5);
    }
  / _ op: "PRFM "i _ op1:("PLDL2KEEP"i) coma _ "[" op2:(rpg/ID) coma _ op3:(nums/rpg/ID) coma _ op4:("LSL"/"SXTW"/"SXTX"/rpg) coma _ op5:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['PRFM',op1,'COMA',op2,'COMA',op3,'COMA',op4,'COMA',op5]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'PRFM', op1, op2, op3,op4,op5);
    }

  //OPERACIONES ATOMICAS
    / _ op: "ADD "i _ "["rd:(rpg/pila) "]" coma _ op1:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'operation atomic', ['ADD',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'operation atomic', 'ADD', rd,op1, null,null,null);
    }
    / _ op: "CLR "i _ "["rd:(rpg/pila) "]" coma _ op1:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'operation atomic', ['CLR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'operation atomic', 'CLR', rd,op1, null,null,null);
    }
    / _ op: "EOR "i _ "["rd:(rpg/pila) "]" coma _ op1:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'operation atomic', ['EOR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'operation atomic', 'EOR', rd,op1, null,null,null);
    }
    / _ op: "SET "i _ "["rd:(rpg/pila) "]" coma _ op1:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'operation atomic', ['SET',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'operation atomic', 'SET', rd,op1, null,null,null);
    }

    //REGISTRO DE PROPOSITO ESPECIFICO
    / _ op: "MSR "i _ rd:rpes coma _ op1:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'reg specific p ', ['MSR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'reg specific p', 'MSR', rd,op1, null,null,null);
    }
    / _ op: "MSR "i _ rd:rpg coma _ op1:rpes _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'reg specific p ', ['MSR',rd,'COMA',op1]);
      return new Operation(loc?.line, loc?.column, idRoot, 'reg specific p', 'MSR', rd,op1, null,null,null);
    }
    //KEYS
    / _ op: "PRFM "i _ op1:("PLDL3KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLDL1STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLDL2STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLDL3STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLIL1KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLIL2KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLIL3KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLIL1STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLIL2STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PLIL3STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PSTL1KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PSTL2KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PSTL3KEEP"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PSTL1STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PSTL2STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    / _ op: "PRFM "i _ op1:("PSTL3STRM"i) coma _ "[" op3:(rpg/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'Keys', ['PRFM',op1,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'Keys', 'PRFM', op1,op3, null,null,null);
    }
    
  / _ op: "ADD "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) coma _ "LSL " _ op3:(nums/ID/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['ADD',rd,'COMA',op1,'COMA',op2,'COMA','LSL',op3,]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'ADD', rd, op1, op2,op3,null);
    }
  / _ op: "SUB "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) coma _ "L" _ op3:(nums/ID/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['SUB',rd,'COMA',op1,'COMA',op2,'COMA','LSL',op3,]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'SUB', rd, op1, op2,op3,null);
    }
  / _ op: "MUL "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) coma _ "LSL " _ op3:(nums/ID/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['MUL',rd,'COMA',op1,'COMA',op2,'COMA','LSL',op3,]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'MUL', rd, op1, op2,op3,null);
    }
  / _ op: "UDIV "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) coma _ "LSL " _ op3:(nums/ID/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['UDIV',rd,'COMA',op1,'COMA',op2,'COMA','LSL',op3,]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'UDIV', rd, op1, op2,op3,null);
    }
  / _ op: "SDIV "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) coma _ "LSL " _ op3:(nums/ID/rpg) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'direccionamiento (addr)', ['SDIV',rd,'COMA',op1,'COMA',op2,'COMA','LSL',op3,]);
      return new Operation(loc?.line, loc?.column, idRoot, 'direccionamiento (addr)', 'SDIV', rd, op1, op2,op3,null);
    }
  
  //Instrucciones de suma de comprobación:
  / _ op: "CRC32B "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32B',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32B', rd,op1, op2,null,null);
    }
  / _ op: "CRC32H "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32H',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32H', rd,op1, op2,null,null);
    }
  / _ op: "CRC32W "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32W',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32W', rd,op1, op2,null,null);
    }
  / _ op: "CRC32X "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32X',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32X', rd,op1, op2,null,null);
    }
  / _ op: "CRC32CB "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32CB',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32CB', rd,op1, op2,null,null);
    }
  / _ op: "CRC32CH "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32CH',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32CH', rd,op1, op2,null,null);
    }
  / _ op: "CRC32CW "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32CW',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32CW', rd,op1, op2,null,null);
    }
  / _ op: "CRC32CX "i _ rd:(rpg/pila) coma _ op1:(rpg/nums/pila) coma _ op2:(rpg/nums) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'LSI with Attribute', ['CRC32CX',rd,'COMA',op1,'COMA',op2]);
      return new Operation(loc?.line, loc?.column, idRoot, 'LSI with Attribute', 'CRC32CX', rd,op1, op2,null,null);
    }

  //nstrucciones de carga y almacenamiento con atributos:
  / _ op:"LDAXP "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDAXP',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDAXP', rs1,rs2, rs3,null,null);
    }
  / _ op:"LDAXR "i _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDAXR',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDAXR', rs2,rs3,null,null,null);
    }
  
  / _ op:"LDXRB "i _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDXRB',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDXRB', rs2,rs3,null,null,null);
    }
  
  / _ op: "LDNP "i _ op1:rpg coma _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDNP X0, X1, [X2] 
  {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDNP',op1,'COMA',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDNP',op1,op2,op3,null,null);
  }
  / _ op: "LDNP "i _ op1:rpg coma _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin  {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDNP',op1,'COMA',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDNP',op1,op2,op3,op4,null);
  }
  / _ op: "LDTR "i _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDTR X0, [X2]
  {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTR',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTR',op2,op3,null,null,null);
  }
  / _ op: "LDTRB "i _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDTR X0, [X2]
      {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRB',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRB',op2,op3,null,null,null);
  }
  / _ op: "LDTRH "i _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDTR X0, [X2]
      {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRH',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRH',op2,op3,null,null,null);
  }
  / _ op: "LDTRSB "i _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDTR X0, [X2]
      {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRSB',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRSB',op2,op3,null,null,null);
  }
  / _ op: "LDTRSH "i _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDTR X0, [X2]
      {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRSH',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRSH',op2,op3,null,null,null);
  }
  / _ op: "LDTRSW "i _ op2:rpg coma _ "[" op3:(rpg/ID/nums)"]" _ fin//LDTR X0, [X2]
      {
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRSW',op2,'COMA',op3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRSW',op2,op3,null,null,null);
  }

  / _ op: "LDTR "i _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTR',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTR',op2,op3,op4,null,null);
  }

  / _ op: "LDTRB"i _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRB',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRB',op2,op3,op4,null,null);
  }
  / _ op: "LDTRH "i _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRH',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRH',op2,op3,op4,null,null);
  }
  / _ op: "LDTRSB"i _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRSB',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRSB',op2,op3,op4,null,null);
  }
  / _ op: "LDTRSH "i _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRSH',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRSH',op2,op3,op4,null,null);
  }
  / _ op:"STLR "i _ rs2:(rpg) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLR',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLR',rs2,rs3,null,null,null);
  }
  / _ op:"STLRB "i _ rs2:(rpg) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLRB',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLRB',rs2,rs3,null,null,null);
  }
  / _ op:"STLRH "i _ rs2:(rpg) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLRH',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLRH',rs2,rs3,null,null,null);
  }
  / _ op:"STTR "i _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STTR',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STTR',rs2,rs3,null,null,null);
  }
  / _ op:"STTRB "i _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STTRB',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STTRB',rs2,rs3,null,null,null);
  }
  / _ op:"STTRH "i _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STTRH',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STTRH',rs2,rs3,null,null,null);
  }
  / _ op:"STXP "i _ rs0:(rpg/nums/ID) coma _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STXP',rs0,'COMA',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STXP',rs0,rs1,rs2,rs3,null);
  }
  / _ op:"STLXP "i _ rs0:(rpg/nums/ID) coma _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLXP',rs0,'COMA',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLXP',rs0,rs1,rs2,rs3,null);
  }
  / _ op:"STXR "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STXR',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STXR',rs1,rs2,rs3,null,null);
  }
  / _ op:"STLXR "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLXR',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLXR',rs1,rs2,rs3,null,null);
  }
  / _ op:"STXRB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STXRB',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STXRB',rs1,rs2,rs3,null,null);
  }
  / _ op:"STLXRB "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLXRB',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLXRB',rs1,rs2,rs3,null,null);
  }
  / _ op:"STXRH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STXRH',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STXRH',rs1,rs2,rs3,null,null);
  }
  / _ op:"STLXRH "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STLXRH',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STLXRH',rs1,rs2,rs3,null,null);
  }
  / _ op:"STNP "i _ rs1:(rpg/nums/ID) coma _ rs2:(rpg/nums/ID) coma _ "["rs3:(rpg/nums/ID) "]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STNP',rs1,'COMA',rs2,'COMA',rs3]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STNP',rs1,rs2,rs3,null,null);
  }

  / _ op:"STNP "i _ op1:(rpg/nums/ID) coma _ op2:(rpg/nums/ID) coma _ "[" op3:(rpg/ID/nums) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STNP',op1,'COMA',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STNP',op1,op2,op3,op4,null);
  }

  / _ op: "LDTRSW "i _ op2:rpg coma _ "[" op3:(rpg/ID) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['LDTRSW',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'LDTRSW',op2,op3,op4,null,null);
  }
  / _ op:"STTR "i _ op2:(rpg/nums/ID) coma _ "[" op3:(rpg/ID/nums) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STTR',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STTR',op2,op3,op4,null,null);
  }
  / _ op:"STTRB "i _ op2:(rpg/nums/ID) coma _ "[" op3:(rpg/ID/nums) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STTRB',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STTRB',op2,op3,op4,null,null);
  }
  / _ op:"STTRH "i _ op2:(rpg/nums/ID) coma _ "[" op3:(rpg/ID/nums) coma _ op4:(nums/rpg/ID)"]" _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'ICAC atribut', ['STTRH',op2,'COMA',op3,'COMA',op4]);
      return new Operation(loc?.line, loc?.column, idRoot, 'ICAC atribut', 'STTRH',op2,op3,op4,null,null);
  }

  //INSTRUCCIONES DEL SISTEMA
 /*/ _ op: "AT S1E0R"i coma _ rd:(rpg/nums/pila) _ fin */

    / _ op:"AT S1E0R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E0R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E0R', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E1R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E1R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E1R', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E2R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E2R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E2R', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E3R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E3R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E3R', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E0W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E0W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E0W', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E1W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E1W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E1W', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E2W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E2W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E2W', rd,null, null,null,null);
    }
    
    / _ op:"AT S1E3W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S1E3W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S1E3W', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E0R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E0R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E0R', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E1R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E1R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E1R', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E2R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E2R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E2R', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E3R"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E3R','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E3R', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E0W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E0W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E0W', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E1W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E1W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E1W', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E2W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E2W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E2W', rd,null, null,null,null);
    }
    
    / _ op:"AT S2E3W"i coma _ rd:(rpg/nums/pila) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['AT S2E3W','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'AT S2E3W', rd,null, null,null,null);
    }
    
  / _ op: "BRK "i coma _ rd:(nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['BRK','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'BRK', rd,null, null,null,null);
    }
  / _ op: "CLREX "i coma _ rd:(nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['CLREX','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'CLREX', rd,null, null,null,null);
    }
  / _ op: "DMB SY"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB SY']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB SY', null,null, null,null,null);
    }
  / _ op: "DMB ST"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB ST']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB ST', null,null, null,null,null);
    }
  / _ op: "DMB LD"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB LD']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB LD', null,null, null,null,null);
    }
  / _ op: "DMB ISH"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB ISH']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB ISH', null,null, null,null,null);
    }
  / _ op: "DMB ISHST"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB ISHT']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB ISHST', null,null, null,null,null);
    }
  / _ op: "DSB SY"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB SY']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB SY', null,null, null,null,null);
    }
  / _ op: "DSB ST"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB SY']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB SY', null,null, null,null,null);
    }
  / _ op: "DSB LD"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB LD']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB LD', null,null, null,null,null);
    }
  / _ op: "DSB ISH"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB ISH']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'ISH', null,null, null,null,null);
    }
  / _ op: "DSB ISHST"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['DMB ISHST']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'DMB ISHST', null,null, null,null,null);
    }
  / _ op: "HVC "i coma _ rd:(nums/ID) _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['HVC','COMA',rd]);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'HVC', rd,null, null,null,null);
    }
  / _ op: "ISB"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['ISB']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'ISB', null,null, null,null,null);
    }
  / _ op: "ISB SY"i _ fin{
      const loc = location()?.start;
      const idRoot = cst.newNode();
      newPath(idRoot, 'System Instructions', ['ISB SY']);
      return new Operation(loc?.line, loc?.column, idRoot, 'System Instructions', 'ISB SY', null,null, null,null,null);
    }
  / _ fin

et = pr:palabraReservada " "? _{return pr;}

nums
  = _ n:flotante{return n;}
  / _ n:entero{return n;}
  / _ n:decimal{return n;}

caracter = "'" char:[a-zA-Z] "'"{return char;}
char "char" = _ "#"c:caracter {return c;}

regF
  = _ num:flotante
  / _ rg:rpf
  / _ id:ID

pila = ("PSP"
     / "MSP"
     / "SP"
     / "XZR"
     / "WZR"
     / "WSP"){return text()}


rpes "registros poposito especial" 

  = ("SPSR_EL1"i)/("SPSR_EL2"i)/("SPSR_EL3"i)
  /("ELR_EL1"i)/("ELR_EL2"i)/("ELR_EL3"i)
  /("SP_EL1"i)/("SP_EL2"i)/("SP_EL3"i)
  /("SP_Sel"i)/("CurrentEL"i)/("DAIF"i)
  /("NZCV"i)/("FPCR"i)/("FPSR"i)

rpg "registros proposito general" = (("x0"i / "w0"i)
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
     / ("SP"i)
     / ("XZR"i)
     / ("PC"i)){return text()}


rpf "registros flotantes"= ("d0"i
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
       / "d3"i)
       {return text()}

palabraReservada = (".global"
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
                ErrorRecovery / ".file"
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
                 /".rodata"){return text()}

string "texto"= "\"" chars:[^\"]* "\"" {
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'string', [chars.join('')]);
    return new Primitivo(loc?.line, loc?.column, idRoot,'string', Type.ASCIZ, chars.join(''));
}

entero "entero"= _ "#"? s:"-"? i:[0-9]+ {
    let n ="";
    if(s=='-'){
      n+="-";
    }
    i.forEach(e => {
      n+=""+e;
    });
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'integer', [text()]);
    return new Primitivo(loc?.line, loc?.column, idRoot,'integer', Type.WORD, parseInt(n, 10));
  }

decimal "decimal"= _ "#"? s:("0x"i/"0b"i)i:[0-9A-Fa-f]+{
    let n =s;
    if(s=='-'){
      n+="-";
    }
    i.forEach(e => {
      n+=""+e;
    });
    const loc = location()?.start;
    let idRoot = cst.newNode();
    newPath(idRoot, 'decimal', [text()]);
    return new Primitivo(loc?.line, loc?.column, idRoot,'decimal', Type.SPACE, n);
}

flotante "flotante"= _ "#"? s:"-"? i:([0-9]+) "." d:([0-9]+) { 
  let n ="";
  if(s=='-'){
    n+="-";
  }
  i.forEach(e => {
      n+=""+e;
  }); n+=".";
  d.forEach(e => {
      n+=""+e;
  });
  return n;
 }
coma "coma" = _ "," { return ","; }
dospuntos "dos puntos"= ":"

fin "FinLinea"= (_["\n"])+

ID "ID"= [a-zA-Z_][a-zA-Z0-9_]* {return text()}

_ "ignored"= (comentario / [ \t\r])*

comentario = "/*" _ chars:[^*]* ("*" / [^*/][^*]*)* "/" _ { return { type: "comentario", text: joinChars(chars) }; }
           / inComent chars:[^\n]* _ { return { type: "comentario", text: joinChars(chars) }; }

inComent = "//"
         / ";"

ErrorRecovery
  = unexpected:[^ \t\n\r]+ {
      return reportError(location(), text());
    }
