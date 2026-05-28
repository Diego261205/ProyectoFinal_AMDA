<%@page import="java.sql.*, modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Edición inhabilitada por requerimiento
    response.sendRedirect("dashboard.jsp");
    if (true) return;

    int idS = Integer.parseInt(request.getParameter("id"));
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Variables para precargar el formulario
    String nombreD = "", nacimiento = "", telefono = "", domicilio = "";
    int edad = 0;
    String tipoMov = "", clienteSolicita = "", marca = "", modelo = "", vin = "", tipoPlaca = "";
    double importe = 0.0;
    int idD = 0;

    try {
        cn = Conexion.conectar();
        String sql = "SELECT s.*, d.* FROM servicios s JOIN duenos d ON s.id_dueno = d.id_dueno WHERE s.id_servicio = ?";
        ps = cn.prepareStatement(sql);
        ps.setInt(1, idS);
        rs = ps.executeQuery();
        if (rs.next()) {
            idD = rs.getInt("id_dueno");
            nombreD = rs.getString("nombre_completo");
            edad = rs.getInt("edad");
            nacimiento = rs.getString("fecha_nacimiento");
            telefono = rs.getString("telefono");
            domicilio = rs.getString("domicilio");
            tipoMov = rs.getString("tipo_movimiento");
            clienteSolicita = rs.getString("cliente_nombre");
            marca = rs.getString("marca");
            modelo = rs.getString("modelo");
            vin = rs.getString("vin");
            tipoPlaca = rs.getString("tipo_placa");
            importe = rs.getDouble("importe");
        } else {
            out.print("<script>alert('El registro no existe.'); window.location='dashboard.jsp';</script>");
            return;
        }
    } catch (Exception e) {
        out.print("Error al cargar datos: " + e.getMessage());
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
        if (ps != null) try { ps.close(); } catch(SQLException ex) {}
        if (cn != null) try { cn.close(); } catch(SQLException ex) {}
    }
