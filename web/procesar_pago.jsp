<%@page import="java.sql.*, modelo.Conexion"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int idS = Integer.parseInt(request.getParameter("id"));
    Connection cn = null;
    PreparedStatement ps = null;
    try {
        cn = Conexion.conectar();
        String sql = "UPDATE servicios SET pagado = TRUE WHERE id_servicio = ?";
        ps = cn.prepareStatement(sql);
        ps.setInt(1, idS);
        ps.executeUpdate();
        response.sendRedirect("dashboard.jsp");
    } catch(Exception e) {
        response.sendRedirect("dashboard.jsp?error=pago");
        return;
    } finally {
        if (ps != null) try { ps.close(); } catch(SQLException ex) {}
        if (cn != null) try { cn.close(); } catch(SQLException ex) {}
    }
%>