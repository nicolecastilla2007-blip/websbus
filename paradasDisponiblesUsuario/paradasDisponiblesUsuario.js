var mapa = L.map('mapa', {
    zoomControl: true
});

var marcadorBusqueda = null;

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap',
    maxZoom: 19
}).addTo(mapa);


// marcador principal
var marcador = L.marker([10.9685, -74.7813]).addTo(mapa)
.bindPopup("Ubicación de ejemplo")
.openPopup();


// Paradas de bus
var paradas = [
    [10.9685,-74.7813],
    [10.9698,-74.7800],
    [10.9672,-74.7831],
    [10.9660,-74.7840],
    [10.9705,-74.7820]
];

paradas.forEach(function(parada){
    L.marker(parada).addTo(mapa)
    .bindPopup("Parada de bus cercana");
});


// Ubicacion del usuario
mapa.locate({
    setView: true,
    maxZoom: 18,
    enableHighAccuracy: true
});

function onLocationFound(e) {

    var lat = e.latlng.lat;
    var lng = e.latlng.lng;

    // centrar mapa en tu ubicación
    mapa.setView([lat, lng], 18);

    var iconoUsuario = L.icon({
        iconUrl: "https://cdn-icons-png.flaticon.com/512/64/64113.png",
        iconSize: [35,35],
        iconAnchor: [17,35]
    });

    L.marker([lat, lng], {icon: iconoUsuario}).addTo(mapa)
        .bindPopup("Estás aquí")
        .openPopup();

    L.circle([lat, lng], {
        radius: e.accuracy / 2,
        color: "#1E90FF",
        fillColor: "#1E90FF",
        fillOpacity: 0.3
    }).addTo(mapa);
}

function onLocationError() {
    alert("Activa la ubicación para ver tu posición en el mapa.");
}

mapa.on('locationerror', onLocationError);
mapa.on('locationfound', onLocationFound);

// Botón pantalla completa para el mapa

// Referencia al contenedor
const mapaContainer = document.querySelector('.mapa');
const fullscreenBtn = document.getElementById('fullscreenBtn');

// Si el navegador no soporta Fullscreen API, el fallback será usar una clase .fullscreen
const supportsFullscreen = !!(document.fullscreenEnabled || document.webkitFullscreenEnabled || document.mozFullScreenEnabled || document.msFullscreenEnabled);

// Ocultar botón si no hay soporte x (opcional)
if (!supportsFullscreen) {
}

// Función para pedir fullscreen al elemento
function requestFullscreen(el) {
  if (el.requestFullscreen) return el.requestFullscreen();
  if (el.webkitRequestFullscreen) return el.webkitRequestFullscreen();
  if (el.mozRequestFullScreen) return el.mozRequestFullScreen();
  if (el.msRequestFullscreen) return el.msRequestFullscreen();
  return Promise.reject(new Error('Fullscreen API no soportada'));
}

// Función para salir de fullscreen
function exitFullscreen() {
  if (document.exitFullscreen) return document.exitFullscreen();
  if (document.webkitExitFullscreen) return document.webkitExitFullscreen();
  if (document.mozCancelFullScreen) return document.mozCancelFullScreen();
  if (document.msExitFullscreen) return document.msExitFullscreen();
  return Promise.reject(new Error('Fullscreen API no soportada'));
}

// Toggle fullscreen
function toggleFullscreen() {
    // si ya estamos en fullscreen
    const isFS = document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement || document.msFullscreenElement;

    if (!isFS) {
        // intenta Fullscreen API en el contenedor .mapa
        requestFullscreen(mapaContainer).catch(function(){
            // fallback: si falla, añadimos clase fullscreen para simular
            mapaContainer.classList.add('fullscreen');  
            fullscreenBtn.classList.add('active');
            // fuerza redibujado del mapa
            setTimeout(function(){ mapa.invalidateSize(); }, 250);
        });
    } else {
        // salir
        exitFullscreen().catch(function(){
            // fallback: quitar clase
            mapaContainer.classList.remove('fullscreen');
            fullscreenBtn.classList.remove('active');
            setTimeout(function(){ mapa.invalidateSize(); }, 250);
        });
    }
}

// Si el usuario pulsa el botón
fullscreenBtn.addEventListener('click', function(){
    toggleFullscreen();
});

// Escuchar cambios reales de fullscreen para actualizar estilos y forzar invalidateSize
function onFullScreenChange(){
    const isFS = document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement || document.msFullscreenElement;
    if (isFS) {
        mapaContainer.classList.add('fullscreen'); // opcional, para aplicar CSS
        fullscreenBtn.classList.add('active');
    } else {
        mapaContainer.classList.remove('fullscreen');
        fullscreenBtn.classList.remove('active');
    }
    // Leaflet necesita recalcular el tamaño cuando cambia el tamaño visible
    // damos un pequeño timeout para asegurarnos
    setTimeout(function(){
        mapa.invalidateSize();
    }, 200);
}

// attach event listeners cross-browser
document.addEventListener('fullscreenchange', onFullScreenChange);
document.addEventListener('webkitfullscreenchange', onFullScreenChange);
document.addEventListener('mozfullscreenchange', onFullScreenChange);
document.addEventListener('MSFullscreenChange', onFullScreenChange);

// Por si ya estás en fullscreen al cargar (poco probable)
onFullScreenChange();

// BUSCAR DIRECCION EN EL MAPA
const inputDireccion = document.getElementById("direccion");
const botonBuscar = document.getElementById("btnBuscar");

botonBuscar.addEventListener("click", buscarDireccion);

function buscarDireccion(){

    let direccion = inputDireccion.value;

    // convertir "y" en "&" para que OpenStreetMap entienda
    direccion = direccion.replace(" y ", " & ");

    if(direccion === ""){
        alert("Escribe una dirección");
        return;
    }

    // consulta a OpenStreetMap (Nominatim)
    fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${direccion}, Barranquilla, Atlantico, Colombia&limit=1`)
    .then(res => res.json())
    .then(data => {
        
        if(data.length === 0){
            return fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${direccion}, Soledad, Atlantico, Colombia&limit=1`)
            .then(res => res.json());
        }
        
        return data;
    })
    
    .then(data => {
        if(data.length === 0){
            alert("Dirección no encontrada en Barranquilla o Soledad");
            return;
        }
        
        const lat = data[0].lat;
        const lon = data[0].lon;
        
        mapa.setView([lat, lon], 17);
        
        // si ya existe un marcador de búsqueda lo eliminamos
        if(marcadorBusqueda){
            mapa.removeLayer(marcadorBusqueda);
        }
        
        let direccionFormateada = direccion.replace("&", " y ");

        marcadorBusqueda = L.marker([lat, lon]).addTo(mapa)
        .bindPopup("📍 " + direccionFormateada + "<br>(haz clic para eliminar)")
        .openPopup();

        // permitir eliminar el marcador con clic
        marcadorBusqueda.on("click", function(){
            mapa.removeLayer(marcadorBusqueda);
        });

        inputDireccion.addEventListener("keypress", function(e){
            if(e.key === "Enter"){
                buscarDireccion();
            }
        });
    });
}