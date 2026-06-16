<%@page import="java.sql.*"%>
<%@page import="modelo.Conexion"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
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

        // 3. Buscamos el usuario; la contraseña se verifica con BCrypt fuera del SQL
        String sql = "SELECT password FROM usuarios WHERE id = ?";
        ps = cn.prepareStatement(sql);
        ps.setString(1, user);

        rs = ps.executeQuery();

        if (rs.next() && BCrypt.checkpw(pass, rs.getString("password"))) {
            // LOGIN EXITOSO: Guardamos el usuario en una "sesion" para que la pag lo recuerde
            session.setAttribute("usuarioLogueado", user);
            response.sendRedirect("dashboard.jsp");
        } else {
            // LOGIN FALLIDO: Regresamos al index con un mensaje de error
            out.print("<script>alert('Usuario o contraseña incorrectos'); window.location='index.jsp';</script>");
        }
    } catch (Exception e) {
        out.print("Ocurrió un error interno. Contacte al administrador.");
    } finally {
        // Siempre es bueno cerrar las conexiones
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (cn != null) {
            cn.close();
        }
    }
%>