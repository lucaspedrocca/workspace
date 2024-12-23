
let numeroSecreto = generarNumeroSecreto();
let intentos = 1;

function asingnarTextoElemento(elemento, texto) {
    let elementoHTML = document.querySelector(elemento);
    elementoHTML.innerHTML = texto;
    return;
}

function verificarIntento(){
    let numeroUsuario = parseInt(document.getElementById('valorUsuario').value);

    if (numeroSecreto === numeroUsuario){
        asingnarTextoElemento('p', `Acertaste el número en .${intentos} ${intentos === 1 ? 'vez':'veces'}`);
    } else {
        if (numeroUsuario > numeroSecreto){
        asingnarTextoElemento('p', 'El numero es mayor.');
        } else {
        asingnarTextoElemento('p', 'El numero es menor.');
        }
        intentos++;
    }
    return resultado;
}

function generarNumeroSecreto() {
    let numeroSecreto = Math.floor(Math.random() * 10) + 1;
    return numeroSecreto;
    
}



asingnarTextoElemento('h1', 'Juego del número secreto!');
asingnarTextoElemento('p', 'Indica un número del 1 al 10');
