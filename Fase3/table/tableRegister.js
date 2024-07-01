
export var tablereg = $('#regTable tbody');
export var tablereg32 = $('#regTable32 tbody');
const regTable = document.querySelector('#regTable tbody');
 const regTable32 = document.querySelector('#regTable32 tbody');

 export const llegarTablaRegistros=(data, data32)=>{
    for (let index = 0; index < data.length; index++) {
        const tr = document.createElement('tr');

        const tdRegister = document.createElement('td');
        tdRegister.textContent = "x"+index;
        tr.appendChild(tdRegister);

        const tdValue = document.createElement('td');
        tdValue.textContent = data[index]?.value ?? data[index];
        tr.appendChild(tdValue);

        regTable.appendChild(tr);   
    }
   for (let index = 0; index < data32.length; index++) {
        const tr = document.createElement('tr');

        const tdRegister = document.createElement('td');
        tdRegister.textContent = "w"+index;
        tr.appendChild(tdRegister);

        const tdValue = document.createElement('td');
        tdValue.textContent = data32[index]?.value ?? data32[index];
        tr.appendChild(tdValue);

        regTable32.appendChild(tr);   
    } 
}