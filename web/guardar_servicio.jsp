<%@page import="java.sql.*"%>
<%@page import="modelo.Conexion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Datos del Dueño (Titular legal)
    String nombreD = request.getParameter("nombre_dueno");
    int edad = Integer.parseInt(request.getParameter("edad"));
    String nacimiento = request.getParameter("nacimiento");
    String telefono = request.getParameter("telefono");
    String domicilio = request.getParameter("domicilio");

    // 2. Datos del Servicio y Cliente (Agencia)
    String clienteSolicita = request.getParameter("cliente_solicita"); // NUEVO
    String tipoMov = request.getParameter("tipo_movimiento");
    String marca = request.getParameter("marca");
    String modelo = request.getParameter("modelo");
    String vin = request.getParameter("vin");
    String tipoPlaca = request.getParameter("tipo_placa");
    double importe = Double.parseDouble(request.getParameter("importe"));

    Connection cn = null;
    try {
        cn = Conexion.conectar();
        cn.setAutoCommit(false);

        // PASO A: Insertar Dueño
        String sqlDueno = "INSERT INTO duenos (nombre_completo, edad, fecha_nacimiento, telefono, domicilio) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement psD = cn.prepareStatement(sqlDueno, Statement.RETURN_GENERATED_KEYS);
        psD.setString(1, nombreD);
        psD.setInt(2, edad);
        psD.setString(3, nacimiento);
        psD.setString(4, telefono);
        psD.setString(5, domicilio);
        psD.executeUpdate();

        ResultSet rsKeys = psD.getGeneratedKeys();
        int idGenerado = 0;
        if (rsKeys.next()) idGenerado = rsKeys.getInt(1);

        // PASO B: Insertar Servicio (Usando clienteSolicita en cliente_nombre)
        String sqlServicio = "INSERT INTO servicios (tipo_movimiento, marca, modelo, vin, tipo_placa, fecha_tramite, importe, cliente_nombre, id_dueno) VALUES (?, ?, ?, ?, ?, CURDATE(), ?, ?, ?)";
        PreparedStatement psS = cn.prepareStatement(sqlServicio);
        psS.setString(1, tipoMov);
        psS.setString(2, marca);
        psS.setString(3, modelo);
        psS.setString(4, vin);
        psS.setString(5, tipoPlaca);
        psS.setDouble(6, importe);
        psS.setString(7, clienteSolicita); // Aquí guardamos la Agencia
        psS.setInt(8, idGenerado);
        
        psS.executeUpdate();
        cn.commit();
        
        out.print("<script>alert('Registro guardado exitosamente'); window.location='dashboard.jsp';</script>");
    } catch (Exception e) {
        if (cn != null) cn.rollback();
        out.print("Error: " + e.getMessage());
    } finally {
        if (cn != null) cn.close();
    }
%>