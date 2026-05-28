<%@page import="java.sql.*, modelo.Conexion"%>
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
        <title>AMDA - Panel Principal</title>
        <link rel="stylesheet" href="style.css?v=14">
        <!-- Font Awesome para Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            <%
                String buscar = request.getParameter("txtBuscar");
                String filtro = request.getParameter("filtro");
                if (filtro == null) filtro = "todos";
            %>
            
            <div class="filter-bar" style="display: flex; flex-direction: column; gap: 16px; align-items: stretch;">
                <!-- Fila 1: Botones de Acción y Filtros de Estatus -->
                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                    <div style="display: flex; gap: 10px;">
                        <a href="agregar_registro.jsp" class="btn btn-primary" style="font-weight: bold; padding: 12px 24px;">
                            <i class="fa-solid fa-plus"></i> Agregar Registro
                        </a>
                        <a href="reportes.jsp" class="btn btn-success" style="font-weight: bold; padding: 12px 24px;">
                            <i class="fa-solid fa-file-pdf"></i> Descargar Reportes
                        </a>
                    </div>

                    <div class="filter-group">
                        <span style="font-weight: bold; color: var(--text-muted);">Mostrar:</span>
                        <a href="dashboard.jsp?filtro=todos" 
                           class="filter-pill <%= "todos".equals(filtro) ? "active todos" : "" %>">
                           <i class="fa-solid fa-list"></i> Ver Todos
                        </a>
                        <a href="dashboard.jsp?filtro=pendientes" 
                           class="filter-pill <%= "pendientes".equals(filtro) ? "active pendientes" : "" %>">
                           <i class="fa-solid fa-circle-exclamation"></i> Pendientes
                        </a>
                        <a href="dashboard.jsp?filtro=pagados" 
                           class="filter-pill <%= "pagados".equals(filtro) ? "active pagados" : "" %>">
                           <i class="fa-solid fa-circle-check"></i> Pagados
                        </a>
                    </div>
                </div>

                <!-- Línea separadora sutil -->
                <div style="border-top: 1px solid var(--border-color); width: 100%;"></div>

                <!-- Fila 2: Filtros de Agencia, Trámite, Ordenar y Buscador -->
                <div class="dashboard-controls-row">
                    <!-- Buscador en tiempo real -->
                    <div class="search-wrapper">
                        <input type="text" id="txtBuscar" oninput="filterTableDebounced();" class="search-input-dashboard" placeholder="Buscar por nombre, VIN, agencia..." value="<%= (buscar!=null) ? buscar : "" %>">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </div>

                    <!-- Filtro Agencia -->
                    <div class="filter-item-wrapper">
                        <span class="filter-label"><i class="fa-solid fa-car-side"></i> Agencia:</span>
                        <select id="filtroAgencia" onchange="filterTable();" class="dashboard-select" style="width: 200px;">
                            <option value="TODAS">-- Todas las Agencias --</option>
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
                    </div>

                    <!-- Filtro Trámite -->
                    <div class="filter-item-wrapper">
                        <span class="filter-label"><i class="fa-solid fa-route"></i> Trámite:</span>
                        <select id="filtroMovimiento" onchange="filterTable();" class="dashboard-select" style="width: 150px;">
                            <option value="TODOS">-- Todos --</option>
                            <option value="Placa Nueva">Placa Nueva</option>
                            <option value="Permiso de Circulacion">Permiso de Circulación</option>
                        </select>
                    </div>

                    <div class="filter-item-wrapper">
                        <span class="filter-label"><i class="fa-solid fa-arrow-down-a-z"></i> Ordenar:</span>
                        <select id="ordenarPor" onchange="sortTable();" class="dashboard-select" style="width: 310px;">
                            <option value="DEFAULT">Orden de registro (Recientes primero)</option>
                            <option value="ANTIGUEDAD_ASC">Fecha de trámite (Antiguos primero)</option>
                            <option value="ANTIGUEDAD_DESC">Fecha de trámite (Recientes primero)</option>
                            <option value="CLIENTE_AZ">Cliente / Agencia (A-Z)</option>
                            <option value="CLIENTE_ZA">Cliente / Agencia (Z-A)</option>
                            <option value="VEHICULO_AZ">Marca (A-Z)</option>
                        </select>
                    </div>
                    <!-- Botón Limpiar -->
                    <button type="button" onclick="clearFilters();" class="btn btn-secondary btn-dashboard-clean" aria-label="Limpiar filtros">
                        <i class="fa-solid fa-rotate-left"></i> Limpiar
                    </button>
                </div>
            </div>

            <div class="table-container">
                <table class="table-dashboard">
                    <thead>
                        <tr>
                            <th class="col-id" scope="col">ID</th>
                            <th scope="col">Movimiento</th>
                            <th scope="col">Vehículo</th>
                            <th class="col-vin" scope="col">VIN</th>
                            <th class="col-placa" scope="col">Placa</th>
                            <th scope="col">Fecha</th>
                            <th scope="col">Importe</th>
                            <th scope="col">Cliente / Agencia</th>
                            <th scope="col">Estatus</th>
                            <th scope="col">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection cn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            try {
                                cn = Conexion.conectar();
                                String sql = "SELECT s.*, d.nombre_completo FROM servicios s JOIN duenos d ON s.id_dueno = d.id_dueno WHERE 1=1";
                                
                                if (filtro.equals("pendientes")) {
                                    sql += " AND s.pagado = FALSE";
                                } else if (filtro.equals("pagados")) {
                                    sql += " AND s.pagado = TRUE";
                                }
                                sql += " ORDER BY s.id_servicio DESC";

                                ps = cn.prepareStatement(sql);
                                rs = ps.executeQuery();
                                while(rs.next()) {
                                    boolean pagado = rs.getBoolean("pagado");
                        %>
                        <tr>
                            <td class="col-id" style="white-space: nowrap;"><%= rs.getInt("id_servicio") %></td>
                            <td style="font-weight: 500; white-space: nowrap;"><%= rs.getString("tipo_movimiento") %></td>
                            <td style="white-space: nowrap;"><strong><%= rs.getString("marca") %></strong> <%= rs.getString("modelo") %></td>
                            <td class="col-vin" style="white-space: nowrap;"><code style="font-size: 13px; font-weight: bold; color: var(--text-muted);"><%= rs.getString("vin") %></code></td>
                            <td class="col-placa" style="white-space: nowrap;"><span style="font-weight: 500;"><%= rs.getString("tipo_placa") %></span></td>
                            <td style="white-space: nowrap;"><%= rs.getDate("fecha_tramite") %></td>
                            <td style="font-weight: bold; color: var(--primary); white-space: nowrap;">$ <%= String.format("%,.2f", rs.getDouble("importe")) %></td>
                            <td style="white-space: nowrap;">
                                <%
                                    String agencyName = rs.getString("cliente_nombre");
                                    if ("Chevrolet".equals(agencyName) || "Herrera Motors".equals(agencyName)) {
                                        agencyName = "Chevrolet Herrera Motors";
                                    }
                                %>
                                <%= agencyName %>
                            </td>
                            <td style="white-space: nowrap;">
                                <% if(pagado) { %>
                                    <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> Pagado</span>
                                <% } else { %>
                                    <span class="badge badge-warning"><i class="fa-solid fa-circle-exclamation"></i> Pendiente</span>
                                    <a href="procesar_pago.jsp?id=<%= rs.getInt("id_servicio") %>" class="btn-pago-link" onclick="return confirm('¿Registrar el pago de este trámite? Esta acción no se puede deshacer.')"><i class="fa-solid fa-circle-check"></i> Registrar Pago</a>
                                <% } %>
                            </td>
                            <td style="white-space: nowrap;">
                                <div style="display: inline-flex; gap: 10px; align-items: center;">
                                    <a href="ver_dueno.jsp?id=<%= rs.getInt("id_dueno") %>" class="btn-action-sm btn-secondary" title="Ver datos del propietario">
                                       <i class="fa-solid fa-user"></i> Propietario
                                    </a>
                                    <span style="width: 1px; height: 28px; background: var(--border-color); display: inline-block;"></span>
                                    <a href="eliminar_servicio.jsp?id=<%= rs.getInt("id_servicio") %>" class="btn-action-sm btn-danger" title="Eliminar registro permanentemente"
                                       onclick="return confirm('¿Eliminar este trámite?\n\nEsta acción es permanente y no se puede deshacer.')">
                                       <i class="fa-solid fa-trash-can"></i> Eliminar
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <% 
                                }
                            } catch(Exception e) {
                                out.print("<tr><td colspan='10' style='text-align:center;padding:30px;color:var(--warning-text);'><i class='fa-solid fa-triangle-exclamation'></i> Ocurrió un error al cargar los registros. Recarga la página o contacta al administrador.</td></tr>");
                            } finally {
                                if (rs != null) try { rs.close(); } catch(SQLException ex) {}
                                if (ps != null) try { ps.close(); } catch(SQLException ex) {}
                                if (cn != null) try { cn.close(); } catch(SQLException ex) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </main>

        <!-- Script de Búsqueda y Filtrado Asíncrono en Tiempo Real -->
        <script>
            let filterDebounce;
            function filterTableDebounced() {
                clearTimeout(filterDebounce);
                filterDebounce = setTimeout(filterTable, 200);
            }

            function filterTable() {
                const searchQuery = document.getElementById('txtBuscar').value.toLowerCase().trim();
                const selectedAgency = document.getElementById('filtroAgencia').value;
                const selectedMov = document.getElementById('filtroMovimiento').value;

                const rows = document.querySelectorAll('.table-dashboard tbody tr');

                rows.forEach(row => {
                    // Ignorar fila de "No hay registros" si existe
                    if (row.classList.contains('no-records-row')) {
                        return;
                    }

                    // Obtener los valores de las celdas
                    const id = row.cells[0].textContent.toLowerCase();
                    const movimiento = row.cells[1].textContent.trim(); // e.g. "Placa Nueva"
                    const vehiculo = row.cells[2].textContent.toLowerCase(); // brand and model
                    const vin = row.cells[3].textContent.toLowerCase();
                    const placa = row.cells[4].textContent.toLowerCase();
                    const fecha = row.cells[5].textContent.toLowerCase();
                    const clienteAgencia = row.cells[7].textContent.trim(); // agency name
                    
                    // Comprobar coincidencia de búsqueda (searchQuery)
                    const matchesSearch = searchQuery === "" || 
                        id.includes(searchQuery) ||
                        movimiento.toLowerCase().includes(searchQuery) ||
                        vehiculo.includes(searchQuery) ||
                        vin.includes(searchQuery) ||
                        placa.includes(searchQuery) ||
                        clienteAgencia.toLowerCase().includes(searchQuery);

                    // Comprobar coincidencia de Agencia
                    const matchesAgency = selectedAgency === "TODAS" || clienteAgencia === selectedAgency;

                    // Comprobar coincidencia de Movimiento
                    const matchesMov = selectedMov === "TODOS" || movimiento === selectedMov;

                    if (matchesSearch && matchesAgency && matchesMov) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });

                // Mostrar fila de "No se encontraron registros" si todas las filas están ocultas
                const visibleRows = Array.from(rows).filter(r => r.style.display !== "none" && !r.classList.contains('no-records-row'));
                const noRecordsRow = document.getElementById('noRecordsRow');
                if (visibleRows.length === 0) {
                    if (!noRecordsRow) {
                        const tbody = document.querySelector('.table-dashboard tbody');
                        const newRow = document.createElement('tr');
                        newRow.id = 'noRecordsRow';
                        newRow.classList.add('no-records-row');
                        newRow.innerHTML = '<td colspan="10" style="text-align: center; padding: 30px; color: var(--text-muted);"><i class="fa-solid fa-circle-info"></i> No se encontraron registros con los filtros aplicados.</td>';
                        tbody.appendChild(newRow);
                    } else {
                        noRecordsRow.style.display = "";
                    }
                } else {
                    if (noRecordsRow) {
                        noRecordsRow.style.display = "none";
                    }
                }
            }

            function clearFilters() {
                document.getElementById('txtBuscar').value = "";
                document.getElementById('filtroAgencia').value = "TODAS";
                document.getElementById('filtroMovimiento').value = "TODOS";
                document.getElementById('ordenarPor').value = "DEFAULT";
                filterTable();
                sortTable();
            }

            function sortTable() {
                const sortBy = document.getElementById('ordenarPor').value;
                const tbody = document.querySelector('.table-dashboard tbody');
                const rows = Array.from(tbody.querySelectorAll('tr')).filter(r => !r.classList.contains('no-records-row') && r.id !== 'noRecordsRow');

                if (sortBy === "DEFAULT") {
                    rows.sort((a, b) => {
                        const idA = parseInt(a.cells[0].textContent.trim());
                        const idB = parseInt(b.cells[0].textContent.trim());
                        return idB - idA;
                    });
                } else if (sortBy === "ANTIGUEDAD_ASC") {
                    rows.sort((a, b) => {
                        const dateA = a.cells[5].textContent.trim();
                        const dateB = b.cells[5].textContent.trim();
                        if (dateA !== dateB) {
                            return dateA.localeCompare(dateB);
                        }
                        const idA = parseInt(a.cells[0].textContent.trim());
                        const idB = parseInt(b.cells[0].textContent.trim());
                        return idA - idB;
                    });
                } else if (sortBy === "ANTIGUEDAD_DESC") {
                    rows.sort((a, b) => {
                        const dateA = a.cells[5].textContent.trim();
                        const dateB = b.cells[5].textContent.trim();
                        if (dateA !== dateB) {
                            return dateB.localeCompare(dateA);
                        }
                        const idA = parseInt(a.cells[0].textContent.trim());
                        const idB = parseInt(b.cells[0].textContent.trim());
                        return idB - idA;
                    });
                } else if (sortBy === "CLIENTE_AZ") {
                    rows.sort((a, b) => {
                        const clientA = a.cells[7].textContent.trim().toLowerCase();
                        const clientB = b.cells[7].textContent.trim().toLowerCase();
                        return clientA.localeCompare(clientB, 'es', { sensitivity: 'base' });
                    });
                } else if (sortBy === "CLIENTE_ZA") {
                    rows.sort((a, b) => {
                        const clientA = a.cells[7].textContent.trim().toLowerCase();
                        const clientB = b.cells[7].textContent.trim().toLowerCase();
                        return clientB.localeCompare(clientA, 'es', { sensitivity: 'base' });
                    });
                } else if (sortBy === "VEHICULO_AZ") {
                    rows.sort((a, b) => {
                        const valA = a.cells[2].textContent.trim().toLowerCase();
                        const valB = b.cells[2].textContent.trim().toLowerCase();
                        return valA.localeCompare(valB, 'es', { sensitivity: 'base' });
                    });
                }

                rows.forEach(row => tbody.appendChild(row));
            }

            // Ejecutar filtrado inicial al cargar el DOM
            window.addEventListener('DOMContentLoaded', () => {
                filterTable();
                sortTable();
            });
        </script>
    </body>
</html>