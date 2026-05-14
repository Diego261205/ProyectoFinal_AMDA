<%@page import="java.sql.*, modelo.Conexion"%>
<%
    int idS = Integer.parseInt(request.getParameter("id"));
    try {
        Connection cn = Conexion.conectar();
        String sql = "UPDATE servicios SET pagado = TRUE WHERE id_servicio = ?";
        PreparedStatement ps = cn.prepareStatement(sql);
        ps.setInt(1, idS);
        ps.executeUpdate();
        cn.close();
        response.sendRedirect("dashboard.jsp");
    } catch(Exception e) {
        out.print("Error al pagar: " + e.getMessage());
    }
%>