%>
<!DOCTYPE html>
<html lang="es-MX">
    <head>
        <title>AMDA - Editar Registro</title>
        <link rel="stylesheet" href="style.css?v=14">
        <!-- Font Awesome para Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Maps API -->
        <%
            String mapKeyEdit = modelo.Env.get("NEXT_PUBLIC_GOOGLE_MAPS_API_KEY");
            if (mapKeyEdit.isEmpty()) {
                mapKeyEdit = modelo.Env.get("GOOGLE_MAPS_API_KEY");
            }
        %>
        <script src="https://maps.googleapis.com/maps/api/js?key=<%= mapKeyEdit %>&libraries=places&callback=initMap" async defer></script>
    </head>
    <body>
        <!-- Header con estilo global -->
        <div class="main-header">
            <h1><i class="fa-solid fa-car-side"></i> AMDA - Control de Servicios</h1>
            <div>
                Bienvenido, <strong><%= session.getAttribute("usuarioLogueado") %></strong> | 
                <a href="index.jsp" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión</a>
            </div>
        </div>

        <div class="content-container">
            <div class="form-container">
                <h2><i class="fa-solid fa-pen-to-square"></i> Modificar Trámite Vehicular (ID: <%= idS %>)</h2>
                <form action="actualizar_servicio.jsp" method="POST">
                    <!-- Enviamos los IDs ocultos para saber qué registros actualizar -->
                    <input type="hidden" name="id_servicio" value="<%= idS %>">
                    <input type="hidden" name="id_dueno" value="<%= idD %>">

                    <div class="grid-form">
                        <section class="form-section">
                            <h3><i class="fa-solid fa-address-card"></i> Datos del Dueño</h3>
                            <label>Nombre Completo:</label>
                            <input type="text" name="nombre_dueno" value="<%= nombreD %>" required>
                            <label>Fecha de Nacimiento:</label>
                            <input type="date" name="nacimiento" value="<%= nacimiento %>" required>
                            
                            <label>Teléfono:</label>
                            <input type="text" name="telefono" value="<%= telefono %>" required>
                            
                            <label>Domicilio:</label>
                            <input type="text" name="domicilio" value="<%= domicilio %>" placeholder="Busca la dirección con Google Maps..." required autocomplete="off">
                            <div id="map" style="width: 100%; height: 250px; margin-top: 12px; border-radius: var(--radius-sm); border: 1px solid var(--border-color);"></div>
                        </section>

                        <section class="form-section">
                            <h3><i class="fa-solid fa-car"></i> Datos del Servicio</h3>
                            <label>Tipo de Movimiento:</label>
                            <select name="tipo_movimiento">
                                <option value="Placa Nueva" <%= "Placa Nueva".equals(tipoMov) ? "selected" : "" %>>Placa Nueva</option>
                                <option value="Permiso de Circulacion" <%= "Permiso de Circulacion".equals(tipoMov) ? "selected" : "" %>>Permiso de Circulación</option>
                            </select>
                            
                            <label>Cliente / Agencia que solicita:</label>
                            <select name="cliente_solicita">
                                <option value="Ford Country" <%= "Ford Country".equals(clienteSolicita) ? "selected" : "" %>>Ford Country</option>
                                <option value="Honda Campestre" <%= "Honda Campestre".equals(clienteSolicita) ? "selected" : "" %>>Honda Campestre</option>
                                <option value="Mercedes-Benz Aguascalientes" <%= "Mercedes-Benz Aguascalientes".equals(clienteSolicita) ? "selected" : "" %>>Mercedes-Benz Aguascalientes</option>
                                <option value="Audi Aguascalientes" <%= "Audi Aguascalientes".equals(clienteSolicita) ? "selected" : "" %>>Audi Aguascalientes</option>
                                <option value="Eurocentro Camionero" <%= "Eurocentro Camionero".equals(clienteSolicita) ? "selected" : "" %>>Eurocentro Camionero</option>
                                <option value="Autodistribuidores del Centro" <%= "Autodistribuidores del Centro".equals(clienteSolicita) ? "selected" : "" %>>Autodistribuidores del Centro</option>
                                <option value="Chevrolet Herrera Motors" <%= "Chevrolet Herrera Motors".equals(clienteSolicita) || "Chevrolet".equals(clienteSolicita) || "Herrera Motors".equals(clienteSolicita) ? "selected" : "" %>>Chevrolet Herrera Motors</option>
                                <option value="Nissan Torres Corzo" <%= "Nissan Torres Corzo".equals(clienteSolicita) ? "selected" : "" %>>Nissan Torres Corzo</option>
                                <option value="Toyota Aguascalientes" <%= "Toyota Aguascalientes".equals(clienteSolicita) ? "selected" : "" %>>Toyota Aguascalientes</option>
                                <option value="BMW Aguascalientes" <%= "BMW Aguascalientes".equals(clienteSolicita) ? "selected" : "" %>>BMW Aguascalientes</option>
                            </select>
                            
                            <label>Marca:</label>
                            <input type="text" name="marca" value="<%= marca %>" required>
                            
                            <label>Modelo:</label>
                            <input type="text" name="modelo" value="<%= modelo %>" required>
                            
                            <label>VIN (N° de Serie):</label>
                            <input type="text" name="vin" value="<%= vin %>" maxlength="17" required>
                            
                            <label>Tipo de Placa:</label>
                            <input type="text" name="tipo_placa" value="<%= tipoPlaca %>">
                            
                            <label>Importe a Cobrar ($):</label>
                            <input type="number" step="0.01" name="importe" value="<%= importe %>" required>
                        </section>
                    </div>
                    
                    <div style="margin-top: 25px; text-align: right; display: flex; justify-content: flex-end; gap: 12px; align-items: center;">
                        <a href="dashboard.jsp" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Cancelar</a>
                        <button type="submit" class="btn btn-warning" style="background-color: #f59e0b;"><i class="fa-solid fa-floppy-disk"></i> Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>

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

                // Si ya hay una dirección escrita (caso de edición), centrar el mapa al inicio
                if (input.value.trim() !== "") {
                    geocodeAddress(input.value);
                }
            }

            function geocodeAddress(address) {
                const geocoder = new google.maps.Geocoder();
                geocoder.geocode({ address: address }, function(results, status) {
                    if (status === 'OK') {
                        const mapDiv = document.getElementById('map');
                        mapDiv.style.display = 'block';
                        
                        google.maps.event.trigger(map, 'resize');
                        map.setCenter(results[0].geometry.location);
                        map.setZoom(17);
                        marker.setPosition(results[0].geometry.location);
                    }
                });
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
