<%@page import="java.sql.*, modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>AMDA - Detalle del Dueño</title>
        <link rel="stylesheet" href="style.css">
        <style>
            .ficha-container { width: 500px; margin: 50px auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
            .dato { margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 5px; }
            .etiqueta { font-weight: bold; color: #004a99; display: block; font-size: 0.9em; }
            .valor { font-size: 1.1em; color: #333; }
        </style>
    </head>
    <body>
        <div class="ficha-container">
            <h2 style="color: #004a99; text-align: center; border-bottom: 2px solid #004a99; padding-bottom: 10px;">Expediente del Propietario</h2>
            <%
                int idD = Integer.parseInt(request.getParameter("id"));
                try {
                    Connection cn = Conexion.conectar();
                    String sql = "SELECT * FROM duenos WHERE id_dueno = ?";
                    PreparedStatement ps = cn.prepareStatement(sql);
                    ps.setInt(1, idD);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()){
            %>
            <div class="dato">
                <span class="etiqueta">Nombre Completo:</span>
                <span class="valor"><%= rs.getString("nombre_completo") %></span>
            </div>
            <div class="dato">
                <span class="etiqueta">Edad:</span>
                <span class="valor"><%= rs.getInt("edad") %> años</span>
            </div>
            <div class="dato">
                <span class="etiqueta">Fecha de Nacimiento:</span>
                <span class="valor"><%= rs.getDate("fecha_nacimiento") %></span>
            </div>
            <div class="dato">
                <span class="etiqueta">Teléfono de Contacto:</span>
                <span class="valor"><%= rs.getString("telefono") %></span>
            </div>
            <div class="dato">
                <span class="etiqueta">Domicilio Registrado:</span>
                <span class="valor"><%= rs.getString("domicilio") %></span>
            </div>
            
            <div style="text-align: center; margin-top: 25px;">
                <a href="dashboard.jsp" style="background-color: #004a99; color: white; padding: 10px 25px; text-decoration: none; border-radius: 5px;">Volver al Panel</a>
            </div>
            <%
                    }
                    cn.close();
                } catch(Exception e) { out.print("Error: " + e.getMessage()); }
            %>
        </div>
    </body>
</html>