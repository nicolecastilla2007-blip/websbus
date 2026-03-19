const button = document.getElementById("toggleMode");

button.addEventListener("click", () => {
    document.body.classList.toggle("dark");

    if(document.body.classList.contains("dark")){
        button.textContent="☀️";
    }
    else{
        button.textContent="🌙";
    }
});

const enviar = document.getElementById("enviar");
const correo = document.getElementById("correo");

enviar.addEventListener("click", () => {
    correo.value = "";
});
