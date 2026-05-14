<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>AMDA - Login</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <div class="login-container">
            <h2>Acceso AMDA</h2>
            <form action="validar_login.jsp" method="POST">
                <input type="text" name="txtUsuario" placeholder="ID de Usuario" required>
                <input type="password" name="txtPassword" placeholder="Contraseña" required>
                <input type="submit" value="Entrar">
            </form>
        </div>
    </body>
</html>