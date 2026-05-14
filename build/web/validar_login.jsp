<%@page import="java.sql.*"%>
<%@page import="modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Recibimos los datos del formulario de index.jsp
    String user = request.getParameter("txtUsuario");
    String pass = request.getParameter("txtPassword");

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // 2. Usamos tu clase Conexion con el puerto 3307
        cn = Conexion.conectar();
        
        // 3. Consultamos si el usuario y contraseña existen
        String sql = "SELECT * FROM usuarios WHERE id = ? AND password = ?";
        ps = cn.prepareStatement(sql);
        ps.setString(1, user);
        ps.setString(2, pass);
        
        rs = ps.executeQuery();

        if (rs.next()) {
            // LOGIN EXITOSO: Guardamos el usuario en una "sesion" para que la pag lo recuerde
            session.setAttribute("usuarioLogueado", user);
            response.sendRedirect("dashboard.jsp");
        } else {
            // LOGIN FALLIDO: Regresamos al index con un mensaje de error
            out.print("<script>alert('Usuario o contraseña incorrectos'); window.location='index.jsp';</script>");
        }
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    } finally {
        // Siempre es bueno cerrar las conexiones
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (cn != null) cn.close();
    }
%>