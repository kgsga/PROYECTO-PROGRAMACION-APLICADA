<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="System Developer">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registro de Usuario - Sistema Online</title>
    
    <!-- Google Fonts para una tipografía bonita -->
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
 
        /* Fondo de pantalla con la imagen solicitada */ 
        .login-background { 
            background-image: url('<%=request.getContextPath()%>/imagenes_de_login/fondo login.png'); 
            background-size: cover; 
            background-position: center; 
            background-repeat: no-repeat; 
            min-height: 100vh; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            position: relative; 
            padding: 40px 0; 
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
         
        /* Contenedor tipo tarjeta central elegante */ 
        .login-card { 
            position: relative; 
            z-index: 10; 
            width: 100%; 
            max-width: 480px; 
            background: #ffffff; 
            border-radius: 16px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25); 
            padding: 35px 40px; 
            text-align: center; 
        } 
 
        /* Inputs modernos con línea inferior */ 
        .input-line { 
            border: none; 
            border-bottom: 2px solid #e5e7eb; 
            border-radius: 0; 
            box-shadow: none !important; 
            padding: 8px 0; 
            font-size: 14px; 
            background: transparent; 
            color: #1f2937; 
            transition: border-color 0.2s; 
            text-align: left; 
        } 
        
        .input-line:focus { 
            border-bottom-color: #3b82f6; 
        } 
 
        /* Botón de registro personalizado */ 
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
         
        <!-- Tarjeta de Registro --> 
        <div class="login-card"> 
 
            <!-- Título actualizado --> 
            <h3 style="font-weight: 700; color: #111827; font-size: 22px; margin-bottom: 8px; letter-spacing: -0.5px;">
                Regístrate para comprar
            </h3> 
 
            <!-- Formulario Principal de Registro --> 
            <form name="form" style="text-align: left;"> 
                <input type="hidden" name="op"> 
 
                <!-- Correo --> 
                <div class="form-group" style="margin-bottom: 16px;"> 
                    <label style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Correo
                    </label> 
                    <input type="email" 
                           id="txtcorreo" 
                           name="txtcorreo" 
                           class="form-control input-line" 
                           placeholder="Ingresa un correo" 
                           autocomplete="off"> 
                </div> 
 
                <!-- Nombre --> 
                <div class="form-group" style="margin-bottom: 16px;"> 
                    <label style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Nombre
                    </label> 
                    <input type="text" 
                           id="txtnombre" 
                           name="txtnombre" 
                           class="form-control input-line" 
                           placeholder="Ingresa un nombre"> 
                </div> 
 
                <!-- Apellidos --> 
                <div class="form-group" style="margin-bottom: 16px;"> 
                    <label style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Apellidos
                    </label> 
                    <input type="text" 
                           id="txtapellidos" 
                           name="txtapellidos" 
                           class="form-control input-line" 
                           placeholder="Ingresa apellidos"> 
                </div> 
 
                <!-- Tipo de documento --> 
                <div class="form-group" style="margin-bottom: 16px;"> 
                    <label style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Tipo de documento
                    </label> 
                    
                    <div style="display: flex; gap: 10px; align-items: center; border-bottom: 2px solid #e5e7eb; padding-bottom: 6px;"> 
                        
                        <select name="tipodoc" 
                                class="form-control" 
                                style="width: 85px; border: none; box-shadow: none; background: transparent; font-size: 14px; font-weight: 600; padding: 0;"> 
                            <option value="DNI">DNI</option> 
                            <option value="CE">CE</option> 
                            <option value="Pasaporte">Pasaporte</option> 
                        </select> 
                        
                        <input type="text" 
                               id="txtdocumento" 
                               name="txtdocumento" 
                               class="form-control" 
                               placeholder="Ingresa un documento de identidad" 
                               style="border: none; box-shadow: none; background: transparent; font-size: 14px; padding: 0;"> 
                    </div> 
                </div> 
 
                <!-- Celular --> 
                <div class="form-group" style="margin-bottom: 16px;"> 
                    <label style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Celular
                    </label> 
                    
                    <div style="display: flex; gap: 8px; align-items: center; border-bottom: 2px solid #e5e7eb; padding-bottom: 6px;"> 
                        
                        <span style="font-size: 14px; font-weight: 600; color: #374151;">
                            +51
                        </span> 
                        
                        <input type="tel" 
                               id="txtcelular" 
                               name="txtcelular" 
                               class="form-control" 
                               placeholder="Ingresa un celular" 
                               style="border: none; box-shadow: none; background: transparent; font-size: 14px; padding: 0;"> 
                    </div> 
                </div> 
 
                <!-- Contraseña --> 
                <div class="form-group" style="margin-bottom: 24px; position: relative;"> 
                    <label style="font-size: 11px; color: #4b5563; font-weight: 600; display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.8px;">
                        Contraseña
                    </label> 
                    
                    <input type="password" 
                           id="txtcla" 
                           name="txtcla" 
                           class="form-control input-line" 
                           placeholder="Ingresa una contraseña"> 
                </div> 
 
                <!-- Botón de Registro --> 
                <div class="form-group" style="margin-bottom: 15px;"> 
                    <button type="button" 
                            class="btn btn-ingresar" 
                            onclick="entrar()"> 
                        Registrarse 
                    </button> 
                </div> 
 
                <!-- Enlace para volver al inicio de sesión --> 
                <div style="text-align: center; margin-top: 15px;"> 
                    <a href="usuario_antiguo.jsp" 
                       style="font-size: 12px; color: #3b82f6; text-decoration: none; font-weight: 500;">
                        ¿Ya tienes una cuenta? Inicia sesión
                    </a> 
                </div> 
 
            </form> 
 
        </div> 
    </div> 
 
</body> 
</html>