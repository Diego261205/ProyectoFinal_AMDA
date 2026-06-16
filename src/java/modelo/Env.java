package modelo;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * Loads and exposes environment variables from the project's .env file,
 * falling back to system environment variables when a key is not found.
 */
public class Env {
    private static Map<String, String> envMap = new HashMap<>();

    static {
        // Buscamos el archivo .env en la ruta local del proyecto
        File f = new File("C:/Users/angel/Desktop/Proyecto Villegas/.env");
        if (f.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(f))) {
                String line;
                while ((line = br.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) continue;
                    String[] parts = line.split("=", 2);
                    if (parts.length == 2) {
                        envMap.put(parts[0].trim(), parts[1].trim());
                    }
                }
            } catch (Exception e) {
                System.err.println("Error al cargar configuración del entorno.");
            }
        }
    }


    /**
     * Returns the value associated with the given key, checking the .env file
     * first and then falling back to system environment variables.
     *
     * @param key the name of the environment variable to look up
     * @return the value, or an empty string if the key is not found
     */
    public static String get(String key) {
        String value = envMap.get(key);
        if (value == null) {
            value = System.getenv(key);
        }
        return value != null ? value : "";
    }
}
