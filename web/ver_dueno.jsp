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
        <title>AMDA - Datos del Propietario</title>
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
            <div class="ficha-container">
                <h2><i class="fa-solid fa-user" aria-hidden="true"></i> Datos del Propietario</h2>
                <%
                    int idD = Integer.parseInt(request.getParameter("id"));
                    Connection cn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        cn = Conexion.conectar();
                        String sql = "SELECT * FROM duenos WHERE id_dueno = ?";
                        ps = cn.prepareStatement(sql);
                        ps.setInt(1, idD);
                        rs = ps.executeQuery();
                        if(rs.next()){
                %>
                <div class="dato">
                    <span class="etiqueta"><i class="fa-solid fa-signature"></i> Nombre Completo:</span>
                    <span class="valor"><%= rs.getString("nombre_completo") %></span>
                </div>
                <div class="dato">
                    <span class="etiqueta"><i class="fa-solid fa-calendar-days"></i> Fecha de Nacimiento:</span>
                    <span class="valor"><%= rs.getDate("fecha_nacimiento") %></span>
                </div>
                <div class="dato">
                    <span class="etiqueta"><i class="fa-solid fa-phone"></i> Teléfono:</span>
                    <span class="valor"><%= rs.getString("telefono") %></span>
                </div>
                <div class="dato">
                    <span class="etiqueta"><i class="fa-solid fa-location-dot"></i> Domicilio:</span>
                    <span class="valor"><%= rs.getString("domicilio") %></span>
                </div>
                
                <div style="text-align: center; margin-top: 30px;">
                    <a href="dashboard.jsp" class="btn btn-primary"><i class="fa-solid fa-arrow-left"></i> Volver al Panel</a>
                </div>
                <%
                        }
                    } catch(Exception e) {
                        out.print("<p style='color:var(--warning-text);'><i class='fa-solid fa-triangle-exclamation'></i> Ocurrió un error al cargar los datos. Intenta de nuevo.</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
                        if (ps != null) try { ps.close(); } catch(SQLException ex) {}
                        if (cn != null) try { cn.close(); } catch(SQLException ex) {}
                    }
                %>
            </div>
        </main>
    </body>
</html>