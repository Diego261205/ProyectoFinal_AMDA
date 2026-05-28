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
        <title>AMDA - Reportes</title>
        <link rel="stylesheet" href="style.css?v=14">
        <!-- Font Awesome para Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <style>
            /* Estilos específicos para esta pantalla */
            .report-card {
                background: var(--card-bg);
                padding: 24px;
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                margin-bottom: 24px;
            }
            .filter-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 16px;
                align-items: flex-end;
            }
            
            /* CSS para la impresión (PDF) */
            @media print {
                @page {
                    size: landscape;
                    margin: 10mm;
                }
                body {
                    background: white;
                    color: black;
                    font-size: 10px;
                }
                .main-header, .filter-bar, .report-card, .btn, .no-print {
                    display: none !important;
                }
                .content-container {
                    padding: 0 !important;
                    margin: 0 !important;
                    max-width: 100% !important;
                    width: 100% !important;
                }
                .print-header {
                    display: block !important;
                    text-align: center;
                    margin-bottom: 20px;
                    border-bottom: 2px solid #333;
                    padding-bottom: 10px;
                }
                .print-header h2 {
                    margin: 0 0 5px 0;
                    font-size: 18px;
                    color: black !important;
                }
                .print-header p {
                    margin: 0;
                    color: #555;
                    font-size: 10px;
                }
                .table-container {
                    box-shadow: none !important;
                    border: none !important;
                    overflow: visible !important;
                    width: 100% !important;
                }
                table {
                    width: 100% !important;
                    border: 1px solid #000 !important;
                    border-collapse: collapse !important;
                }
                table th {
                    background-color: #f1f5f9 !important;
                    color: black !important;
                    border: 1px solid #000 !important;
                    font-size: 9px;
                    padding: 6px 8px !important;
                }
                table td {
                    border-bottom: 1px solid #000 !important;
                    border-right: 1px solid #000 !important;
                    font-size: 9px;
                    padding: 6px 8px !important;
                    white-space: normal !important;
                    word-break: break-word !important;
                }
                table td code {
                    word-break: break-all !important;
                }
                table tr {
                    page-break-inside: avoid;
                }
            }
            
            /* Encabezado de impresión oculto en pantalla */
            .print-header {
                display: none;
            }
        </style>
    </head>
    <body>
        <header class="main-header no-print">
            <h1><i class="fa-solid fa-car-side"></i> AMDA - Control de Servicios</h1>
            <div>
                Bienvenido, <strong><%= session.getAttribute("usuarioLogueado") %></strong> |
                <a href="index.jsp" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión</a>
            </div>
        </header>

        <main class="content-container">
            <!-- Título de la página -->
            <div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2 style="margin: 0; font-weight: 700; color: var(--primary);"><i class="fa-solid fa-file-invoice"></i> Generar Reporte de Movimientos</h2>
                <a href="dashboard.jsp" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Volver al Panel</a>
            </div>

            <!-- Filtros Personalizados -->
            <div class="report-card no-print">
                <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 16px; color: var(--text-muted);"><i class="fa-solid fa-filter"></i> Filtros de Reporte</h3>
                <%
                    String fAgencia = request.getParameter("filtro_agencia");
                    String fMov = request.getParameter("filtro_movimiento");
                    String fEstatus = request.getParameter("filtro_estatus");
                    String fOrden = request.getParameter("filtro_orden");
                    
                    if (fAgencia == null) fAgencia = "TODAS";
                    if (fMov == null) fMov = "TODOS";
                    if (fEstatus == null) fEstatus = "TODOS";
                    if (fOrden == null) fOrden = "DEFAULT";
                %>
                <form action="reportes.jsp" method="GET" class="filter-grid">
                    <div>
                        <label style="margin-top: 0;">Agencia / Cliente:</label>
                        <select name="filtro_agencia">
                            <option value="TODAS" <%= "TODAS".equals(fAgencia) ? "selected" : "" %>>-- Todas las Agencias --</option>
                            <option value="Ford Country" <%= "Ford Country".equals(fAgencia) ? "selected" : "" %>>Ford Country</option>
                            <option value="Honda Campestre" <%= "Honda Campestre".equals(fAgencia) ? "selected" : "" %>>Honda Campestre</option>
                            <option value="Mercedes-Benz Aguascalientes" <%= "Mercedes-Benz Aguascalientes".equals(fAgencia) ? "selected" : "" %>>Mercedes-Benz Aguascalientes</option>
                            <option value="Audi Aguascalientes" <%= "Audi Aguascalientes".equals(fAgencia) ? "selected" : "" %>>Audi Aguascalientes</option>
                            <option value="Eurocentro Camionero" <%= "Eurocentro Camionero".equals(fAgencia) ? "selected" : "" %>>Eurocentro Camionero</option>
                            <option value="Autodistribuidores del Centro" <%= "Autodistribuidores del Centro".equals(fAgencia) ? "selected" : "" %>>Autodistribuidores del Centro</option>
                            <option value="Chevrolet Herrera Motors" <%= "Chevrolet Herrera Motors".equals(fAgencia) || "Chevrolet".equals(fAgencia) || "Herrera Motors".equals(fAgencia) ? "selected" : "" %>>Chevrolet Herrera Motors</option>
                            <option value="Nissan Torres Corzo" <%= "Nissan Torres Corzo".equals(fAgencia) ? "selected" : "" %>>Nissan Torres Corzo</option>
                            <option value="Toyota Aguascalientes" <%= "Toyota Aguascalientes".equals(fAgencia) ? "selected" : "" %>>Toyota Aguascalientes</option>
                            <option value="BMW Aguascalientes" <%= "BMW Aguascalientes".equals(fAgencia) ? "selected" : "" %>>BMW Aguascalientes</option>
                        </select>
                    </div>
                    <div>
                        <label style="margin-top: 0;">Tipo de Trámite:</label>
                        <select name="filtro_movimiento">
                            <option value="TODOS" <%= "TODOS".equals(fMov) ? "selected" : "" %>>-- Todos los Trámites --</option>
                            <option value="Placa Nueva" <%= "Placa Nueva".equals(fMov) ? "selected" : "" %>>Placa Nueva</option>
                            <option value="Permiso de Circulacion" <%= "Permiso de Circulacion".equals(fMov) ? "selected" : "" %>>Permiso de Circulación</option>
                        </select>
                    </div>
                    <div>
                        <label style="margin-top: 0;">Estatus del Pago:</label>
                        <select name="filtro_estatus">
                            <option value="TODOS" <%= "TODOS".equals(fEstatus) ? "selected" : "" %>>-- Todos los Estatus --</option>
                            <option value="PAGADO" <%= "PAGADO".equals(fEstatus) ? "selected" : "" %>>Solo Pagados</option>
                            <option value="PENDIENTE" <%= "PENDIENTE".equals(fEstatus) ? "selected" : "" %>>Solo Pendientes</option>
                        </select>
                    </div>
                    <div>
                        <label style="margin-top: 0;">Ordenar por:</label>
                        <select name="filtro_orden" id="ordenarPor" onchange="sortTable();">
                            <option value="DEFAULT" <%= "DEFAULT".equals(fOrden) ? "selected" : "" %>>Orden de registro (Recientes primero)</option>
                            <option value="ANTIGUEDAD_ASC" <%= "ANTIGUEDAD_ASC".equals(fOrden) ? "selected" : "" %>>Fecha de trámite (Antiguos primero)</option>
                            <option value="ANTIGUEDAD_DESC" <%= "ANTIGUEDAD_DESC".equals(fOrden) ? "selected" : "" %>>Fecha de trámite (Recientes primero)</option>
                            <option value="CLIENTE_AZ" <%= "CLIENTE_AZ".equals(fOrden) ? "selected" : "" %>>Cliente / Agencia (A-Z)</option>
                            <option value="CLIENTE_ZA" <%= "CLIENTE_ZA".equals(fOrden) ? "selected" : "" %>>Cliente / Agencia (Z-A)</option>
                            <option value="VEHICULO_AZ" <%= "VEHICULO_AZ".equals(fOrden) ? "selected" : "" %>>Marca (A-Z)</option>
                        </select>
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;"><i class="fa-solid fa-filter"></i> Filtrar</button>
                        <button type="button" class="btn btn-success" onclick="window.print()" style="flex: 1;"><i class="fa-solid fa-file-pdf"></i> Guardar PDF</button>
                    </div>
                </form>
            </div>

            <!-- Membrete para el PDF impreso (oculto en pantalla) -->
            <div class="print-header">
                <h2>Asociación Mexicana de Distribuidores de Automotores</h2>
                <p>Reporte de Trámites y Movimientos Vehiculares (AMDA)</p>
                <p style="font-size: 10px; margin-top: 5px;">Generado el: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></p>
            </div>

            <!-- Vista Previa de la Tabla -->
            <div class="no-print" style="margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center;">
                <span style="font-weight: 600; color: var(--text-muted);"><i class="fa-solid fa-eye"></i> Vista Previa del Reporte:</span>
                <span style="font-size: 13px; color: var(--text-muted);"><i class="fa-solid fa-info-circle"></i> Los botones y barras desaparecerán automáticamente al guardar en PDF.</span>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Movimiento</th>
                            <th scope="col">Vehículo</th>
                            <th scope="col">VIN</th>
                            <th scope="col">Placa</th>
                            <th scope="col">Fecha</th>
                            <th scope="col">Importe</th>
                            <th scope="col">Agencia / Cliente</th>
                            <th scope="col">Estatus</th>
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
                                
                                if (!fAgencia.equals("TODAS")) {
                                    if ("Chevrolet Herrera Motors".equals(fAgencia)) {
                                        sql += " AND (s.cliente_nombre = ? OR s.cliente_nombre = 'Chevrolet' OR s.cliente_nombre = 'Herrera Motors')";
                                    } else {
                                        sql += " AND s.cliente_nombre = ?";
                                    }
                                }
                                if (!fMov.equals("TODOS")) {
                                    sql += " AND s.tipo_movimiento = ?";
                                }
                                if (fEstatus.equals("PAGADO")) {
                                    sql += " AND s.pagado = TRUE";
                                } else if (fEstatus.equals("PENDIENTE")) {
                                    sql += " AND s.pagado = FALSE";
                                }
                                
                                sql += " ORDER BY s.id_servicio DESC";
                                ps = cn.prepareStatement(sql);
                                
                                int paramIdx = 1;
                                if (!fAgencia.equals("TODAS")) {
                                    ps.setString(paramIdx++, fAgencia);
                                }
                                if (!fMov.equals("TODOS")) {
                                    ps.setString(paramIdx++, fMov);
                                }
                                
                                rs = ps.executeQuery();
                                boolean hasData = false;
                                while (rs.next()) {
                                    hasData = true;
                                    boolean pagado = rs.getBoolean("pagado");
                        %>
                        <tr>
                            <td style="white-space: nowrap;"><%= rs.getInt("id_servicio") %></td>
                            <td style="white-space: nowrap;"><%= rs.getString("tipo_movimiento") %></td>
                            <td style="white-space: nowrap;"><strong><%= rs.getString("marca") %></strong> <%= rs.getString("modelo") %></td>
                            <td style="white-space: nowrap;"><code><%= rs.getString("vin") %></code></td>
                            <td style="white-space: nowrap;"><%= rs.getString("tipo_placa") %></td>
                            <td style="white-space: nowrap;"><%= rs.getDate("fecha_tramite") %></td>
                            <td style="font-weight: bold; white-space: nowrap;">$ <%= String.format("%,.2f", rs.getDouble("importe")) %></td>
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
                                <% if (pagado) { %>
                                    <span class="badge badge-success"><i class="fa-solid fa-circle-check"></i> Pagado</span>
                                <% } else { %>
                                    <span class="badge badge-warning"><i class="fa-solid fa-circle-exclamation"></i> Pendiente</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                                if (!hasData) {
                                    out.print("<tr><td colspan='9' style='text-align: center; padding: 30px;'>No se encontraron registros con los filtros seleccionados.</td></tr>");
                                }
                            } catch (Exception e) {
                                out.print("<tr><td colspan='9' style='text-align:center;padding:30px;color:var(--warning-text);'><i class='fa-solid fa-triangle-exclamation'></i> Ocurrió un error al generar el reporte. Intenta de nuevo.</td></tr>");
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException ex) {}
                                if (ps != null) try { ps.close(); } catch (SQLException ex) {}
                                if (cn != null) try { cn.close(); } catch (SQLException ex) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </main>

        <script>
            function sortTable() {
                const sortBy = document.getElementById('ordenarPor').value;
                const tbody = document.querySelector('.table-container table tbody');
                if (!tbody) return;
                
                const rows = Array.from(tbody.querySelectorAll('tr'));
                if (rows.length <= 1) {
                    if (rows.length === 0 || rows[0].cells.length < 9) {
                        return;
                    }
                }

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

            window.addEventListener('DOMContentLoaded', () => {
                sortTable();
            });
        </script>
    </body>
</html>
