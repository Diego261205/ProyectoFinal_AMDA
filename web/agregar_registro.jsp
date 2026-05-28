<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es-MX">
    <head>
        <title>AMDA - Nuevo Registro</title>
        <link rel="stylesheet" href="style.css?v=14">
        <!-- Font Awesome para Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Maps API -->
        <%
            String mapKey = modelo.Env.get("NEXT_PUBLIC_GOOGLE_MAPS_API_KEY");
            if (mapKey.isEmpty()) {
                mapKey = modelo.Env.get("GOOGLE_MAPS_API_KEY");
            }
        %>
        <script src="https://maps.googleapis.com/maps/api/js?key=<%= mapKey %>&libraries=places&callback=initMap" async defer></script>
    </head>
    <body>
        <header class="main-header">
            <h1><i class="fa-solid fa-car-side"></i> AMDA - Control de Servicios</h1>
            <div>
                Bienvenido, <strong><%= session.getAttribute("usuarioLogueado") %></strong> |
                <a href="index.jsp" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión</a>
            </div>
        </header>

        <main class="content-container">
            <div class="form-container">
                <h2><i class="fa-solid fa-folder-plus"></i> Nuevo Trámite Vehicular</h2>
                <form action="guardar_servicio.jsp" method="POST">
                    <div class="grid-form">
                        <section class="form-section">
                            <h3><i class="fa-solid fa-address-card"></i> Datos del Dueño</h3>
                            <label for="nombre_dueno">Nombre Completo:</label>
                            <input type="text" id="nombre_dueno" name="nombre_dueno" placeholder="Nombre completo del titular" required>
                            <label for="nacimiento">Fecha de Nacimiento:</label>
                            <input type="date" id="nacimiento" name="nacimiento" required>

                            <label for="telefono">Teléfono:</label>
                            <input type="text" id="telefono" name="telefono" placeholder="10 dígitos" required>

                            <label for="domicilio">Domicilio:</label>
                            <input type="text" id="domicilio" name="domicilio" placeholder="Busca la dirección con Google Maps..." required autocomplete="off">
                            <div id="map" style="width: 100%; height: 250px; margin-top: 12px; border-radius: var(--radius-sm); border: 1px solid var(--border-color);"></div>
                        </section>
 
                        <section class="form-section">
                            <h3><i class="fa-solid fa-car"></i> Datos del Servicio</h3>
                            <label for="tipo_movimiento">Tipo de Trámite:</label>
                            <select id="tipo_movimiento" name="tipo_movimiento">
                                <option value="Placa Nueva">Placa Nueva</option>
                                <option value="Permiso de Circulacion">Permiso de Circulación</option>
                            </select>

                            <label for="cliente_solicita">Agencia que solicita:</label>
                            <select id="cliente_solicita" name="cliente_solicita">
                                <option value="Ford Country">Ford Country</option>
                                <option value="Honda Campestre">Honda Campestre</option>
                                <option value="Mercedes-Benz Aguascalientes">Mercedes-Benz Aguascalientes</option>
                                <option value="Audi Aguascalientes">Audi Aguascalientes</option>
                                <option value="Eurocentro Camionero">Eurocentro Camionero</option>
                                <option value="Autodistribuidores del Centro">Autodistribuidores del Centro</option>
                                <option value="Chevrolet Herrera Motors">Chevrolet Herrera Motors</option>
                                <option value="Nissan Torres Corzo">Nissan Torres Corzo</option>
                                <option value="Toyota Aguascalientes">Toyota Aguascalientes</option>
                                <option value="BMW Aguascalientes">BMW Aguascalientes</option>
                            </select>
                            
                            <label for="marca">Marca del Vehículo:</label>
                            <input type="text" id="marca" name="marca" placeholder="Ej: Nissan, Chevrolet" required>

                            <label for="modelo">Modelo:</label>
                            <input type="text" id="modelo" name="modelo" placeholder="Ej: Sentra, Aveo" required>

                            <label for="vin">VIN (Número de Serie):</label>
                            <input type="text" id="vin" name="vin" placeholder="17 caracteres del vehículo" maxlength="17" required>

                            <label for="tipo_placa">Tipo de Placa:</label>
                            <input type="text" id="tipo_placa" name="tipo_placa" placeholder="Ej: NA, Antiguo">

                            <label for="importe">Importe a Cobrar ($):</label>
                            <input type="number" id="importe" step="0.01" name="importe" placeholder="0.00" required>
                        </section>
                    </div>
                    
                    <div style="margin-top: 25px; text-align: right; display: flex; justify-content: flex-end; gap: 12px; align-items: center;">
                        <a href="dashboard.jsp" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Cancelar</a>
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Guardar Registro Completo</button>
                    </div>
                </form>
            </div>
        </main>

        <!-- Scripts de Google Maps -->
        <script>
            let map, marker, autocomplete;

            function initMap() {
                // 1. Inicializar Autocomplete para el campo 'domicilio'
                const input = document.getElementsByName('domicilio')[0];
                if (!input) return;

                autocomplete = new google.maps.places.Autocomplete(input, {
                    types: ['address'],
                    componentRestrictions: { country: 'mx' }
                });

                // Evitar que el formulario se envíe si el usuario presiona Enter en las sugerencias
                input.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                    }
                });

                // 2. Inicializar el mapa
                const mapDiv = document.getElementById('map');
                const defaultCoords = { lat: 21.8853, lng: -102.2916 }; // Aguascalientes, México
                
                map = new google.maps.Map(mapDiv, {
                    center: defaultCoords,
                    zoom: 15,
                    mapTypeControl: true,
                    streetViewControl: true
                });

                marker = new google.maps.Marker({
                    map: map,
                    position: defaultCoords,
                    draggable: true
                });

                marker.addListener('dragend', function() {
                    geocodeLatLng(marker.getPosition());
                });

                // 3. Evento al elegir dirección
                autocomplete.addListener('place_changed', onPlaceChanged);
            }

            function geocodeLatLng(latLng) {
                const geocoder = new google.maps.Geocoder();
                geocoder.geocode({ location: latLng }, function(results, status) {
                    if (status === 'OK') {
                        if (results[0]) {
                            const input = document.getElementsByName('domicilio')[0];
                            input.value = results[0].formatted_address;
                        }
                    }
                });
            }

            function onPlaceChanged() {
                const place = autocomplete.getPlace();
                
                if (!place.geometry || !place.geometry.location) {
                    return;
                }

                // Mostrar el contenedor del mapa
                const mapDiv = document.getElementById('map');
                mapDiv.style.display = 'block';

                // Redimensionar el mapa si estaba oculto
                google.maps.event.trigger(map, 'resize');

                // Ajustar mapa y marcador
                map.setCenter(place.geometry.location);
                map.setZoom(17);
                marker.setPosition(place.geometry.location);
            }
        </script>
    </body>
</html>