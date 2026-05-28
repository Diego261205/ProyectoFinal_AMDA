<%@page import="java.sql.*, modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int idS = Integer.parseInt(request.getParameter("id"));
    Connection cn = null;
    PreparedStatement psGet = null;
    PreparedStatement psDel = null;
    ResultSet rs = null;

    try {
        cn = Conexion.conectar();
        cn.setAutoCommit(false);

        // 1. Obtener el id_dueno asociado al servicio
        String sqlGet = "SELECT id_dueno FROM servicios WHERE id_servicio = ?";
        psGet = cn.prepareStatement(sqlGet);
        psGet.setInt(1, idS);
        rs = psGet.executeQuery();
        
        int idD = 0;
        if (rs.next()) {
            idD = rs.getInt("id_dueno");
        }

        // 2. Eliminar al dueño (esto eliminará en cascada el servicio)
        if (idD > 0) {
            String sqlDel = "DELETE FROM duenos WHERE id_dueno = ?";
            psDel = cn.prepareStatement(sqlDel);
            psDel.setInt(1, idD);
            psDel.executeUpdate();
        }

        cn.commit();
        out.print("<script>alert('El registro ha sido eliminado exitosamente.'); window.location='dashboard.jsp';</script>");
    } catch (Exception e) {
        if (cn != null) try { cn.rollback(); } catch(SQLException ex) {}
        out.print("Error al eliminar: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
        if (psGet != null) try { psGet.close(); } catch(SQLException ex) {}
        if (psDel != null) try { psDel.close(); } catch(SQLException ex) {}
        if (cn != null) try { cn.close(); } catch(SQLException ex) {}
    }
%>
