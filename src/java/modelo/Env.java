package modelo;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

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
                System.out.println("Error al leer archivo .env: " + e.getMessage());
            }
        }
    }

    public static String get(String key) {
        // Busca en el archivo .env primero, y si no, en las variables del sistema
        String value = envMap.get(key);
        if (value == null) {
            value = System.getenv(key);
        }
        return value != null ? value : "";
    }
}
