
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Locale"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Principal.jsp");
        return;
    }

    ArrayList<Producto> carrito =
        (ArrayList<Producto>) session.getAttribute("carrito");

    double total = 0;
    int totalUnidades = 0;

    if (carrito != null) {
        for (Producto p : carrito) {
            total += p.precio * p.cantidad;
            totalUnidades += p.cantidad;
        }
    }

    String ruta = request.getContextPath();
    String rutaPrincipal = ruta + "/Vista/Principal.jsp";
    String rutaTienda = ruta + "/Vista/Comprador/Tienda.jsp";
    String rutaCarrito = ruta + "/Vista/Comprador/Carrito.jsp";
    String rutaMisCompras = ruta + "/CompraControlador?op=4";
    String rutaMiCuenta = ruta + "/Vista/Comprador/MiCuenta.jsp";

    String imagenLogo = ruta + "/Imagenes/ImagenesVentPrincipal/logo.png";
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Mi carrito - UNFV SUPERMARKET</title>

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

        .titulo-pagina {
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

        /* DISTRIBUCIÓN */

        .contenido-carrito {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 25px;
            align-items: start;
        }

        /* TARJETA DE PRODUCTOS */

        .tarjeta-productos {
            background: white;
            border: 1px solid #e5e9ef;
            border-radius: 7px;
            padding: 25px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        .encabezado-productos {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding-bottom: 19px;
            border-bottom: 1px solid #e8edf2;
        }

        .encabezado-productos h2 {
            color: #173f70;
            font-size: 19px;
        }

        .cantidad-productos {
            color: #8290a0;
            font-size: 13px;
            white-space: nowrap;
        }

        /* PRODUCTO */

        .producto {
            display: grid;
            grid-template-columns: 115px minmax(0, 1fr) 125px;
            gap: 20px;
            align-items: center;
            padding: 23px 0;
            border-bottom: 1px solid #e8edf2;
        }

        .producto:last-child {
            border-bottom: none;
        }

        .imagen-producto {
            width: 115px;
            height: 115px;
            background: #f5f7fa;
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 9px;
            overflow: hidden;
        }

        .imagen-producto img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .sin-imagen {
            color: #8993a2;
            font-size: 12px;
            text-align: center;
        }

        .informacion-producto h3 {
            color: #26364a;
            font-size: 16px;
            margin-bottom: 10px;
        }

        .precio {
            color: #16477f;
            font-size: 15px;
            font-weight: bold;
            margin-bottom: 14px;
        }

        /* CANTIDAD */

        .cantidad {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .cantidad form {
            display: inline;
        }

        .cantidad button {
            width: 30px;
            height: 30px;
            border: 1px solid #d8e0e9;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            color: #16477f;
            transition: 0.2s;
        }

        .cantidad button:hover {
            background: #edf4fc;
            border-color: #16477f;
        }

        .numero {
            min-width: 20px;
            text-align: center;
            font-size: 14px;
            font-weight: bold;
        }

        /* SUBTOTAL */

        .subtotal {
            text-align: right;
        }

        .subtotal strong {
            color: #173f70;
            font-size: 15px;
            white-space: nowrap;
        }

        .eliminar {
            display: block;
            margin: 12px 0 0 auto;
            border: none;
            background: transparent;
            color: #d94b4b;
            cursor: pointer;
            font-size: 12px;
        }

        .eliminar:hover {
            text-decoration: underline;
        }

        .seguir-comprando {
            display: inline-block;
            margin-top: 20px;
            color: #16477f;
            font-size: 13px;
            font-weight: bold;
        }

        .seguir-comprando:hover {
            text-decoration: underline;
        }

        /* RESUMEN */

        .resumen {
            background: white;
            border: 1px solid #e5e9ef;
            border-radius: 7px;
            padding: 25px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
            position: sticky;
            top: 20px;
        }

        .resumen h2 {
            color: #173f70;
            font-size: 19px;
            margin-bottom: 23px;
        }

        .fila-resumen {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
            color: #778496;
            font-size: 14px;
        }

        .fila-resumen strong {
            color: #26364a;
        }

        .fila-total {
            border-top: 1px solid #e8edf2;
            padding-top: 20px;
            margin-top: 5px;
            margin-bottom: 20px;
        }

        .fila-total span {
            color: #173f70;
            font-size: 17px;
            font-weight: bold;
        }

        .fila-total strong {
            color: #173f70;
            font-size: 21px;
        }

        /* BOTONES */

        .boton-confirmar {
            width: 100%;
            min-height: 45px;
            padding: 12px;
            background: #16477f;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .boton-confirmar:hover {
            background: #12365f;
        }

        .boton-vaciar {
            width: 100%;
            min-height: 43px;
            padding: 11px;
            margin-top: 12px;
            background: white;
            border: 1px solid #d94b4b;
            color: #d94b4b;
            border-radius: 5px;
            font-size: 13px;
            cursor: pointer;
            transition: 0.2s;
        }

        .boton-vaciar:hover {
            background: #fff3f3;
        }

        .nota {
            background: #f3f7fb;
            border: 1px solid #e2ebf4;
            border-radius: 5px;
            padding: 13px;
            margin-top: 19px;
            color: #718096;
            font-size: 12px;
            line-height: 1.6;
        }

        /* CARRITO VACÍO */

        .carrito-vacio {
            background: white;
            border: 1px solid #e5e9ef;
            border-radius: 7px;
            padding: 65px 20px;
            text-align: center;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }

        .icono-vacio {
            font-size: 55px;
            margin-bottom: 20px;
        }

        .carrito-vacio h2 {
            color: #173f70;
            font-size: 22px;
            margin-bottom: 12px;
        }

        .carrito-vacio p {
            color: #778496;
            font-size: 14px;
            margin-bottom: 23px;
            line-height: 1.6;
        }

        .boton-tienda {
            display: inline-block;
            padding: 13px 23px;
            background: #16477f;
            color: white;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            transition: 0.2s;
        }

        .boton-tienda:hover {
            background: #12365f;
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

            .contenido-carrito {
                grid-template-columns: 1fr;
            }

            .resumen {
                position: static;
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

            .titulo-pagina {
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

            .tarjeta-productos {
                padding: 18px;
            }

            .producto {
                grid-template-columns: 85px minmax(0, 1fr);
                gap: 13px;
            }

            .imagen-producto {
                width: 85px;
                height: 85px;
            }

            .subtotal {
                grid-column: 2;
                display: flex;
                justify-content: space-between;
                align-items: center;
                text-align: left;
            }

            .eliminar {
                margin: 0;
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

            .contenido-pie {
                grid-template-columns: 1fr;
            }

            .encabezado-productos {
                align-items: flex-start;
                flex-direction: column;
            }

            .informacion-producto h3 {
                font-size: 14px;
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
                <img src="<%=imagenLogo%>"
                     alt="Logo UNFV SUPERMARKET">
            </a>

            <span class="titulo-pagina">Mi carrito</span>

        </div>

        <div class="opciones-usuario">

            <a href="<%=rutaMiCuenta%>" class="opcion">

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

            </a>

            <!-- MI CARRITO: OPCIÓN ACTUAL -->

            <div class="opcion opcion-activa">

                <span class="icono-opcion">
                    <svg viewBox="0 0 24 24">
                        <path d="M3 3h2l2.5 12h11L21 7H6"/>
                        <circle cx="9" cy="20" r="1"/>
                        <circle cx="18" cy="20" r="1"/>
                    </svg>
                </span>

                <span class="texto-opcion">
                    <strong>Mi carrito</strong>
                    <small>Tus productos</small>
                </span>

            </div>

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

            <a href="<%=rutaMisCompras%>">Mis compras</a>

            <a href="<%=rutaPrincipal%>#contacto">Contacto</a>

        </div>

    </nav>

</header>

<!-- CONTENIDO PRINCIPAL -->

<main class="contenedor">

    <section class="bienvenida">

        <h1>Mi carrito</h1>

        <p>
            Revisa los productos que elegiste antes de confirmar tu compra.
        </p>

    </section>

    <%
        if (carrito == null || carrito.isEmpty()) {
    %>

        <!-- CARRITO VACÍO -->

        <section class="carrito-vacio">

            <div class="icono-vacio">🛒</div>

            <h2>Tu carrito está vacío</h2>

            <p>
                Todavía no has agregado productos.
                Explora nuestra tienda y encuentra lo que necesitas.
            </p>

            <a href="<%=rutaTienda%>" class="boton-tienda">
                Ir a la tienda
            </a>

        </section>

    <%
        } else {
    %>

        <div class="contenido-carrito">

            <!-- PRODUCTOS -->

            <section class="tarjeta-productos">

                <div class="encabezado-productos">

                    <h2>Productos seleccionados</h2>

                    <span class="cantidad-productos">
                        <%=totalUnidades%> unidad(es)
                    </span>

                </div>

                <%
                    for (Producto p : carrito) {

                        double subtotal = p.precio * p.cantidad;

                        // OBTENER LA RUTA CORRECTA DE LA IMAGEN
                        String nombreImagen =
                            p.imagen != null ? p.imagen.trim() : "";

                        String rutaImagenProducto = "";

                        if (!nombreImagen.isEmpty()) {

                            // IMÁGENES GUARDADAS EN CLOUDINARY
                            if (nombreImagen.startsWith("https://")
                                    || nombreImagen.startsWith("http://")) {

                                rutaImagenProducto = nombreImagen;

                            } else {

                                // IMÁGENES ANTIGUAS GUARDADAS LOCALMENTE
                                nombreImagen =
                                    nombreImagen.replace("\\", "/");

                                while (nombreImagen.startsWith("/")) {
                                    nombreImagen = nombreImagen.substring(1);
                                }

                                if (nombreImagen.startsWith("Imagenes/")) {

                                    rutaImagenProducto =
                                        ruta + "/" + nombreImagen;

                                } else if (nombreImagen.startsWith("ImagenesProductos/")) {

                                    rutaImagenProducto =
                                        ruta + "/Imagenes/" + nombreImagen;

                                } else {

                                    rutaImagenProducto =
                                        ruta + "/Imagenes/ImagenesProductos/"
                                        + nombreImagen;
                                }
                            }
                        }
                %>

                    <article class="producto">

                        <div class="imagen-producto">

                            <% if (!rutaImagenProducto.isEmpty()) { %>

                                <img
                                    src="<%=rutaImagenProducto%>"
                                    alt="<%=p.nombre%>"
                                    onerror="this.style.display='none'; this.nextElementSibling.style.display='block';"
                                >

                                <span class="sin-imagen" style="display:none;">
                                    Sin imagen
                                </span>

                            <% } else { %>

                                <span class="sin-imagen">
                                    Sin imagen
                                </span>

                            <% } %>

                        </div>

                        <div class="informacion-producto">

                            <h3><%=p.nombre%></h3>

                            <p class="precio">
                                S/ <%=String.format(Locale.US, "%.2f", p.precio)%>
                            </p>

                            <div class="cantidad">

                                <!-- DISMINUIR -->

                                <form
                                    action="<%=ruta%>/CarritoControlador"
                                    method="POST"
                                >

                                    <input type="hidden" name="op" value="5">

                                    <input
                                        type="hidden"
                                        name="txtidproducto"
                                        value="<%=p.id_producto%>"
                                    >

                                    <button type="submit" title="Disminuir cantidad">
                                        −
                                    </button>

                                </form>

                                <span class="numero">
                                    <%=p.cantidad%>
                                </span>

                                <!-- AUMENTAR -->

                                <form
                                    action="<%=ruta%>/CarritoControlador"
                                    method="POST"
                                >

                                    <input type="hidden" name="op" value="4">

                                    <input
                                        type="hidden"
                                        name="txtidproducto"
                                        value="<%=p.id_producto%>"
                                    >

                                    <button type="submit" title="Aumentar cantidad">
                                        +
                                    </button>

                                </form>

                            </div>

                        </div>

                        <!-- SUBTOTAL Y ELIMINAR -->

                        <div class="subtotal">

                            <strong>
                                S/ <%=String.format(Locale.US, "%.2f", subtotal)%>
                            </strong>

                            <form
                                action="<%=ruta%>/CarritoControlador"
                                method="POST"
                            >

                                <input type="hidden" name="op" value="2">

                                <input
                                    type="hidden"
                                    name="txtidproducto"
                                    value="<%=p.id_producto%>"
                                >

                                <button type="submit" class="eliminar">
                                    Eliminar
                                </button>

                            </form>

                        </div>

                    </article>

                <%
                    }
                %>

                <a href="<%=rutaTienda%>" class="seguir-comprando">
                    ← Seguir comprando
                </a>

            </section>

            <!-- RESUMEN DE COMPRA -->

            <aside class="resumen">

                <h2>Resumen de compra</h2>

                <div class="fila-resumen">

                    <span>Productos diferentes</span>

                    <strong><%=carrito.size()%></strong>

                </div>

                <div class="fila-resumen">

                    <span>Unidades en total</span>

                    <strong><%=totalUnidades%></strong>

                </div>

                <div class="fila-resumen">

                    <span>Envío</span>

                    <strong>Gratis</strong>

                </div>

                <div class="fila-resumen fila-total">

                    <span>Total</span>

                    <strong>
                        S/ <%=String.format(Locale.US, "%.2f", total)%>
                    </strong>

                </div>

                <!-- CONFIRMAR COMPRA -->

                <form
                    action="<%=ruta%>/CompraControlador"
                    method="POST"
                    onsubmit="return confirmarCompra();"
                >

                    <input type="hidden" name="op" value="1">

                    <button type="submit" class="boton-confirmar">
                        Confirmar compra
                    </button>

                </form>

                <!-- VACIAR CARRITO -->

                <form
                    action="<%=ruta%>/CarritoControlador"
                    method="POST"
                    onsubmit="return confirmarVaciar();"
                >

                    <input type="hidden" name="op" value="3">

                    <button type="submit" class="boton-vaciar">
                        Vaciar carrito
                    </button>

                </form>

                <div class="nota">

                    Al confirmar tu compra, se registrará tu pedido
                    y podrás consultar su información posteriormente
                    desde la sección <strong>Mis compras</strong>.

                </div>

            </aside>

        </div>

    <%
        }
    %>

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

    function confirmarCompra() {

        return confirm(
            "¿Estás seguro de que deseas confirmar tu compra?"
        );

    }

    function confirmarVaciar() {

        return confirm(
            "¿Deseas eliminar todos los productos de tu carrito?"
        );

    }

</script>

</body>
</html>
