class Registers{
    constructor(){
        this.registers= new Array(32).fill("0x0000");
        this.reg32Bits=new Array(32).fill("0x0000");
    }

    getRegister(registerIndex){
        try {
            //realizar validaciones
            if(!/[xX]/.test(registerIndex)){
                return null;
            }
            let regNumber = parseInt(registerIndex.replace(/[xX]/,''));
            //obtener el valor de un registro
            if(regNumber>=0 && regNumber<32){
                return this.registers[regNumber];
            } else {
                return null;
            }
        } catch (e) {
            return null;
        }

    }
    getRegister32(registerIndex){
        try {
            //realizar validaciones
            if(!/[wW]/.test(registerIndex)){
                return null;
            }
            let regNumber = parseInt(registerIndex.replace(/[wW]/,''));
            //obtener el valor de un registro
            if(regNumber>=0 && regNumber<32){
                return this.reg32Bits[regNumber];
            } else {
                return null;
            }
        } catch (e) {
            return null;
        }

    }

    setRegister(registerIndex, value){
        try {
            // Validaciones
            if (!/[xX]/.test(registerIndex)){
                return null;
            }
            let regNumber = parseInt(registerIndex.replace(/[xX]/, ''));
            // Establecer el valor de un registro específico
            if (regNumber >= 0 && regNumber < 32) {
                this.registers[regNumber] = value;
            } else {
                return null;
            }
        } catch (e) {
            return null;
        }
    }

    setRegister32(registerIndex, value){
        try {
            // Validaciones
            if (!/[wW]/.test(registerIndex)){
                return null;
            }
            let regNumber = parseInt(registerIndex.replace(/[wW]/, ''));
            // Establecer el valor de un registro específico
            if (regNumber >= 0 && regNumber < 32) {
                this.reg32Bits[regNumber] = value;
            } else {
                return null;
            }
        } catch (e) {
            return null;
        }
    }

    getRegisterHexa(){
        //ToDo:
    }

    getAllRegisters(){
        return this.registers;
    }

    getAllRegisters32Bits(){
        return this.reg32Bits;
    }
}