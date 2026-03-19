document.addEventListener("DOMContentLoaded", function() {

    const form = document.querySelector("form");

    form.addEventListener("submit", function(e) {
        e.preventDefault();

        const passwordInput = form.querySelector("input[placeholder='Ingresa tu contraseña']");
        const confirmPasswordInput = form.querySelector("input[placeholder='Confirma tu contraseña']");

        if (passwordInput.value !== confirmPasswordInput.value) {
            alert("Las contraseñas no coinciden");

            passwordInput.value = "";
            confirmPasswordInput.value = "";

            passwordInput.focus();
            return;
        }

        alert("Registro exitoso");
        form.reset();
    });

});
