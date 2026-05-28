# Prueba1Proyecto (Proyecto Villegas)

Este es un proyecto de aplicación web en Java (JSP/Servlets). 

## Requisitos previos

- **Java JDK** (versión recomendada: 8 o superior).
- **Servidor de Aplicaciones:** Apache Tomcat o GlassFish.
- **Base de Datos:** MariaDB o MySQL.
- **Apache Ant** (si deseas compilar desde la terminal sin NetBeans).

## Configuración de la Base de Datos

1. Asegúrate de tener tu servidor de base de datos MySQL/MariaDB en ejecución.
2. Ejecuta el script `database_setup.sql` incluido en la raíz de este proyecto para crear las tablas necesarias y agregar los datos de prueba.
3. Si cambias las credenciales por defecto (usuario/contraseña), asegúrate de actualizar la conexión en el código de la aplicación.

---

## Cómo ejecutar el proyecto usando Apache NetBeans (Recomendado)

1. Abre Apache NetBeans.
2. Ve a **File > Open Project...** (Archivo > Abrir Proyecto...).
3. Navega hasta la carpeta de este proyecto (`Proyecto Villegas`) y selecciónala.
4. Asegúrate de tener un servidor configurado en NetBeans (como Tomcat o GlassFish) en **Services > Servers**.
5. Haz clic derecho sobre el proyecto en la pestaña *Projects* y selecciona **Run** (Ejecutar). NetBeans se encargará de compilar, empaquetar y desplegar el proyecto, para luego abrirlo en tu navegador predeterminado.

---

## Cómo ejecutar el proyecto SIN NetBeans (Usando Apache Ant y Tomcat)

Si prefieres usar la terminal, este proyecto utiliza Apache Ant para su construcción.

1. Abre una terminal (o Símbolo del Sistema) y navega a la carpeta raíz del proyecto.
2. Ejecuta el siguiente comando para limpiar y construir el proyecto:
   ```bash
   ant clean dist
   ```
3. Una vez finalizado el proceso, se habrá generado un archivo `.war` dentro de la carpeta `dist/`.
4. Copia ese archivo `.war` y pégalo dentro de la carpeta `webapps/` de tu instalación de Apache Tomcat.
5. Inicia tu servidor Tomcat (ejecutando `catalina.bat run` en Windows o `catalina.sh run` en Linux/Mac).
6. Ingresa desde tu navegador a `http://localhost:8080/NombreDelWar` (reemplazando `NombreDelWar` por el nombre real del archivo sin la extensión .war).
