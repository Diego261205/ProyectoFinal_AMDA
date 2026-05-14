package modelo;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    // Usamos el puerto 3307 que es el que tienes configurado
    private static String url = "jdbc:mariadb://localhost:3307/amda_db";
    private static String user = "root";
    private static String pass = "";

    public static Connection conectar() {
        Connection cn = null;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            cn = DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            System.out.println("Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}