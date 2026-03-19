document.querySelector("form").addEventListener("submit", function(e) {
    e.preventDefault(); 
    // redireccionar a la interfaz de bienvenida
    window.location.href = "../bienvenidaUsuario/bienvenidaUsuario.html";
});