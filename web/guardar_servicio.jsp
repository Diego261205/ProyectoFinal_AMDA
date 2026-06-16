<%@page import="java.sql.*"%>
<%@page import="modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%
    // 1. Datos del Dueño (Titular legal)
    String ownerName = request.getParameter("nombre_dueno");
    int edad = 0;
    String birthDate = request.getParameter("nacimiento");
    String phone = request.getParameter("telefono");
    String address = request.getParameter("domicilio");

    // 2. Datos del Servicio y Cliente (Agencia)
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
    ResultSet rsKeys = null;
    try {
        cn = Conexion.conectar();
        cn.setAutoCommit(false);

        // PASO A: Insertar Dueño
        String sqlOwner = "INSERT INTO duenos (nombre_completo, edad, fecha_nacimiento, telefono, domicilio) VALUES (?, ?, ?, ?, ?)";
        psOwner = cn.prepareStatement(sqlOwner, Statement.RETURN_GENERATED_KEYS);
        psOwner.setString(1, ownerName);
        psOwner.setInt(2, edad);
        psOwner.setString(3, birthDate);
        psOwner.setString(4, phone);
        psOwner.setString(5, address);
        psOwner.executeUpdate();

        rsKeys = psOwner.getGeneratedKeys();
        int generatedId = 0;
        if (rsKeys.next()) {
            generatedId = rsKeys.getInt(1);
        }

        // PASO B: Insertar Servicio (Usando clientRequest en cliente_nombre)
        String sqlService = "INSERT INTO servicios (tipo_movimiento, marca, modelo, vin, tipo_placa, fecha_tramite, importe, cliente_nombre, id_dueno) VALUES (?, ?, ?, ?, ?, CURDATE(), ?, ?, ?)";
        psService = cn.prepareStatement(sqlService);
        psService.setString(1, movType);
        psService.setString(2, marca);
        psService.setString(3, modelo);
        psService.setString(4, vin);
        psService.setString(5, plateType);
        psService.setDouble(6, amount);
        psService.setString(7, clientRequest);
        psService.setInt(8, generatedId);

        psService.executeUpdate();
        cn.commit();

        out.print("<script>alert('Registro guardado exitosamente'); window.location='dashboard.jsp';</script>");
    } catch (Exception e) {
        if (cn != null) {
            try {
                cn.rollback();
            } catch (SQLException ex) {}
        }
        out.print("Ocurrió un error interno. Contacte al administrador.");
    } finally {
        if (rsKeys != null) {
            try {
                rsKeys.close();
            } catch (SQLException ex) {}
        }
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
