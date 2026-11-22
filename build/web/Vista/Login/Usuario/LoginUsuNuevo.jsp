
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear cuenta</title>

    <%
        String imagenes = request.getContextPath() + "/Imagenes/ImagenesVentPrincipal/";
    %>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            background: #f5f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px 15px;
            color: #26384a;
        }

        .contenedor {
            width: 100%;
            max-width: 480px;
            background: white;
            border: 1px solid #dce5ee;
            box-shadow: 0 8px 25px rgba(18, 63, 115, 0.12);
        }

        .encabezado {
            background: linear-gradient(145deg, #174d83, #12345d);
            padding: 28px 30px;
            text-align: center;
            color: white;
        }

        .encabezado img {
            width: 145px;
            height: 100px;
            object-fit: cover;
            display: block;
            margin: 0 auto 18px;
        }

        .encabezado h1 {
            font-size: 25px;
            margin-bottom: 9px;
        }

        .encabezado p {
            font-size: 14px;
            color: #e3edf7;
            line-height: 1.5;
        }

        .contenido {
            padding: 28px 35px 30px;
        }

        .campo {
            margin-bottom: 18px;
        }

        .campo label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            color: #16477f;
            margin-bottom: 8px;
        }

        .campo input {
            width: 100%;
            height: 43px;
            padding: 10px 12px;
            border: 1px solid #cbd6e2;
            outline: none;
            font-size: 14px;
            color: #26384a;
            background: #fff;
        }

        .campo input:focus {
            border-color: #16477f;
            box-shadow: 0 0 0 2px rgba(22, 71, 127, 0.10);
        }

        .boton {
            width: 100%;
            height: 45px;
            border: none;
            background: #16477f;
            color: white;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 5px;
        }

        .boton:hover {
            background: #12345d;
        }

        .mensaje {
            text-align: center;
            font-size: 14px;
            margin-bottom: 17px;
            color: #16477f;
        }

        .enlaces {
            text-align: center;
            margin-top: 22px;
            font-size: 14px;
            line-height: 2;
        }

        .enlaces a {
            color: #16477f;
            text-decoration: none;
            font-weight: bold;
        }

        .enlaces a:hover {
            text-decoration: underline;
        }

        @media (max-width: 500px) {
            .contenido {
                padding: 25px 22px;
            }

            .encabezado {
                padding: 25px 20px;
            }
        }
    </style>
</head>

<body>

    <div class="contenedor">

        <div class="encabezado">

            <img src="<%= imagenes %>logo.png" alt="Logo">

            <h1>¡Únete a nosotros!</h1>

            <p>
                Crea tu cuenta y disfruta de una experiencia de compra
                más fácil y rápida.
            </p>

        </div>

        <div class="contenido">

            <%
                String mensaje = (String) request.getAttribute("mensaje");
            %>

            <% if (mensaje != null) { %>
                <div class="mensaje">
                    <%= mensaje %>
                </div>
            <% } %>

            <form name="form" method="POST" onsubmit="registrarUsuario(); return false;">

                <input type="hidden" name="op" value="1">

                <div class="campo">
                    <label for="txtnombre">Nombre</label>
                    <input
                        type="text"
                        id="txtnombre"
                        name="txtnombre"
                        placeholder="Ingresa tu nombre"
                        required
                    >
                </div>

                <div class="campo">
                    <label for="txtapellido">Apellido</label>
                    <input
                        type="text"
                        id="txtapellido"
                        name="txtapellido"
                        placeholder="Ingresa tu apellido"
                        required
                    >
                </div>

                <div class="campo">
                    <label for="txtdni">DNI</label>
                    <input
                        type="text"
                        id="txtdni"
                        name="txtdni"
                        placeholder="Ingresa tu DNI"
                        maxlength="8"
                        pattern="[0-9]{8}"
                        inputmode="numeric"
                        required
                    >
                </div>

                <div class="campo">
                    <label for="txtcelular">Celular</label>
                    <input
                        type="tel"
                        id="txtcelular"
                        name="txtcelular"
                        placeholder="987 654 321"
                        maxlength="9"
                        inputmode="numeric"
                        autocomplete="tel-national"
                        required
                    >
                </div>

                <div class="campo">
                    <label for="txtcorreo">Correo electrónico</label>
                    <input
                        type="email"
                        id="txtcorreo"
                        name="txtcorreo"
                        placeholder="ejemplo@correo.com"
                        required
                    >
                </div>

                <div class="campo">
                    <label for="txtcontraseña">Contraseña</label>
                    <input
                        type="password"
                        id="txtcontraseña"
                        name="txtcontraseña"
                        placeholder="Crea una contraseña"
                        required
                    >
                </div>

                <div class="campo">
                    <label for="txtconfirmar">Confirmar contraseña</label>
                    <input
                        type="password"
                        id="txtconfirmar"
                        name="txtconfirmar"
                        placeholder="Vuelve a escribir tu contraseña"
                        required
                    >
                </div>

                <button type="submit" class="boton">
                    Crear cuenta
                </button>

            </form>

            <div class="enlaces">

                ¿Ya tienes una cuenta?
                <a href="<%= request.getContextPath() %>/Vista/Login/Usuario/LoginUsuAntiguo.jsp">
                    Inicia sesión
                </a>

                <br>

                <a href="<%= request.getContextPath() %>/Vista/Principal.jsp">
                    Volver a la página principal
                </a>

            </div>

        </div>

    </div>

    <script>
        const celular = document.getElementById("txtcelular");

        // Permitir únicamente números y un máximo de 9 dígitos.
        celular.addEventListener("input", function () {
            this.value = this.value.replace(/\D/g, "").substring(0, 9);
        });

        function registrarUsuario() {

            const contraseña = document.getElementById("txtcontraseña").value;
            const confirmar = document.getElementById("txtconfirmar").value;

            if (contraseña !== confirmar) {
                alert("Las contraseñas no coinciden. Verifica nuevamente.");
                document.getElementById("txtconfirmar").focus();
                return;
            }

            const numero = celular.value;

            if (!/^\d{9}$/.test(numero)) {
                alert("Ingresa un número de celular válido de 9 dígitos.");
                celular.focus();
                return;
            }

            const formulario = document.forms["form"];

            formulario.action = "<%= request.getContextPath() %>/UsuarioControlador";
            formulario.method = "POST";
            formulario.querySelector('input[name="op"]').value = "1";

            formulario.submit();
        }
    </script>

</body>
</html>
