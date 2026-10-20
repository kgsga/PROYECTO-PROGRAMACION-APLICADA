<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="System Developer">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Sistema de Evaluación Online</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="<%=request.getContextPath()%>/css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="<%=request.getContextPath()%>/css/jquery.ui.base.css" rel="stylesheet" type="text/css"/>
    <link href="<%=request.getContextPath()%>/css/jquery.ui.all.css" rel="stylesheet" type="text/css"/>
    <link href="<%=request.getContextPath()%>/css/jquery.ui.theme.css" rel="stylesheet" type="text/css"/>         
    
    <script src="<%=request.getContextPath()%>/js/jquery.js"></script> 
    <script src="<%=request.getContextPath()%>/jquery/jquery.alerts.js" type="text/javascript"></script>
    <script src="<%=request.getContextPath()%>/js/javascript.js"></script>
    
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/bootstrap.min_1.css">
    <script src="<%=request.getContextPath()%>/js/bootstrap.min1.js"></script>         

    <style>

        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Inter', sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        /* Fondo de pantalla */
        .login-background {
            background-image: url('<%=request.getContextPath()%>/imagenes_de_login/fondo login.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        /* Capa de opacidad sobre el fondo */
        .login-background::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
        }
        
        /* Contenedor tipo tarjeta central */
        .login-card {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 440px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
            padding: 40px;
            text-align: center;
        }

        /* Inputs */
        .input-line {
            border: none;
            border-bottom: 2px solid #e5e7eb;
            border-radius: 0;
            box-shadow: none !important;
            padding: 10px 0;
            font-size: 15px;
            background: transparent;
            color: #1f2937;
            transition: border-color 0.2s;
            text-align: left;
        }

        .input-line:focus {
            border-bottom-color: #3b82f6;
        }

        /* Botón de ingreso */
        .btn-ingresar {
            background-color: #1e3a8a;
            color: #ffffff;
            border-radius: 8px;
            padding: 12px;
            font-size: 15px;
            font-weight: 600;
            border: none;
            width: 100%;
            letter-spacing: 0.3px;
            transition: background 0.2s ease-in-out, transform 0.1s ease;
            box-shadow: 0 4px 12px rgba(30, 58, 138, 0.25);
        }

        .btn-ingresar:hover {
            background-color: #1d4ed8;
            color: #ffffff;
        }

        .btn-ingresar:active {
            transform: scale(0.98);
        }

    </style>
</head>

<body>

    <div class="login-background">
        
        <!-- Tarjeta de Inicio de Sesión -->
        <div class="login-card">
            

            <!-- Título -->
            <h3 style="font-weight: 700; color: #111827; font-size: 23px; margin-bottom: 12px; letter-spacing: -0.5px;">
                Inicia sesión para comprar
            </h3>


            <!-- Formulario Principal -->
            <form name="form" style="text-align: left;">

                <input type="hidden" name="op">


                <!-- Campo Usuario -->
                <div class="form-group" style="margin-bottom: 24px;">

                    <label for="txtusu" 
                           style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Usuario
                    </label>

                    <input type="text"
                           id="txtusu"
                           name="txtusu"
                           class="form-control input-line"
                           placeholder="Ingrese su usuario"
                           value=""
                           autocomplete="off">

                </div>


                <!-- Campo Clave -->
                <div class="form-group" style="margin-bottom: 20px;">

                    <label for="txtcla"
                           style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Contraseña
                    </label>

                    <input type="password"
                           id="txtcla"
                           name="txtcla"
                           class="form-control input-line"
                           placeholder="Ingrese su clave"
                           value="">

                </div>


                <!-- Enlace de recuperación -->
                <div style="text-align: right; margin-bottom: 28px;">

                    <a href="#"
                       style="font-size: 12px; color: #3b82f6; text-decoration: none; font-weight: 500;">
                        ¿Olvidó su contraseña?
                    </a>

                </div>


                <!-- Botón de Ingresar -->
                <div class="form-group" style="margin-bottom: 0;">

                    <button type="button"
                            class="btn btn-ingresar"
                            onclick="entrar()">

                        Ingresar

                    </button>

                </div>


                <!-- Registro de nuevo usuario -->
                <div style="text-align: center; margin-top: 20px; font-size: 13px; color: #6b7280;">

                    ¿No tienes una cuenta?

                    <a href="usuario_nuevo.jsp"
                       style="color: #3b82f6; text-decoration: none; font-weight: 600;">

                        Regístrate

                    </a>

                </div>


            </form>

        </div>

    </div>

</body>
</html>