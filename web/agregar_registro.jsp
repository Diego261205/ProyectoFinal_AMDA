<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>AMDA - Nuevo Registro</title>
        <link rel="stylesheet" href="style.css">
        <style>
            .form-container { width: 80%; margin: 30px auto; background: white; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); border-radius: 8px; }
            .grid-form { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
            section { border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
            h3 { color: #004a99; margin-top: 0; }
            label { display: block; margin-top: 10px; font-weight: bold; }
            select, input { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h2>Nuevo Trámite Vehicular</h2>
            <form action="guardar_servicio.jsp" method="POST">
                <div class="grid-form">
                    <section>
                        <h3>Datos del Dueño</h3>
                        <label>Nombre Completo:</label>
                        <input type="text" name="nombre_dueno" required>
                        <label>Edad:</label>
                        <input type="number" name="edad" required>
                        <label>Fecha de Nacimiento:</label>
                        <input type="date" name="nacimiento" required>
                        <label>Teléfono:</label>
                        <input type="text" name="telefono" required>
                        <label>Domicilio:</label>
                        <input type="text" name="domicilio" required>
                    </section>

                    <section>
                        <h3>Datos del Servicio</h3>
                        <label>Tipo de Movimiento:</label>
                        <select name="tipo_movimiento">
                            <option value="Placa Nueva">Placa Nueva</option>
                            <option value="Permiso de Circulacion">Permiso de Circulación</option>
                        </select>
                        <label>Cliente / Agencia que solicita:</label>
<input type="text" name="cliente_solicita" placeholder="Ej: Ford Country, Particular, etc." required>
                        <label>Marca:</label>
                        <input type="text" name="marca" required>
                        <label>Modelo:</label>
                        <input type="text" name="modelo" required>
                        <label>VIN (N° de Serie):</label>
                        <input type="text" name="vin" maxlength="17" required>
                        <label>Tipo de Placa:</label>
                        <input type="text" name="tipo_placa" placeholder="NA, Antiguo, etc.">
                        <label>Importe a Cobrar ($):</label>
                        <input type="number" step="0.01" name="importe" required>
                    </section>
                </div>
                
                <div style="margin-top: 20px; text-align: right;">
                    <a href="dashboard.jsp" style="text-decoration: none; color: #666; margin-right: 20px;">Cancelar</a>
                    <input type="submit" value="Guardar Registro Completo" style="width: auto; padding: 10px 40px;">
                </div>
            </form>
        </div>
    </body>
</html>