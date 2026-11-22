
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Compra"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Locale"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(
            request.getContextPath() + "/Vista/Principal.jsp"
        );
        return;
    }

    ArrayList<Compra> compras =
        (ArrayList<Compra>) request.getAttribute("listaCompras");

    if (compras == null) {
        response.sendRedirect(
            request.getContextPath() + "/CompraControlador?op=4"
        );
        return;
    }

    String ruta = request.getContextPath();

    String rutaPrincipal = ruta + "/Vista/Principal.jsp";
    String rutaTienda = ruta + "/Vista/Comprador/Tienda.jsp";
    String rutaCarrito = ruta + "/Vista/Comprador/Carrito.jsp";
    String rutaMiCuenta = ruta + "/Vista/Comprador/MiCuenta.jsp";
    String rutaMisCompras = ruta + "/CompraControlador?op=4";
    String rutaCerrarSesion = ruta + "/CerrarSesionControlador";

    String imagenLogo = ruta + "/Imagenes/ImagenesVentPrincipal/logo.png";

    int cantidadCompras = compras.size();

    double totalComprado = 0;

    for (Compra c : compras) {
        totalComprado += c.total;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Mis compras | UNFV SUPERMARKET</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f5f7fa;
            color: #26364a;
        }

        /* ENCABEZADO */

        .encabezado {
            background: white;
            width: 100%;
            box-shadow: 0 2px 10px rgba(0,0,0,.04);
        }

        .parte-superior {
            max-width: 1500px;
            margin: auto;
            padding: 13px 35px;
            min-height: 95px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px;
        }

        .logo-menu {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .logo {
            display: flex;
            align-items: center;
            text-decoration: none;
        }

        .logo img {
            width: 145px;
            height: 65px;
            object-fit: contain;
        }

        .titulo-cuenta {
            border-left: 1px solid #e5e9ef;
            padding-left: 20px;
            font-size: 19px;
            color: #26364a;
            font-weight: bold;
        }

        .opciones-usuario {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .opcion {
            display: flex;
            align-items: center;
            gap: 9px;
            color: #26364a;
            text-decoration: none;
            font-size: 13px;
            transition: color .2s;
        }

        .opcion:hover,
        .opcion.activa {
            color: #16477f;
        }

        .icono-opcion {
            width: 25px;
            height: 25px;
            color: #16477f;
            flex-shrink: 0;
        }

        .texto-opcion {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .texto-opcion strong {
            font-size: 13px;
        }

        .texto-opcion small {
            color: #8993a2;
            font-size: 11px;
        }

        /* NAVEGACIÓN */

        .barra-navegacion {
            background: #123f73;
        }

        .contenido-nav {
            max-width: 1500px;
            margin: auto;
            padding: 0 35px;
            height: 46px;
            display: flex;
            align-items: center;
            gap: 35px;
        }

        .contenido-nav a {
            color: white;
            text-decoration: none;
            font-size: 13px;
            transition: opacity .2s;
        }

        .contenido-nav a:hover {
            opacity: .75;
        }

        /* CONTENIDO */

        .contenido {
            width: 90%;
            max-width: 1150px;
            margin: 42px auto 65px;
            min-height: 400px;
        }

        .encabezado-pagina {
            margin-bottom: 28px;
        }

        .encabezado-pagina h1 {
            font-size: 27px;
            color: #173f70;
            margin-bottom: 9px;
        }

        .encabezado-pagina p {
            color: #8993a2;
            font-size: 14px;
            line-height: 1.6;
        }

        /* RESUMEN */

        .resumen-compras {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-bottom: 30px;
        }

        .resumen-item {
            background: white;
            padding: 22px 25px;
            border-radius: 10px;
            border: 1px solid #edf0f4;
        }

        .resumen-item span {
            display: block;
            color: #8993a2;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .resumen-item strong {
            font-size: 23px;
            color: #16477f;
        }

        /* COMPRAS */

        .lista-compras {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .compra {
            background: white;
            border: 1px solid #e9edf2;
            border-radius: 12px;
            overflow: hidden;
        }

        .compra-cabecera {
            padding: 21px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
            border-bottom: 1px solid #edf0f4;
        }

        .compra-identificacion h2 {
            font-size: 17px;
            color: #173f70;
            margin-bottom: 7px;
        }

        .compra-identificacion p {
            color: #8993a2;
            font-size: 12px;
        }

        .estado {
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            background: #fff3d6;
            color: #a66b00;
        }

        .estado.pendiente {
            background: #fff3d6;
            color: #a66b00;
        }

        .estado.entregada,
        .estado.completada {
            background: #e3f6eb;
            color: #25824d;
        }

        .estado.cancelada,
        .estado.rechazada {
            background: #fde8e8;
            color: #c33d3d;
        }

        .compra-contenido {
            padding: 21px 24px;
        }

        .datos-compra {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }

        .cantidad-productos {
            color: #8993a2;
            font-size: 13px;
        }

        .total-compra {
            text-align: right;
        }

        .total-compra span {
            display: block;
            font-size: 12px;
            color: #8993a2;
            margin-bottom: 5px;
        }

        .total-compra strong {
            font-size: 20px;
            color: #16477f;
        }

        /* DETALLE DE PRODUCTOS */

        .detalle {
            margin-top: 20px;
            border-top: 1px solid #edf0f4;
            padding-top: 17px;
        }

        .detalle summary {
            list-style: none;
            cursor: pointer;
            color: #16477f;
            font-size: 13px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .detalle summary::-webkit-details-marker {
            display: none;
        }

        .detalle summary::after {
            content: "+";
            font-size: 20px;
        }

        .detalle[open] summary::after {
            content: "−";
        }

        .lista-productos {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 20px;
        }

        .producto {
            display: grid;
            grid-template-columns: 65px 1fr auto;
            align-items: center;
            gap: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f2f5;
        }

        .producto:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .imagen-producto {
            width: 65px;
            height: 65px;
            border-radius: 8px;
            background: #f5f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            padding: 5px;
        }

        .imagen-producto img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .sin-imagen {
            font-size: 10px;
            color: #8993a2;
            text-align: center;
        }

        .informacion-producto h3 {
            font-size: 14px;
            margin-bottom: 6px;
            color: #26364a;
        }

        .informacion-producto p {
            color: #8993a2;
            font-size: 12px;
            margin-top: 4px;
        }

        .subtotal-producto {
            font-size: 14px;
            font-weight: bold;
            color: #26364a;
            white-space: nowrap;
        }

        /* SIN COMPRAS */

        .sin-compras {
            background: white;
            padding: 65px 25px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid #edf0f4;
        }

        .icono-vacio {
            width: 55px;
            height: 55px;
            color: #16477f;
            margin: 0 auto 18px;
        }

        .sin-compras h2 {
            font-size: 21px;
            color: #173f70;
            margin-bottom: 10px;
        }

        .sin-compras p {
            font-size: 14px;
            color: #8993a2;
            margin-bottom: 22px;
        }

        .boton-tienda {
            display: inline-block;
            padding: 12px 22px;
            border-radius: 7px;
            background: #16477f;
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            transition: background .2s;
        }

        .boton-tienda:hover {
            background: #123f73;
        }

        /* PIE DE PÁGINA */

        .pie {
            background: #123f73;
            color: white;
            padding: 42px 7% 20px;
        }

        .contenido-pie {
            max-width: 1300px;
            margin: auto;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 40px;
        }

        .columna-pie h3 {
            font-size: 16px;
            margin-bottom: 17px;
        }

        .columna-pie p {
            color: #dce6f1;
            font-size: 13px;
            line-height: 1.9;
        }

        .copyright {
            max-width: 1300px;
            margin: 30px auto 0;
            padding-top: 17px;
            border-top: 1px solid rgba(255,255,255,.2);
            text-align: center;
            color: #dce6f1;
            font-size: 12px;
        }

        /* RESPONSIVE */

        @media(max-width: 1050px) {
            .parte-superior {
                padding: 13px 20px;
            }

            .opciones-usuario {
                gap: 15px;
            }

            .texto-opcion small {
                display: none;
            }
        }

        @media(max-width: 750px) {
            .parte-superior {
                flex-wrap: wrap;
                justify-content: center;
            }

            .opciones-usuario {
                width: 100%;
                justify-content: center;
                flex-wrap: wrap;
            }

            .contenido-nav {
                padding: 0 20px;
                gap: 22px;
            }

            .contenido {
                width: 92%;
            }

            .contenido-pie {
                grid-template-columns: 1fr;
                gap: 25px;
            }
        }

        @media(max-width: 480px) {
            .logo-menu {
                flex-wrap: wrap;
                justify-content: center;
            }

            .logo img {
                width: 135px;
            }

            .titulo-cuenta {
                border-left: none;
                padding-left: 0;
            }

            .opciones-usuario {
                gap: 13px;
            }

            .opcion {
                gap: 5px;
            }

            .texto-opcion strong {
                font-size: 11px;
            }

            .contenido-nav {
                gap: 16px;
            }

            .contenido-nav a {
                font-size: 12px;
            }

            .resumen-compras {
                grid-template-columns: 1fr;
            }

            .compra-cabecera,
            .compra-contenido {
                padding: 17px;
            }

            .producto {
                grid-template-columns: 55px 1fr;
            }

            .imagen-producto {
                width: 55px;
                height: 55px;
            }

            .subtotal-producto {
                grid-column: 2;
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
                    <img src="<%=imagenLogo%>" alt="UNFV SUPERMARKET">
                </a>

                <div class="titulo-cuenta">
                    Mis compras
                </div>

            </div>

            <div class="opciones-usuario">

                <a href="<%=rutaMiCuenta%>" class="opcion">

                    <svg class="icono-opcion" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M5 21v-2a7 7 0 0 1 14 0v2"/>
                    </svg>

                    <span class="texto-opcion">
                        <strong>Mi cuenta</strong>
                        <small>Mis datos</small>
                    </span>

                </a>

                <a href="<%=rutaCarrito%>" class="opcion">

                    <svg class="icono-opcion" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round">
                        <circle cx="9" cy="21" r="1"/>
                        <circle cx="20" cy="21" r="1"/>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                    </svg>

                    <span class="texto-opcion">
                        <strong>Mi carrito</strong>
                        <small>Mis productos</small>
                    </span>

                </a>

                <a href="<%=rutaMisCompras%>" class="opcion activa">

                    <svg class="icono-opcion" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round">
                        <path d="M21 8V21H3V8"/>
                        <path d="M1 3h22v5H1z"/>
                        <path d="M10 12h4"/>
                    </svg>

                    <span class="texto-opcion">
                        <strong>Mis compras</strong>
                        <small>Mis pedidos</small>
                    </span>

                </a>

                <a href="<%=rutaCerrarSesion%>" class="opcion">

                    <svg class="icono-opcion" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round">
                        <path d="M10 17l5-5-5-5"/>
                        <path d="M15 12H3"/>
                        <path d="M12 3h7a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-7"/>
                    </svg>

                    <span class="texto-opcion">
                        <strong>Cerrar sesión</strong>
                        <small>Salir</small>
                    </span>

                </a>

            </div>

        </div>

    </header>

    <!-- NAVEGACIÓN -->

    <nav class="barra-navegacion">

        <div class="contenido-nav">

            <a href="<%=rutaPrincipal%>">Inicio</a>

            <a href="<%=rutaTienda%>">Volver a tienda</a>

            <a href="<%=rutaPrincipal%>#contacto">Contacto</a>

        </div>

    </nav>

    <!-- CONTENIDO -->

    <main class="contenido">

        <div class="encabezado-pagina">

            <h1>Mis compras</h1>

            <p>
                Aquí puedes consultar los pedidos que has realizado
                y revisar los productos de cada compra.
            </p>

        </div>

        <% if (compras.isEmpty()) { %>

            <section class="sin-compras">

                <svg class="icono-vacio" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor"
                     stroke-width="1.5" stroke-linecap="round"
                     stroke-linejoin="round">
                    <path d="M6 7h12l1 14H5L6 7z"/>
                    <path d="M9 7a3 3 0 0 1 6 0"/>
                    <path d="M9 12h6"/>
                </svg>

                <h2>Aún no tienes compras</h2>

                <p>
                    Cuando realices una compra, aparecerá aquí
                    con todos sus detalles.
                </p>

                <a href="<%=rutaTienda%>" class="boton-tienda">
                    Explorar productos
                </a>

            </section>

        <% } else { %>

            <section class="resumen-compras">

                <div class="resumen-item">

                    <span>Compras realizadas</span>

                    <strong><%=cantidadCompras%></strong>

                </div>

                <div class="resumen-item">

                    <span>Total de tus compras</span>

                    <strong>
                        S/ <%=String.format(Locale.US, "%.2f", totalComprado)%>
                    </strong>

                </div>

            </section>

            <section class="lista-compras">

                <% for (Compra compra : compras) {

                    String estado = compra.estado == null
                        ? "Pendiente" : compra.estado;

                    String claseEstado = estado.toLowerCase(Locale.ROOT)
                        .replace(" ", "")
                        .replace("á", "a")
                        .replace("é", "e")
                        .replace("í", "i")
                        .replace("ó", "o")
                        .replace("ú", "u");
                %>

                    <article class="compra">

                        <div class="compra-cabecera">

                            <div class="compra-identificacion">

                                <h2>
                                    Compra #<%=compra.id_compra%>
                                </h2>

                                <p>
                                    Fecha:
                                    <%=compra.fecha == null
                                        ? "No disponible" : compra.fecha%>
                                </p>

                            </div>

                            <span class="estado <%=claseEstado%>">
                                <%=estado%>
                            </span>

                        </div>

                        <div class="compra-contenido">

                            <div class="datos-compra">

                                <div class="cantidad-productos">

                                    <%=compra.detalles.size()%>
                                    producto(s) en esta compra

                                </div>

                                <div class="total-compra">

                                    <span>Total de la compra</span>

                                    <strong>
                                        S/ <%=String.format(
                                            Locale.US, "%.2f", compra.total
                                        )%>
                                    </strong>

                                </div>

                            </div>

                            <details class="detalle">

                                <summary>Ver detalle de la compra</summary>

                                <div class="lista-productos">

                                    <% for (Producto producto : compra.detalles) {

                                        double subtotal =
                                            producto.precio * producto.cantidad;

                                        String nombreProducto =
                                            producto.nombre == null
                                            ? "Producto no disponible"
                                            : producto.nombre;

                                        // OBTENER LA RUTA CORRECTA DE LA IMAGEN
                                        String nombreImagen =
                                            producto.imagen != null
                                            ? producto.imagen.trim()
                                            : "";

                                        String rutaImagenProducto = "";

                                        if (!nombreImagen.isEmpty()) {

                                            // IMÁGENES DE CLOUDINARY
                                            if (nombreImagen.startsWith("https://")
                                                    || nombreImagen.startsWith("http://")) {

                                                rutaImagenProducto = nombreImagen;

                                            } else {

                                                // IMÁGENES ANTIGUAS GUARDADAS LOCALMENTE
                                                nombreImagen =
                                                    nombreImagen.replace("\\", "/");

                                                while (nombreImagen.startsWith("/")) {
                                                    nombreImagen =
                                                        nombreImagen.substring(1);
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

                                        <div class="producto">

                                            <div class="imagen-producto">

                                                <% if (!rutaImagenProducto.isEmpty()) { %>

                                                    <img
                                                        src="<%=rutaImagenProducto%>"
                                                        alt="<%=nombreProducto%>"
                                                        onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">

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

                                                <h3><%=nombreProducto%></h3>

                                                <p>
                                                    Cantidad: <%=producto.cantidad%>
                                                </p>

                                                <p>
                                                    Precio unitario:
                                                    S/ <%=String.format(
                                                        Locale.US,
                                                        "%.2f",
                                                        producto.precio
                                                    )%>
                                                </p>

                                            </div>

                                            <div class="subtotal-producto">

                                                S/ <%=String.format(
                                                    Locale.US,
                                                    "%.2f",
                                                    subtotal
                                                )%>

                                            </div>

                                        </div>

                                    <% } %>

                                </div>

                            </details>

                        </div>

                    </article>

                <% } %>

            </section>

        <% } %>

    </main>

    <!-- PIE DE PÁGINA -->

    <footer class="pie">

        <div class="contenido-pie">

            <div class="columna-pie">

                <h3>Sobre nosotros</h3>

                <p>
                    En UNFV SUPERMARKET encontrarás productos
                    de calidad para tus compras diarias.
                </p>

            </div>

            <div class="columna-pie">

                <h3>Contáctanos</h3>

                <p>
                    Teléfono: 900 000 000
                    <br>
                    Correo: admin@gmail.com
                    <br>
                    Atención: Lunes a sábado
                </p>

            </div>

            <div class="columna-pie">

                <h3>UNFV SUPERMARKET</h3>

                <p>
                    Tu supermercado de confianza.
                    Gracias por comprar con nosotros.
                </p>

            </div>

        </div>

        <div class="copyright">

            © 2026 UNFV SUPERMARKET - Todos los derechos reservados.

        </div>

    </footer>

</body>
</html>
