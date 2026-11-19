
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Producto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    String rutaLogin = request.getContextPath() + "/Vista/Login/Usuario/LoginUsuAntiguo.jsp";
    String rutaRegistro = request.getContextPath() + "/Vista/Login/Usuario/LoginUsuNuevo.jsp";
    String rutaPrincipal = request.getContextPath() + "/Vista/Principal.jsp";
    String rutaTienda = request.getContextPath() + "/Vista/Comprador/Tienda.jsp";
    String rutaMisCompras = request.getContextPath() + "/CompraControlador?op=4";
    String imagenes = request.getContextPath() + "/Imagenes/ImagenesVentPrincipal/";

    // Obtener los productos registrados para mostrar sugerencias en el buscador
    Producto objProducto = new Producto();
    ArrayList<Producto> listaProductos = objProducto.ListarProducto();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNFV SUPERMARKET</title>

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

        /* MENÚ */

        .menu-categorias {
            position: relative;
        }

        .boton-categorias {
            display: flex;
            align-items: center;
            gap: 9px;
            background: transparent;
            border: none;
            color: #173f70;
            padding: 10px 5px;
            border-radius: 0;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .boton-categorias:hover {
            background: transparent;
            color: #2463a0;
        }

        .hamburguesa {
            font-size: 25px;
        }

        .lista-categorias {
            display: none;
            position: absolute;
            top: 48px;
            left: 0;
            width: 245px;
            background: white;
            border-radius: 6px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            overflow: hidden;
            z-index: 200;
        }

        .lista-categorias.mostrar {
            display: block;
        }

        .lista-categorias a {
            display: block;
            padding: 13px 17px;
            font-size: 14px;
            color: #34465b;
            border-bottom: 1px solid #edf0f4;
            transition: 0.2s;
        }

        .lista-categorias a:hover {
            background: #edf4fc;
            color: #16477f;
            padding-left: 22px;
        }

        /* BUSCADOR */

        .contenedor-buscador {
            position: relative;
            flex: 1;
            max-width: 650px;
            min-width: 180px;
        }

        .buscador {
            width: 100%;
            height: 48px;
            display: flex;
            border: 1px solid #d8e0e9;
            border-radius: 5px;
            overflow: hidden;
            background: #f8fafc;
        }

        .buscador:focus-within {
            border-color: #16477f;
            box-shadow: 0 0 0 2px rgba(22,71,127,0.08);
        }

        .buscador input {
            flex: 1;
            min-width: 0;
            border: none;
            outline: none;
            padding: 0 18px;
            background: transparent;
            font-size: 15px;
        }

        .buscador button {
            width: 55px;
            border: none;
            background: #16477f;
            color: white;
            font-size: 22px;
            cursor: pointer;
        }

        .buscador button:hover {
            background: #12365f;
        }

        /* SUGERENCIAS DEL BUSCADOR */

        .sugerencias-buscador {
            display: none;
            position: absolute;
            top: 53px;
            left: 0;
            width: 100%;
            background: white;
            border: 1px solid #dce3eb;
            border-radius: 6px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.13);
            z-index: 300;
            overflow: hidden;
            max-height: 300px;
            overflow-y: auto;
        }

        .sugerencias-buscador.mostrar {
            display: block;
        }

        .sugerencia {
            display: block;
            width: 100%;
            border: none;
            background: white;
            color: #34465b;
            text-align: left;
            padding: 12px 16px;
            font-size: 14px;
            cursor: pointer;
            border-bottom: 1px solid #edf0f4;
        }

        .sugerencia:last-child {
            border-bottom: none;
        }

        .sugerencia:hover {
            background: #edf4fc;
            color: #16477f;
        }

        .sin-sugerencias {
            padding: 13px 16px;
            color: #8290a0;
            font-size: 13px;
        }

        /* OPCIONES DE USUARIO */

        .opciones-usuario {
            display: flex;
            align-items: center;
            gap: 13px;
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
            padding: 30px 35px;
        }

        .bienvenida {
            margin-bottom: 23px;
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

        /* CARRUSEL */

        .carrusel {
            width: 100%;
            height: 340px;
            position: relative;
            overflow: hidden;
            border-radius: 8px;
            background: #e8edf3;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
        }

        .diapositiva {
            display: none;
            width: 100%;
            height: 100%;
        }

        .diapositiva.activa {
            display: block;
        }

        .diapositiva img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .boton-carrusel {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 50%;
            background: rgba(15,35,60,0.55);
            color: white;
            font-size: 25px;
            cursor: pointer;
        }

        .anterior {
            left: 15px;
        }

        .siguiente {
            right: 15px;
        }

        .indicadores {
            position: absolute;
            bottom: 14px;
            left: 0;
            right: 0;
            display: flex;
            justify-content: center;
            gap: 9px;
        }

        .indicador {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255,255,255,0.6);
            cursor: pointer;
        }

        .indicador.activo {
            background: white;
            transform: scale(1.2);
        }

        /* CATEGORÍAS CON IMÁGENES */

        .seccion-categorias {
            margin-top: 38px;
        }

        .titulo-seccion {
            color: #173f70;
            font-size: 23px;
            margin-bottom: 8px;
        }

        .descripcion-seccion {
            color: #8490a0;
            font-size: 14px;
            margin-bottom: 23px;
        }

        .rejilla-categorias {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 23px;
        }

        .tarjeta-categoria {
            background: white;
            border: 1px solid #e5e9ef;
            border-radius: 7px;
            overflow: hidden;
            transition: 0.25s;
            text-align: center;
        }

        .tarjeta-categoria:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 17px rgba(0,0,0,0.09);
            border-color: #b7cbe0;
        }

        .imagen-categoria {
            width: 100%;
            height: 185px;
            overflow: hidden;
            background: #edf1f5;
        }

        .imagen-categoria img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.3s;
        }

        .tarjeta-categoria:hover .imagen-categoria img {
            transform: scale(1.04);
        }

        .informacion-categoria {
            min-height: 62px;
            padding: 17px 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .informacion-categoria h3 {
            font-size: 15px;
            font-weight: 600;
            color: #293e57;
            text-align: center;
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

            .contenedor-buscador {
                order: 3;
                max-width: none;
                flex-basis: 100%;
            }

            .opciones-usuario {
                margin-left: auto;
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

            .opciones-usuario {
                width: 100%;
                justify-content: space-between;
                gap: 3px;
                flex-wrap: wrap;
            }

            .opcion {
                padding: 7px 4px;
                gap: 5px;
            }

            .texto-opcion strong {
                font-size: 12px;
            }

            .texto-opcion small {
                font-size: 10px;
                display: none;
            }

            .contenido-nav {
                padding: 0 15px;
                gap: 23px;
                overflow-x: auto;
            }

            .contenedor {
                padding: 23px 15px;
            }

            .carrusel {
                height: 220px;
            }

            .rejilla-categorias {
                grid-template-columns: repeat(2, 1fr);
                gap: 13px;
            }

            .imagen-categoria {
                height: 130px;
            }

            .informacion-categoria {
                padding: 13px 11px;
            }

            .informacion-categoria h3 {
                font-size: 13px;
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

        @media (max-width: 430px) {
            .rejilla-categorias {
                grid-template-columns: 1fr;
            }

            .imagen-categoria {
                height: 180px;
            }

            .contenido-pie {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<header class="encabezado">

    <div class="parte-superior">

        <div class="logo-menu">

            <a href="<%=rutaPrincipal%>" class="logo">
                <img src="<%=imagenes%>logo.png"
                     alt="Logo del supermercado">
            </a>

            <div class="menu-categorias">

                <button type="button" class="boton-categorias"
                        onclick="alternarCategorias()">
                    <span class="hamburguesa">☰</span>
                    <span>Categorías</span>
                </button>

                <div class="lista-categorias" id="listaCategorias">
                    <a href="<%=rutaTienda%>?categoria=1">Alimentos y despensa</a>
                    <a href="<%=rutaTienda%>?categoria=2">Frutas y verduras</a>
                    <a href="<%=rutaTienda%>?categoria=3">Carnes y pescados</a>
                    <a href="<%=rutaTienda%>?categoria=4">Lácteos y huevos</a>
                    <a href="<%=rutaTienda%>?categoria=5">Limpieza y hogar</a>
                    <a href="<%=rutaTienda%>?categoria=6">Tecnología</a>
                    <a href="<%=rutaTienda%>?categoria=7">Ropa y accesorios</a>
                    <a href="<%=rutaTienda%>?categoria=8">Calzado</a>
                </div>

            </div>
        </div>

        <!-- BUSCADOR CON PREDICCIONES -->

        <div class="contenedor-buscador">

            <form class="buscador" id="formularioBusqueda"
                  action="<%=rutaTienda%>" method="get">

                <input type="text"
                       id="buscarPrincipal"
                       name="buscar"
                       placeholder="¿Qué estás buscando?"
                       autocomplete="off">

                <button type="submit">⌕</button>

            </form>

            <div class="sugerencias-buscador" id="sugerenciasBuscador"></div>

        </div>

        <!-- CATÁLOGO OCULTO CON LOS NOMBRES DE LOS PRODUCTOS -->

        <div id="catalogoProductos" style="display:none;">

            <% if (listaProductos != null) {
                for (Producto p : listaProductos) {
                    if (p.nombre != null && !p.nombre.trim().isEmpty()) {
            %>

                <span class="nombre-catalogo"
                      data-nombre="<%=URLEncoder.encode(p.nombre, "UTF-8")%>"></span>

            <%
                    }
                }
            } %>

        </div>

        <div class="opciones-usuario">

            <% if (usuario == null) { %>

                <a href="<%=rutaLogin%>" class="opcion">
                    <span class="icono-opcion">
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="8" r="4"/>
                            <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"/>
                        </svg>
                    </span>
                    <span class="texto-opcion">
                        <strong>Hola, inicia sesión</strong>
                        <small>Ingresa a tu cuenta</small>
                    </span>
                </a>

                <a href="<%=rutaLogin%>" class="opcion">
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

                <a href="<%=rutaRegistro%>" class="opcion">
                    <span class="icono-opcion">
                        <svg viewBox="0 0 24 24">
                            <circle cx="9" cy="8" r="4"/>
                            <path d="M2 21c0-4 3-7 7-7"/>
                            <path d="M19 8v8M15 12h8"/>
                        </svg>
                    </span>
                    <span class="texto-opcion">
                        <strong>Registrarse</strong>
                        <small>Crea tu cuenta</small>
                    </span>
                </a>

                <a href="<%=rutaLogin%>" class="opcion">
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

            <% } else { %>

                <div class="opcion">
                    <span class="icono-opcion">
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="8" r="4"/>
                            <path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7"/>
                        </svg>
                    </span>
                    <span class="texto-opcion">
                        <strong>Hola, <%=usuario.nombre%></strong>
                        <small>Bienvenido/a</small>
                    </span>
                </div>

                <a href="<%=request.getContextPath()%>/Vista/Comprador/MiCuenta.jsp"
                   class="opcion">
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

                <a href="<%=request.getContextPath()%>/Vista/Comprador/Carrito.jsp"
                   class="opcion">
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

                <a href="<%=request.getContextPath()%>/CerrarSesionControlador"
                   class="opcion">
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

            <% } %>

        </div>
    </div>

    <nav class="barra-navegacion">
        <div class="contenido-nav">
            <a href="<%=rutaPrincipal%>">Inicio</a>
            <a href="#categorias">Categorías</a>
            <a href="#contacto">Contacto</a>
        </div>
    </nav>

</header>

<main class="contenedor">

    <section class="bienvenida">
        <h1>Bienvenido a nuestro supermercado</h1>
        <p>Encuentra todo lo que necesitas en un solo lugar.</p>
    </section>

    <!-- CARRUSEL -->

    <section class="carrusel">

        <div class="diapositiva activa">
            <img src="<%=imagenes%>calzado.png" alt="Calzado">
        </div>

        <div class="diapositiva">
            <img src="<%=imagenes%>tecnologia.png" alt="Tecnología">
        </div>

        <div class="diapositiva">
            <img src="<%=imagenes%>ropa.png" alt="Ropa">
        </div>

        <button type="button" class="boton-carrusel anterior"
                onclick="cambiarDiapositiva(-1)">‹</button>

        <button type="button" class="boton-carrusel siguiente"
                onclick="cambiarDiapositiva(1)">›</button>

        <div class="indicadores">
            <span class="indicador activo" onclick="mostrarDiapositiva(0)"></span>
            <span class="indicador" onclick="mostrarDiapositiva(1)"></span>
            <span class="indicador" onclick="mostrarDiapositiva(2)"></span>
        </div>

    </section>

    <!-- CATEGORÍAS -->

    <section class="seccion-categorias" id="categorias">

        <h2 class="titulo-seccion">Nuestras categorías</h2>
        <p class="descripcion-seccion">
            Explora nuestros productos y encuentra lo que buscas.
        </p>

        <div class="rejilla-categorias">

            <a href="<%=rutaTienda%>?categoria=1" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Alimentosydespensa.jpg" alt="Alimentos y despensa">
                </div>
                <div class="informacion-categoria">
                    <h3>Alimentos y despensa</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=2" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Frutasyverduras.jpg" alt="Frutas y verduras">
                </div>
                <div class="informacion-categoria">
                    <h3>Frutas y verduras</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=3" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Carnesypescados.jpeg" alt="Carnes y pescados">
                </div>
                <div class="informacion-categoria">
                    <h3>Carnes y pescados</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=4" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Lacteosyhuevos.jpg" alt="Lácteos y huevos">
                </div>
                <div class="informacion-categoria">
                    <h3>Lácteos y huevos</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=5" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Limpieza.jpg" alt="Limpieza y hogar">
                </div>
                <div class="informacion-categoria">
                    <h3>Limpieza y hogar</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=6" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Tecnología.png" alt="Tecnología">
                </div>
                <div class="informacion-categoria">
                    <h3>Tecnología</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=7" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Ropayaccesorios.jpg" alt="Ropa y accesorios">
                </div>
                <div class="informacion-categoria">
                    <h3>Ropa y accesorios</h3>
                </div>
            </a>

            <a href="<%=rutaTienda%>?categoria=8" class="tarjeta-categoria">
                <div class="imagen-categoria">
                    <img src="<%=imagenes%>Calzados.jpg" alt="Calzados">
                </div>
                <div class="informacion-categoria">
                    <h3>Calzado</h3>
                </div>
            </a>

        </div>
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

    // MENÚ DE CATEGORÍAS

    function alternarCategorias() {
        document.getElementById("listaCategorias")
                .classList.toggle("mostrar");
    }

    document.addEventListener("click", function(event) {
        const menu = document.querySelector(".menu-categorias");
        const lista = document.getElementById("listaCategorias");

        if (!menu.contains(event.target)) {
            lista.classList.remove("mostrar");
        }
    });

    // BUSCADOR CON SUGERENCIAS Y BÚSQUEDA SIN TILDES

    const campoBusqueda = document.getElementById("buscarPrincipal");
    const cajaSugerencias = document.getElementById("sugerenciasBuscador");
    const formularioBusqueda = document.getElementById("formularioBusqueda");

    const nombresProductos = [];

    document.querySelectorAll(".nombre-catalogo").forEach(function(elemento) {
        try {
            const nombre = decodeURIComponent(elemento.dataset.nombre.replace(/\+/g, " "));
            if (nombre && !nombresProductos.includes(nombre)) {
                nombresProductos.push(nombre);
            }
        } catch (error) {
            // Ignorar un nombre que no se pueda interpretar
        }
    });

    function normalizarTexto(texto) {
        return texto
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim();
    }

    function mostrarSugerencias() {

        const texto = campoBusqueda.value.trim();
        cajaSugerencias.innerHTML = "";

        if (texto.length === 0) {
            cajaSugerencias.classList.remove("mostrar");
            return;
        }

        const textoNormalizado = normalizarTexto(texto);

        const coincidencias = nombresProductos.filter(function(nombre) {
            return normalizarTexto(nombre).includes(textoNormalizado);
        }).slice(0, 8);

        if (coincidencias.length === 0) {
            const mensaje = document.createElement("div");
            mensaje.className = "sin-sugerencias";
            mensaje.textContent = "No se encontraron productos similares.";
            cajaSugerencias.appendChild(mensaje);
            cajaSugerencias.classList.add("mostrar");
            return;
        }

        coincidencias.forEach(function(nombre) {

            const opcion = document.createElement("button");
            opcion.type = "button";
            opcion.className = "sugerencia";
            opcion.textContent = nombre;

            opcion.addEventListener("click", function() {
                campoBusqueda.value = nombre;
                cajaSugerencias.classList.remove("mostrar");
                formularioBusqueda.submit();
            });

            cajaSugerencias.appendChild(opcion);
        });

        cajaSugerencias.classList.add("mostrar");
    }

    campoBusqueda.addEventListener("input", mostrarSugerencias);

    campoBusqueda.addEventListener("focus", function() {
        if (campoBusqueda.value.trim() !== "") {
            mostrarSugerencias();
        }
    });

    document.addEventListener("click", function(event) {

        if (!event.target.closest(".contenedor-buscador")) {
            cajaSugerencias.classList.remove("mostrar");
        }
    });

    campoBusqueda.addEventListener("keydown", function(event) {

        if (event.key === "Escape") {
            cajaSugerencias.classList.remove("mostrar");
        }
    });

    // CARRUSEL

    let diapositivaActual = 0;

    const diapositivas = document.querySelectorAll(".diapositiva");
    const indicadores = document.querySelectorAll(".indicador");

    function mostrarDiapositiva(numero) {

        diapositivas[diapositivaActual].classList.remove("activa");
        indicadores[diapositivaActual].classList.remove("activo");

        diapositivaActual = (numero + diapositivas.length)
                            % diapositivas.length;

        diapositivas[diapositivaActual].classList.add("activa");
        indicadores[diapositivaActual].classList.add("activo");
    }

    function cambiarDiapositiva(direccion) {
        mostrarDiapositiva(diapositivaActual + direccion);
    }

    setInterval(function() {
        cambiarDiapositiva(1);
    }, 4000);

</script>

</body>
</html>
