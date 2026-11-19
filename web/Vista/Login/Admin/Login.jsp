
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Acceso administrativo</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #202b3c, #111827);
    padding: 20px;
}

.contenedor {
    width: 100%;
    max-width: 900px;
    min-height: 500px;
    display: flex;
    background: white;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 12px 40px rgba(0,0,0,0.3);
}

.izquierda {
    width: 43%;
    background: linear-gradient(145deg, #263b59, #111827);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 40px;
}

.logo-admin {
    width: 180px;
    height: 85px;
    object-fit: contain;
    margin-bottom: 20px;
}

.izquierda h1 {
    font-size: 28px;
    margin-bottom: 15px;
}

.izquierda p {
    font-size: 14px;
    line-height: 1.7;
    color: #d4dce8;
}

.derecha {
    width: 57%;
    padding: 55px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.derecha h2 {
    color: #202b3c;
    font-size: 28px;
    margin-bottom: 10px;
}

.subtitulo {
    color: #888;
    font-size: 14px;
    margin-bottom: 35px;
}

.grupo {
    margin-bottom: 23px;
}

.grupo label {
    display: block;
    font-size: 14px;
    font-weight: bold;
    color: #444;
    margin-bottom: 9px;
}

.grupo input {
    width: 100%;
    padding: 14px 15px;
    border: 1px solid #ddd;
    border-radius: 9px;
    outline: none;
    font-size: 14px;
}

.grupo input:focus {
    border-color: #263b59;
    box-shadow: 0 0 0 3px rgba(38,59,89,0.10);
}

.boton {
    width: 100%;
    padding: 15px;
    background: #263b59;
    color: white;
    border: none;
    border-radius: 9px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.boton:hover {
    background: #17263d;
}

.volver {
    text-align: center;
    margin-top: 28px;
}

.volver a {
    color: #777;
    text-decoration: none;
    font-size: 13px;
}

.volver a:hover {
    color: #263b59;
}

.mensaje {
    background: #fff0ed;
    color: #c93629;
    padding: 12px;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 20px;
    text-align: center;
}

@media(max-width:700px) {
    .contenedor {
        flex-direction: column;
    }

    .izquierda, .derecha {
        width: 100%;
    }

    .izquierda {
        padding: 30px;
    }

    .logo-admin {
        width: 150px;
        height: 70px;
        margin-bottom: 15px;
    }

    .derecha {
        padding: 35px 25px;
    }
}
</style>
</head>

<body>

<div class="contenedor">

    <!-- PRESENTACIÓN -->
    <div class="izquierda">

        <img src="<%=request.getContextPath()%>/Imagenes/ImagenesVentPrincipal/logo.png"
             alt="UNFV SUPERMARKET"
             class="logo-admin">

        <h1>Panel administrativo</h1>

        <p>
            Acceso exclusivo para administrar los usuarios,
            productos y ventas de la tienda.
        </p>

    </div>

    <!-- FORMULARIO -->
    <div class="derecha">

        <h2>Bienvenido</h2>

        <p class="subtitulo">
            Ingresa tus credenciales de administrador.
        </p>

        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="mensaje">
                <%=request.getAttribute("mensaje")%>
            </div>
        <% } %>

        <form name="form"
              onsubmit="iniciarSesionAdmin(); return false;">

            <input type="hidden" name="op">

            <div class="grupo">
                <label>Correo electrónico</label>

                <input type="email"
                       name="txtcorreo"
                       placeholder="Correo del administrador"
                       required>
            </div>

            <div class="grupo">
                <label>Contraseña</label>

                <input type="password"
                       name="txtcontraseña"
                       placeholder="Ingresa tu contraseña"
                       required>
            </div>

            <button type="submit" class="boton">
                Ingresar al panel
            </button>

        </form>

        <div class="volver">
            <a href="<%=request.getContextPath()%>/Vista/Principal.jsp">
                ← Volver a la tienda
            </a>
        </div>

    </div>

</div>

<script>
function iniciarSesionAdmin() {

    document.form.action = "<%=request.getContextPath()%>/LoginControlador";
    document.form.method = "POST";
    document.form.op.value = "2";
    document.form.submit();

}
</script>

</body>
</html>
