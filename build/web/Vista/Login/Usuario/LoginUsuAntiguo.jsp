
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String imagenes = request.getContextPath() + "/Imagenes/ImagenesVentPrincipal/";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesión</title>

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
            background: #f0f4f8;
            padding: 25px;
        }

        .contenedor {
            width: 100%;
            max-width: 950px;
            min-height: 540px;
            display: flex;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(18, 63, 115, 0.15);
        }

        /* PANEL IZQUIERDO */

        .panel-izquierdo {
            width: 45%;
            min-height: 540px;
            background: linear-gradient(145deg, #174d83, #12345d);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 35px;
        }

        .panel-izquierdo img {
            width: 85%;
            height: 200px;
            object-fit: cover;
            display: block;
            margin-bottom: 25px;
            border-radius: 25px;
            overflow: hidden;
        }

        .panel-izquierdo h2 {
            font-size: 27px;
            margin-bottom: 12px;
        }

        .panel-izquierdo p {
            font-size: 15px;
            line-height: 1.6;
            color: #e2ecf7;
        }

        .detalle {
            width: 65px;
            height: 4px;
            background: #8fc5f5;
            border-radius: 5px;
            margin-top: 25px;
        }

        /* PANEL DERECHO */

        .panel-derecho {
            width: 55%;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 50px;
        }

        .formulario {
            width: 100%;
            max-width: 360px;
        }

        .formulario h1 {
            color: #173f70;
            font-size: 30px;
            margin-bottom: 10px;
        }

        .subtitulo {
            color: #718096;
            font-size: 14px;
            margin-bottom: 35px;
        }

        .grupo {
            margin-bottom: 22px;
        }

        .grupo label {
            display: block;
            color: #294968;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 9px;
        }

        .grupo input {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border: 1px solid #d5e0eb;
            border-radius: 6px;
            outline: none;
            font-size: 14px;
            background: #f8fafc;
            transition: 0.2s;
        }

        .grupo input:focus {
            border-color: #16477f;
            background: white;
            box-shadow: 0 0 0 3px rgba(22, 71, 127, 0.09);
        }

        .btn-iniciar {
            width: 100%;
            height: 47px;
            border: none;
            border-radius: 6px;
            background: #16477f;
            color: white;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 5px;
        }

        .btn-iniciar:hover {
            background: #10365f;
        }

        .mensaje {
            padding: 11px;
            margin-bottom: 20px;
            border-radius: 6px;
            background: #eaf3fc;
            color: #16477f;
            font-size: 13px;
            text-align: center;
        }

        .enlaces {
            margin-top: 25px;
            text-align: center;
            display: flex;
            flex-direction: column;
            gap: 13px;
        }

        .enlaces p {
            color: #718096;
            font-size: 14px;
        }

        .enlaces a {
            color: #16477f;
            text-decoration: none;
            font-weight: bold;
        }

        .enlaces a:hover {
            text-decoration: underline;
        }

        .volver {
            margin-top: 12px;
            font-size: 13px;
        }

        /* RESPONSIVE */

        @media (max-width: 700px) {
            body {
                padding: 15px;
            }

            .contenedor {
                flex-direction: column;
            }

            .panel-izquierdo {
                width: 100%;
                min-height: 280px;
                padding: 25px;
            }

            .panel-izquierdo img {
                height: 130px;
                margin-bottom: 15px;
            }

            .panel-izquierdo h2 {
                font-size: 22px;
            }

            .panel-derecho {
                width: 100%;
                padding: 35px 25px;
            }
        }
    </style>
</head>

<body>

    <div class="contenedor">

        <div class="panel-izquierdo">

            <img src="<%=imagenes%>logo.png"
                 alt="UNFV SUPERMARKET">

            <h2>¡Bienvenido!</h2>

            <p>
                Inicia sesión y descubre todo lo que tenemos
                preparado para ti. Encuentra tus productos
                favoritos de manera fácil y rápida.
            </p>

            <div class="detalle"></div>

        </div>

        <div class="panel-derecho">

            <div class="formulario">

                <h1>Iniciar sesión</h1>

                <p class="subtitulo">
                    Ingresa tus datos para acceder a tu cuenta.
                </p>

                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <form name="form"
                      action="<%=request.getContextPath()%>/LoginControlador"
                      method="POST"
                      onsubmit="return true;">

                    <input type="hidden" name="op" value="1">

                    <div class="grupo">
                        <label for="txtcorreo">Correo electrónico</label>
                        <input type="email"
                               id="txtcorreo"
                               name="txtcorreo"
                               placeholder="Ingresa tu correo"
                               required>
                    </div>

                    <div class="grupo">
                        <label for="txtcontraseña">Contraseña</label>
                        <input type="password"
                               id="txtcontraseña"
                               name="txtcontraseña"
                               placeholder="Ingresa tu contraseña"
                               required>
                    </div>

                    <button type="submit" class="btn-iniciar">
                        Iniciar sesión
                    </button>

                </form>

                <div class="enlaces">

                    <p>
                        ¿No tienes una cuenta?
                        <a href="<%=request.getContextPath()%>/Vista/Login/Usuario/LoginUsuNuevo.jsp">
                            Regístrate aquí
                        </a>
                    </p>

                    <p>
                        ¿Eres administrador?
                        <a href="<%=request.getContextPath()%>/Vista/Login/Admin/Login.jsp">
                            Ingresar como administrador
                        </a>
                    </p>

                    <a class="volver"
                       href="<%=request.getContextPath()%>/Vista/Principal.jsp">
                        ← Volver a la página principal
                    </a>

                </div>

            </div>

        </div>

    </div>

</body>
</html>
