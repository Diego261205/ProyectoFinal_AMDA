# AMDA Gestor de Servicios (Proyecto Villegas)

Aplicación web en Java (JSP/Servlets) para gestión de servicios vehiculares AMDA.

## Requisitos previos

- **Java JDK 8** o superior
- **Apache Tomcat 8+**
- **MariaDB / MySQL**
- **Apache NetBeans** (recomendado) o Apache Ant para compilar sin IDE

## Configuración inicial

### 1. Base de datos

Ejecuta el script incluido para crear las tablas:

```bash
mysql -u root -p < database_setup.sql
```

La columna `usuarios.password` debe ser `VARCHAR(60)` para almacenar hashes BCrypt:

```sql
ALTER TABLE usuarios MODIFY COLUMN password VARCHAR(60) NOT NULL;
```

### 2. Variables de entorno

Crea un archivo `.env` en la raíz del proyecto (nunca se sube al repo):

```
DB_URL=jdbc:mariadb://localhost:3307/amda_db
DB_USER=root
DB_PASS=tu_contraseña
```

La clase `modelo.Env` carga estas variables al iniciar. No hay credenciales hardcodeadas en el código.

### 3. Contraseñas (BCrypt)

Las contraseñas se almacenan con hash BCrypt (factor 12). Para crear un usuario inicial:

```java
// Compila HashGen.java con jbcrypt-0.4.jar en el classpath,
// corre el main y usa el hash generado en el INSERT de usuarios.
```

## Dependencias externas

| JAR | Ubicación en Tomcat |
|-----|-------------------|
| `mariadb-java-client-*.jar` | `WEB-INF/lib/` |
| `jbcrypt-0.4.jar` | `WEB-INF/lib/` |

Ambos JARs deben estar en `WEB-INF/lib/` del WAR desplegado. Reiniciar Tomcat tras agregar nuevos JARs.

---

## Ejecutar con NetBeans (recomendado)

1. **File > Open Project** → selecciona la carpeta `Proyecto Villegas`
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
