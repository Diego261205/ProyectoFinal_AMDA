# AMDA Gestor de Servicios

Aplicación web en Java (JSP/Servlets) para gestión de servicios vehiculares AMDA.

**Materia:** Técnicas Inteligentes para Procesos de Desarrollo (4-E)

**Profesor:** Angel Eduardo Villegas Ortiz

**Equipo:** Los Swifties

- Diego Moreno Diaz de Leon
- Angel Josue Muñoz Muñoz
- Santiago Andrey Muñoz Muñoz
- Patricio Ariel Ruiz Mejia
- Christian Oswaldo Sanchez Silva

---

## Requisitos previos

- **Java JDK 8** o superior
- **Apache Tomcat 8+**
- **MariaDB / MySQL**
- **Apache NetBeans** (recomendado) o Apache Ant para compilar sin IDE

---

## Configuración inicial

### 1. Base de datos

Ejecuta el script incluido para crear las tablas:

```bash
mysql -u root -p < database_setup.sql
```

### 2. Variables de entorno

Crea un archivo `.env` en la raíz del proyecto (nunca se sube al repo):

```
DB_URL=jdbc:mariadb://localhost:3307/amda_db
DB_USER=root
DB_PASS=tu_contraseña
```

La clase `modelo.Env` carga estas variables al iniciar. No hay credenciales hardcodeadas en el código.

### 3. Usuario inicial

Las contraseñas se almacenan con hash BCrypt. Para crear el primer usuario, compila y ejecuta `HashGen.java` con `jbcrypt-0.4.jar` en el classpath — el programa imprime el hash listo para insertar en la tabla `usuarios`.

---

## Dependencias

| JAR | Ubicación |
|-----|-----------|
| `mariadb-java-client-*.jar` | `WEB-INF/lib/` |
| `jbcrypt-0.4.jar` | `WEB-INF/lib/` |

Ambos JARs deben estar en `WEB-INF/lib/` del WAR desplegado. Reinicia Tomcat tras agregarlos.

---

## Ejecutar con NetBeans (recomendado)

1. **File > Open Project** → selecciona la carpeta del proyecto
2. Configura Tomcat en **Services > Servers**
3. Clic derecho en el proyecto → **Run**

NetBeans compila, empaqueta y despliega automáticamente.

---

## Ejecutar sin NetBeans (Ant + Tomcat manual)

```bash
ant clean dist
```

Copia el `.war` generado en `dist/` a la carpeta `webapps/` de Tomcat, luego:

```bash
# Windows
catalina.bat run

# Linux/Mac
catalina.sh run
```

Accede en: `http://localhost:8080/NombreDelWar`

> **Nota:** el build de Ant requiere ajustar las rutas de librerías en `nbproject/project.properties` a tu entorno local.
