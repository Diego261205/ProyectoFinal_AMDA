<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es-MX">
    <head>
        <title>AMDA - Acceso al Sistema</title>
        <link rel="stylesheet" href="style.css?v=14">
        <!-- Font Awesome para Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body class="login-body">
        <main class="login-container">
            <h1 style="font-size: 22px; font-weight: 700; color: var(--primary); margin: 0 0 4px 0;">AMDA</h1>
            <p style="font-size: 14px; color: var(--text-muted); margin: 0 0 28px 0;">Control de Servicios Vehiculares</p>
            <form action="validar_login.jsp" method="POST">
                <div class="input-group">
                    <i class="fa-solid fa-user" aria-hidden="true"></i>
                    <label for="txtUsuario" class="visually-hidden">Usuario</label>
                    <input type="text" id="txtUsuario" name="txtUsuario" placeholder="Tu nombre de usuario" required autocomplete="username">
                </div>
                <div class="input-group">
                    <i class="fa-solid fa-lock" aria-hidden="true"></i>
                    <label for="txtPassword" class="visually-hidden">Contraseña</label>
                    <input type="password" id="txtPassword" name="txtPassword" placeholder="Contraseña" required autocomplete="current-password">
                </div>
                <input type="submit" value="Entrar al sistema">
            </form>
        </main>
    </body>
</html>