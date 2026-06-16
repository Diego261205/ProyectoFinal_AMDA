package modelo;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Provides database connectivity for the AMDA application.
 * Connection parameters are loaded from environment configuration
 * to avoid hardcoding credentials in source code.
 */
public class Conexion {


    /**
     * Opens and returns a JDBC connection to the configured database.
     * Returns null if the connection cannot be established.
     *
     * @return an active {@link Connection}, or null on failure
     */
    public static Connection conectar() {
        String url = Env.get("DB_URL");
        String user = Env.get("DB_USER");
        String pass = Env.get("DB_PASS");
        Connection cn = null;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            cn = DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            System.err.println("Error al establecer conexión con la base de datos.");
        }
        return cn;
    }
}
