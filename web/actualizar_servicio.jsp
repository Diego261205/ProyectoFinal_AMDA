<%@page import="java.sql.*, modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Edición inhabilitada por requerimiento
    response.sendRedirect("dashboard.jsp");
    return;

    // 1. Obtener los IDs
    int serviceId = Integer.parseInt(request.getParameter("id_servicio"));
    int ownerId = Integer.parseInt(request.getParameter("id_dueno"));

    // 2. Datos del Dueño
    String ownerName = request.getParameter("nombre_dueno");
    int edad = 0;
    String birthDate = request.getParameter("nacimiento");
    String phone = request.getParameter("telefono");
    String address = request.getParameter("domicilio");

    // 3. Datos del Servicio
    String clientRequest = request.getParameter("cliente_solicita");
    String movType = request.getParameter("tipo_movimiento");
    String marca = request.getParameter("marca");
    String modelo = request.getParameter("modelo");
    String vin = request.getParameter("vin");
    String plateType = request.getParameter("tipo_placa");
    double amount = Double.parseDouble(request.getParameter("importe"));

    Connection cn = null;
    PreparedStatement psOwner = null;
    PreparedStatement psService = null;

    try {
        cn = Conexion.conectar();
        cn.setAutoCommit(false);

        // PASO A: Actualizar Dueño
        String sqlDueno = "UPDATE duenos SET nombre_completo = ?, edad = ?, fecha_nacimiento = ?, telefono = ?, domicilio = ? WHERE id_dueno = ?";
        psOwner = cn.prepareStatement(sqlDueno);
        psOwner.setString(1, ownerName);
        psOwner.setInt(2, edad);
        psOwner.setString(3, birthDate);
        psOwner.setString(4, phone);
        psOwner.setString(5, address);
        psOwner.setInt(6, ownerId);
        psOwner.executeUpdate();

        // PASO B: Actualizar Servicio
        String sqlServicio = "UPDATE servicios SET tipo_movimiento = ?, marca = ?, modelo = ?, vin = ?, tipo_placa = ?, importe = ?, cliente_nombre = ? WHERE id_servicio = ?";
        psService = cn.prepareStatement(sqlServicio);
        psService.setString(1, movType);
        psService.setString(2, marca);
        psService.setString(3, modelo);
        psService.setString(4, vin);
        psService.setString(5, plateType);
        psService.setDouble(6, amount);
        psService.setString(7, clientRequest);
        psService.setInt(8, serviceId);
        psService.executeUpdate();

        cn.commit();
        out.print("<script>alert('Registro actualizado exitosamente.'); window.location='dashboard.jsp';</script>");
    } catch (Exception e) {
        if (cn != null) {
            try {
                cn.rollback();
            } catch (SQLException ex) {}
        }
        out.print("Ocurrió un error interno. Contacte al administrador.");
    } finally {
        if (psOwner != null) {
            try {
                psOwner.close();
            } catch (SQLException ex) {}
        }
        if (psService != null) {
            try {
                psService.close();
            } catch (SQLException ex) {}
        }
        if (cn != null) {
            try {
                cn.close();
            } catch (SQLException ex) {}
        }
    }
%>
