document.getElementById("resetForm").addEventListener("submit", function(event){
    event.preventDefault();
    let password = document.getElementById("password").value;
    let confirmPassword = document.getElementById("confirmPassword").value;
    
    if(password === confirmPassword){
        alert("Contraseña actualizada correctamente. Ahora puedes iniciar sesión.");
        setTimeout(function(){
            window.location.href = "../inicioSesion/inicioSesion.html";
        },1500);
    }else{
        alert("Las contraseñas no coinciden. Intenta nuevamente.");
    }
});