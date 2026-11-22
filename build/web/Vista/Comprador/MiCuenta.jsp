
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Principal.jsp");
        return;
    }

    String ruta = request.getContextPath();
    String rutaPrincipal = ruta + "/Vista/Principal.jsp";
    String rutaTienda = ruta + "/Vista/Comprador/Tienda.jsp";
    String rutaCarrito = ruta + "/Vista/Comprador/Carrito.jsp";
    String rutaMisCompras = ruta + "/CompraControlador?op=4";
    String imagenes = ruta + "/Imagenes/ImagenesVentPrincipal/";
    String mensaje = (String) request.getAttribute("mensaje");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi cuenta - UNFV SUPERMARKET</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            background: #f5f7fa;
            color: #26364a;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* ENCABEZADO */

        .encabezado {
            background: white;
            position: relative;
            z-index: 100;
            box-shadow: 0 2px 9px rgba(0,0,0,0.07);
        }

        .parte-superior {
            max-width: 1500px;
            margin: auto;
            padding: 13px 35px;
            min-height: 95px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 22px;
        }

        .logo-menu {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-shrink: 0;
        }

        .logo img {
            width: 145px;
            height: 65px;
            object-fit: contain;
        }

        .titulo-cuenta {
            color: #173f70;
            font-size: 19px;
            font-weight: bold;
            white-space: nowrap;
            border-left: 1px solid #dce3eb;
            padding-left: 17px;
        }

        /* OPCIONES DE USUARIO */

        .opciones-usuario {
            display: flex;
            align-items: center;
            gap: 18px;
            justify-content: flex-end;
        }

        .opcion {
            min-height: 55px;
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 8px 5px;
            border-radius: 0;
            transition: 0.2s;
            white-space: nowrap;
            background: transparent;
        }

        .opcion:hover {
            background: transparent;
        }

        .opcion:hover .texto-opcion strong {
            color: #16477f;
        }

        .icono-opcion {
            width: 28px;
            height: 28px;
            color: #16477f;
            flex-shrink: 0;
        }

        .icono-opcion svg {
            width: 100%;
            height: 100%;
            stroke: currentColor;
            fill: none;
            stroke-width: 1.7;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .texto-opcion {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .texto-opcion strong {
            font-size: 14px;
            color: #263b55;
            transition: 0.2s;
        }

        .texto-opcion small {
            font-size: 12px;
            color: #8290a0;
        }

        .opcion-activa .texto-opcion strong {
            color: #16477f;
        }

        /* BARRA DE NAVEGACIÓN */

        .barra-navegacion {
            background: #123f73;
        }

        .contenido-nav {
            max-width: 1500px;
            height: 46px;
            margin: auto;
            padding: 0 35px;
            display: flex;
            align-items: center;
            gap: 38px;
        }

        .contenido-nav a {
            color: white;
            font-size: 14px;
            font-weight: bold;
            transition: 0.2s;
        }

        .contenido-nav a:hover {
            color: #bcd8f5;
        }

        /* CONTENIDO */

        .contenedor {
            max-width: 1400px;
            margin: auto;
            padding: 35px;
        }

        .bienvenida {
            margin-bottom: 25px;
        }

        .bienvenida h1 {
            color: #173f70;
            font-size: 26px;
            margin-bottom: 8px;
        }

        .bienvenida p {
            color: #778496;
            font-size: 14px;
        }

        /* TARJETA DE CUENTA */

        .tarjeta-cuenta {
            max-width: 950px;
            margin: 0 auto;
            background: white;
            border: 1px solid #e5e9ef;
            border-radius: 7px;
            padding: 32px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        .encabezado-tarjeta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 18px;
            border-bottom: 1px solid #e8edf2;
        }

        .encabezado-tarjeta h2 {
            color: #173f70;
            font-size: 20px;
        }

        .encabezado-tarjeta p {
            color: #8490a0;
            font-size: 13px;
            margin-top: 7px;
        }

        .formulario {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 9px;
        }

        .campo.completo {
            grid-column: 1 / -1;
        }

        .campo label {
            color: #34465b;
            font-size: 14px;
            font-weight: bold;
        }

        .campo input {
            width: 100%;
            height: 45px;
            padding: 0 14px;
            border: 1px solid #d8e0e9;
            border-radius: 5px;
            outline: none;
            background: white;
            color: #26364a;
            font-size: 14px;
            transition: 0.2s;
        }

        .campo input:focus {
            border-color: #16477f;
            box-shadow: 0 0 0 2px rgba(22,71,127,0.08);
        }

        .campo input:disabled {
            background: #f5f7fa;
            color: #596879;
            cursor: not-allowed;
            border-color: #e1e6ec;
        }

        .seccion-contrasena {
            grid-column: 1 / -1;
            display: none;
            border-top: 1px solid #e8edf2;
            padding-top: 23px;
            margin-top: 5px;
        }

        .seccion-contrasena.mostrar {
            display: block;
        }

        .seccion-contrasena h3 {
            color: #173f70;
            font-size: 18px;
            margin-bottom: 19px;
        }

        .campos-contrasena {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .ayuda-contrasena {
            color: #8490a0;
            font-size: 12px;
            margin-top: 14px;
            line-height: 1.5;
        }

        /* MENSAJES */

        .mensaje {
            max-width: 950px;
            margin: 0 auto 20px;
            padding: 14px 17px;
            border-radius: 5px;
            font-size: 14px;
            line-height: 1.5;
            background: #edf4fc;
            color: #16477f;
            border: 1px solid #d3e2f2;
        }

        /* BOTONES */

        .botones {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid #e8edf2;
        }

        .boton {
            min-width: 145px;
            height: 43px;
            padding: 0 20px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .boton-editar,
        .boton-guardar {
            background: #16477f;
            color: white;
        }

        .boton-editar:hover,
        .boton-guardar:hover {
            background: #12365f;
        }

        .boton-cancelar {
            background: #edf1f5;
            color: #45576b;
            display: none;
        }

        .boton-cancelar:hover {
            background: #dfe6ed;
        }

        .boton-guardar {
            display: none;
        }

        .boton:disabled {
            opacity: 0.65;
            cursor: not-allowed;
        }

        .cargando {
            display: inline-block;
            width: 15px;
            height: 15px;
            border: 2px solid rgba(255,255,255,0.4);
            border-top-color: white;
            border-radius: 50%;
            animation: girar 0.7s linear infinite;
            vertical-align: middle;
            margin-right: 8px;
        }

        @keyframes girar {
            to {
                transform: rotate(360deg);
            }
        }

        /* PIE DE PÁGINA */

        .pie {
            margin-top: 55px;
            background: #123f73;
            color: white;
        }

        .contenido-pie {
            max-width: 1400px;
            margin: auto;
            padding: 42px 35px 35px;
            display: grid;
            grid-template-columns: 1.4fr 1fr 1fr;
            gap: 40px;
        }

        .columna-pie h3 {
            font-size: 17px;
            margin-bottom: 19px;
            font-weight: 600;
        }

        .columna-pie p {
            color: #d3dfed;
            font-size: 13px;
            line-height: 1.8;
            margin-bottom: 10px;
        }

        .dato-contacto {
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .dato-contacto strong {
            color: white;
            font-weight: 600;
        }

        .marca-pie {
            font-size: 23px !important;
            font-weight: bold;
            color: white !important;
            letter-spacing: 1px;
            line-height: 1.5 !important;
        }

        .linea-pie {
            max-width: 1400px;
            margin: auto;
            border-top: 1px solid rgba(255,255,255,0.2);
            padding: 19px 35px;
            display: flex;
            justify-content: space-between;
            gap: 15px;
            color: #c9d7e8;
            font-size: 12px;
        }

        /* RESPONSIVE */

        @media (max-width: 1150px) {
            .parte-superior {
                flex-wrap: wrap;
            }

            .opciones-usuario {
                margin-left: auto;
                flex-wrap: wrap;
            }

            .contenido-pie {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 750px) {
            .parte-superior {
                padding: 12px 15px;
            }

            .logo img {
                width: 105px;
            }

            .titulo-cuenta {
                font-size: 16px;
                padding-left: 10px;
            }

            .opciones-usuario {
                width: 100%;
                justify-content: space-between;
                gap: 3px;
            }

            .opcion {
                padding: 7px 4px;
                gap: 5px;
            }

            .texto-opcion strong {
                font-size: 12px;
            }

            .texto-opcion small {
                display: none;
            }

            .contenido-nav {
                padding: 0 15px;
                gap: 23px;
                overflow-x: auto;
            }

            .contenedor {
                padding: 25px 15px;
            }

            .tarjeta-cuenta {
                padding: 22px;
            }

            .contenido-pie {
                padding: 32px 20px;
                gap: 25px;
            }

            .linea-pie {
                padding: 17px 20px;
                flex-direction: column;
            }
        }

        @media (max-width: 550px) {
            .formulario,
            .campos-contrasena {
                grid-template-columns: 1fr;
            }

            .campo.completo,
            .seccion-contrasena {
                grid-column: auto;
            }

            .botones {
                flex-direction: column;
            }

            .boton {
                width: 100%;
            }

            .encabezado-tarjeta {
                align-items: flex-start;
                flex-direction: column;
            }

            .contenido-pie {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<!-- ENCABEZADO -->

<header class="encabezado">

    <div class="parte-superior">

        <div class="logo-menu">

            <a href="<%=rutaPrincipal%>" class="logo">
                <img src="<%=imagenes%>logo.png"
                     alt="Logo UNFV SUPERMARKET">
            </a>

            <span class="titulo-cuenta">Mi cuenta</span>

        </div>

        <div class="opciones-usuario">

            <!-- MI CUENTA: OPCIÓN ACTUAL, NO ES ENLACE -->

            <div class="opcion opcion-activa">
                <span class="icono-opcion">
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"/>
                    </svg>
                </span>
                <span class="texto-opcion">
                    <strong>Mi cuenta</strong>
                    <small>Tus datos personales</small>
                </span>
            </div>

            <a href="<%=rutaCarrito%>" class="opcion">
                <span class="icono-opcion">
                    <svg viewBox="0 0 24 24">
                        <path d="M3 3h2l2.5 12h11L21 7H6"/>
                        <circle cx="9" cy="20" r="1"/>
                        <circle cx="18" cy="20" r="1"/>
                    </svg>
                </span>
                <span class="texto-opcion">
                    <strong>Mi carrito</strong>
                    <small>Tus compras</small>
                </span>
            </a>

            <a href="<%=rutaMisCompras%>" class="opcion">
                <span class="icono-opcion">
                    <svg viewBox="0 0 24 24">
                        <path d="M6 3h12v18l-2-1.5L14 21l-2-1.5L10 21l-2-1.5L6 21z"/>
                        <path d="M9 8h6M9 12h6M9 16h4"/>
                    </svg>
                </span>
                <span class="texto-opcion">
                    <strong>Mis compras</strong>
                    <small>Historial de pedidos</small>
                </span>
            </a>

            <a href="<%=ruta%>/CerrarSesionControlador" class="opcion">
                <span class="icono-opcion">
                    <svg viewBox="0 0 24 24">
                        <path d="M10 17l5-5-5-5"/>
                        <path d="M15 12H3"/>
                        <path d="M12 3h7a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-7"/>
                    </svg>
                </span>
                <span class="texto-opcion">
                    <strong>Cerrar sesión</strong>
                    <small>Salir de tu cuenta</small>
                </span>
            </a>

        </div>
    </div>

    <nav class="barra-navegacion">
        <div class="contenido-nav">
            <a href="<%=rutaPrincipal%>">Inicio</a>
            <a href="<%=rutaTienda%>">Volver a tienda</a>
            <a href="<%=rutaPrincipal%>#contacto">Contacto</a>
        </div>
    </nav>

</header>

<!-- CONTENIDO PRINCIPAL -->

<main class="contenedor">

    <section class="bienvenida">
        <h1>Mi cuenta</h1>
        <p>Administra tu información personal y mantén tus datos actualizados.</p>
    </section>

    <% if (mensaje != null && !mensaje.trim().isEmpty()) { %>
        <div class="mensaje">
            <%=mensaje%>
        </div>
    <% } %>

    <section class="tarjeta-cuenta">

        <div class="encabezado-tarjeta">
            <div>
                <h2>Información personal</h2>
                <p>Consulta tus datos o selecciona editar para realizar cambios.</p>
            </div>
        </div>

        <form id="formularioCuenta"
              action="<%=ruta%>/UsuarioControlador"
              method="POST">

            <input type="hidden" name="op" value="4">

            <div class="formulario">

                <div class="campo">
                    <label for="txtnombre">Nombres</label>
                    <input type="text"
                           id="txtnombre"
                           name="txtnombre"
                           value="<%=usuario.nombre == null ? "" : usuario.nombre%>"
                           disabled
                           required>
                </div>

                <div class="campo">
                    <label for="txtapellido">Apellidos</label>
                    <input type="text"
                           id="txtapellido"
                           name="txtapellido"
                           value="<%=usuario.apellido == null ? "" : usuario.apellido%>"
                           disabled
                           required>
                </div>

                <div class="campo">
                    <label for="txtdni">DNI</label>
                    <input type="text"
                           id="txtdni"
                           name="txtdni"
                           value="<%=usuario.dni == null ? "" : usuario.dni%>"
                           disabled
                           required>
                </div>

                <div class="campo">
                    <label for="txtcelular">Celular</label>
                    <input type="text"
                           id="txtcelular"
                           name="txtcelular"
                           value="<%=usuario.celular == null ? "" : usuario.celular%>"
                           disabled
                           required>
                </div>

                <div class="campo completo">
                    <label for="txtcorreo">Correo electrónico</label>
                    <input type="email"
                           id="txtcorreo"
                           name="txtcorreo"
                           value="<%=usuario.correo == null ? "" : usuario.correo%>"
                           disabled
                           required>
                </div>

                <!-- CAMBIO DE CONTRASEÑA -->

                <div class="seccion-contrasena" id="seccionContrasena">

                    <h3>Cambiar contraseña</h3>

                    <div class="campos-contrasena">

                        <div class="campo">
                            <label for="txtcontraseña">Nueva contraseña</label>
                            <input type="password"
                                   id="txtcontraseña"
                                   name="txtcontraseña"
                                   placeholder="Escribe tu nueva contraseña"
                                   disabled>
                        </div>

                        <div class="campo">
                            <label for="txtconfirmarcontraseña">Confirmar nueva contraseña</label>
                            <input type="password"
                                   id="txtconfirmarcontraseña"
                                   name="txtconfirmarcontraseña"
                                   placeholder="Repite tu nueva contraseña"
                                   disabled>
                        </div>

                    </div>

                    <p class="ayuda-contrasena">
                        Si no deseas cambiar tu contraseña, deja ambos campos vacíos.
                    </p>

                </div>

            </div>

            <!-- BOTONES -->

            <div class="botones">

                <button type="button"
                        class="boton boton-editar"
                        id="btnEditar"
                        onclick="activarEdicion()">
                    Editar información
                </button>

                <button type="button"
                        class="boton boton-cancelar"
                        id="btnCancelar"
                        onclick="cancelarEdicion()">
                    Cancelar
                </button>

                <button type="submit"
                        class="boton boton-guardar"
                        id="btnGuardar">
                    Guardar cambios
                </button>

            </div>

        </form>

    </section>

</main>

<!-- PIE DE PÁGINA -->

<footer class="pie" id="contacto">

    <div class="contenido-pie">

        <div class="columna-pie">
            <h3>Sobre nosotros</h3>
            <p>
                Somos un supermercado que busca ofrecer una variedad
                de productos para satisfacer las necesidades de nuestros
                clientes, brindando una experiencia de compra sencilla
                y cómoda.
            </p>
        </div>

        <div class="columna-pie">
            <h3>Contáctanos</h3>

            <p class="dato-contacto">
                <span>Teléfono:</span>
                <strong>900 000 000</strong>
            </p>

            <p class="dato-contacto">
                <span>Correo:</span>
                <strong>admin@gmail.com</strong>
            </p>

            <p class="dato-contacto">
                <span>Atención:</span>
                <strong>Lunes a sábado</strong>
            </p>
        </div>

        <div class="columna-pie">
            <h3>UNFV SUPERMARKET</h3>
            <p class="marca-pie">UNFV SUPERMARKET</p>
            <p>
                Tu supermercado de confianza.
                Todo lo que necesitas en un solo lugar.
            </p>
        </div>

    </div>

    <div class="linea-pie">
        <span>© 2026 UNFV SUPERMARKET - Todos los derechos reservados.</span>
        <span>Gracias por visitarnos.</span>
    </div>

</footer>

<script>

    const formulario = document.getElementById("formularioCuenta");

    const campos = formulario.querySelectorAll(
        "#txtnombre, #txtapellido, #txtdni, #txtcelular, #txtcorreo"
    );

    const seccionContrasena = document.getElementById("seccionContrasena");
    const nuevaContrasena = document.getElementById("txtcontraseña");
    const confirmarContrasena = document.getElementById("txtconfirmarcontraseña");

    const btnEditar = document.getElementById("btnEditar");
    const btnCancelar = document.getElementById("btnCancelar");
    const btnGuardar = document.getElementById("btnGuardar");

    let valoresOriginales = {};

    function activarEdicion() {

        valoresOriginales = {};

        campos.forEach(function(campo) {
            valoresOriginales[campo.id] = campo.value;
            campo.disabled = false;
        });

        nuevaContrasena.disabled = false;
        confirmarContrasena.disabled = false;

        seccionContrasena.classList.add("mostrar");

        btnEditar.style.display = "none";
        btnCancelar.style.display = "inline-block";
        btnGuardar.style.display = "inline-block";
    }

    function cancelarEdicion() {

        campos.forEach(function(campo) {
            campo.value = valoresOriginales[campo.id];
            campo.disabled = true;
        });

        nuevaContrasena.value = "";
        confirmarContrasena.value = "";

        nuevaContrasena.disabled = true;
        confirmarContrasena.disabled = true;

        seccionContrasena.classList.remove("mostrar");

        btnEditar.style.display = "inline-block";
        btnCancelar.style.display = "none";
        btnGuardar.style.display = "none";
    }

    formulario.addEventListener("submit", function(evento) {

        const nueva = nuevaContrasena.value;
        const confirmar = confirmarContrasena.value;

        if ((nueva !== "" || confirmar !== "") && nueva !== confirmar) {
            evento.preventDefault();
            alert("Las contraseñas no coinciden. Verifica ambos campos.");
            confirmarContrasena.focus();
            return;
        }

        if ((nueva === "" && confirmar !== "") ||
            (nueva !== "" && confirmar === "")) {
            evento.preventDefault();
            alert("Debes completar ambos campos para cambiar tu contraseña.");
            return;
        }

        btnGuardar.disabled = true;
        btnCancelar.disabled = true;

        btnGuardar.innerHTML =
            '<span class="cargando"></span>Guardando cambios...';
    });

</script>

</body>
</html>
