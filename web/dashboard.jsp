<%@page import="java.sql.*, modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>AMDA - Panel Principal</title>
        <link rel="stylesheet" href="style.css">
        <style>
            table th, table td { padding: 12px; border: 1px solid #ddd; text-align: center; }
            .btn-pago { font-size: 11px; color: #004a99; text-decoration: underline; cursor: pointer; display: block; margin-top: 4px; }
            tr:hover { background-color: #f9f9f9; }
            .search-box { padding: 10px; width: 300px; border: 1px solid #004a99; border-radius: 5px; }
        </style>
    </head>
    <body>
        <div style="background-color: #004a99; color: white; padding: 15px; display: flex; justify-content: space-between; align-items: center;">
            <h1 style="margin: 0;">AMDA - Control de Servicios</h1>
            <div>
                Bienvenido, <b><%= session.getAttribute("usuarioLogueado") %></b> | 
                <a href="index.jsp" style="color: white; text-decoration: none;">Cerrar Sesión</a>
            </div>
        </div>

        <div style="padding: 20px;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                <a href="agregar_registro.jsp">
                    <button style="background-color: #004a99; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">
                        + Agregar Registro
                    </button>
                </a>

                <form action="dashboard.jsp" method="GET">
                    <input type="text" name="txtBuscar" class="search-box" placeholder="Buscar VIN, Cliente o Placa..." 
                           value="<%= (request.getParameter("txtBuscar")!=null) ? request.getParameter("txtBuscar") : "" %>">
                    <button type="submit" style="padding: 10px; background: #004a99; color: white; border: none; border-radius: 5px; cursor: pointer;">Buscar</button>
                    <a href="dashboard.jsp" style="margin-left: 10px; color: #666; text-decoration: none; font-size: 13px;">Limpiar</a>
                </form>
            </div>

            <table style="width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                <thead>
                    <tr style="background: #004a99; color: white;">
                        <th>ID</th>
                        <th>Movimiento</th>
                        <th>Vehículo</th>
                        <th>VIN</th>
                        <th>Placa</th>
                        <th>Fecha</th>
                        <th>Importe</th>
                        <th>Cliente / Agencia</th>
                        <th>Estatus</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection cn = Conexion.conectar();
                            String buscar = request.getParameter("txtBuscar");
                            String sql;
                            PreparedStatement ps;

                            if (buscar == null || buscar.trim().isEmpty()) {
                                sql = "SELECT s.*, d.nombre_completo FROM servicios s JOIN duenos d ON s.id_dueno = d.id_dueno ORDER BY s.id_servicio DESC";
                                ps = cn.prepareStatement(sql);
                            } else {
                                sql = "SELECT s.*, d.nombre_completo FROM servicios s JOIN duenos d ON s.id_dueno = d.id_dueno " +
                                      "WHERE s.vin LIKE ? OR s.cliente_nombre LIKE ? OR s.tipo_placa LIKE ? OR d.nombre_completo LIKE ? " +
                                      "ORDER BY s.id_servicio DESC";
                                ps = cn.prepareStatement(sql);
                                String f = "%" + buscar + "%";
                                ps.setString(1, f); ps.setString(2, f); ps.setString(3, f); ps.setString(4, f);
                            }

                            ResultSet rs = ps.executeQuery();
                            while(rs.next()) {
                                boolean pagado = rs.getBoolean("pagado");
                    %>
                    <tr>
                        <td><%= rs.getInt("id_servicio") %></td>
                        <td><%= rs.getString("tipo_movimiento") %></td>
                        <td><%= rs.getString("marca") %> <%= rs.getString("modelo") %></td>
                        <td><small><%= rs.getString("vin") %></small></td>
                        <td><%= rs.getString("tipo_placa") %></td>
                        <td><%= rs.getDate("fecha_tramite") %></td>
                        <td style="font-weight: bold;">$<%= rs.getDouble("importe") %></td>
                        <td><%= rs.getString("cliente_nombre") %></td>
                        <td>
                            <% if(pagado) { %>
                                <b style="color: green;">PAGADO</b>
                            <% } else { %>
                                <b style="color: red;">PENDIENTE</b>
                                <a href="procesar_pago.jsp?id=<%= rs.getInt("id_servicio") %>" class="btn-pago" onclick="return confirm('¿Confirmar pago?')">Marcar Pago</a>
                            <% } %>
                        </td>
                        <td>
                            <a href="ver_dueno.jsp?id=<%= rs.getInt("id_dueno") %>" 
                               style="background: #004a99; color: white; padding: 4px 8px; text-decoration: none; border-radius: 3px; font-size: 12px;">
                               Dueño
                            </a>
                        </td>
                    </tr>
                    <% 
                            }
                            cn.close();
                        } catch(Exception e) { out.print("Error: " + e.getMessage()); }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>