<%@page import="java.sql.*, modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Edición inhabilitada por requerimiento
    response.sendRedirect("dashboard.jsp");
    if (true) return;

    // 1. Obtener los IDs
    int idS = Integer.parseInt(request.getParameter("id_servicio"));
    int idD = Integer.parseInt(request.getParameter("id_dueno"));

    // 2. Datos del Dueño
    String nombreD = request.getParameter("nombre_dueno");
    int edad = 0;
    String nacimiento = request.getParameter("nacimiento");
    String telefono = request.getParameter("telefono");
    String domicilio = request.getParameter("domicilio");

    // 3. Datos del Servicio
    String clienteSolicita = request.getParameter("cliente_solicita");
    String tipoMov = request.getParameter("tipo_movimiento");
    String marca = request.getParameter("marca");
    String modelo = request.getParameter("modelo");
    String vin = request.getParameter("vin");
    String tipoPlaca = request.getParameter("tipo_placa");
    double importe = Double.parseDouble(request.getParameter("importe"));

    Connection cn = null;
    PreparedStatement psD = null;
    PreparedStatement psS = null;

    try {
        cn = Conexion.conectar();
        cn.setAutoCommit(false);

        // PASO A: Actualizar Dueño
        String sqlDueno = "UPDATE duenos SET nombre_completo = ?, edad = ?, fecha_nacimiento = ?, telefono = ?, domicilio = ? WHERE id_dueno = ?";
        psD = cn.prepareStatement(sqlDueno);
        psD.setString(1, nombreD);
        psD.setInt(2, edad);
        psD.setString(3, nacimiento);
        psD.setString(4, telefono);
        psD.setString(5, domicilio);
        psD.setInt(6, idD);
        psD.executeUpdate();

        // PASO B: Actualizar Servicio
        String sqlServicio = "UPDATE servicios SET tipo_movimiento = ?, marca = ?, modelo = ?, vin = ?, tipo_placa = ?, importe = ?, cliente_nombre = ? WHERE id_servicio = ?";
        psS = cn.prepareStatement(sqlServicio);
        psS.setString(1, tipoMov);
        psS.setString(2, marca);
        psS.setString(3, modelo);
        psS.setString(4, vin);
        psS.setString(5, tipoPlaca);
        psS.setDouble(6, importe);
        psS.setString(7, clienteSolicita);
        psS.setInt(8, idS);
        psS.executeUpdate();

        cn.commit();
        out.print("<script>alert('Registro actualizado exitosamente.'); window.location='dashboard.jsp';</script>");
    } catch (Exception e) {
        if (cn != null) try { cn.rollback(); } catch(SQLException ex) {}
        out.print("Error al actualizar: " + e.getMessage());
    } finally {
        if (psD != null) try { psD.close(); } catch(SQLException ex) {}
        if (psS != null) try { psS.close(); } catch(SQLException ex) {}
        if (cn != null) try { cn.close(); } catch(SQLException ex) {}
    }
%>
