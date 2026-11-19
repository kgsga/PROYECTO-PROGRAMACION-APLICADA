
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.Normalizer"%>
<%@page import="java.util.Locale"%>

<%!
    // Quita las tildes y convierte el texto a minúsculas
    public String normalizarTexto(String texto) {
        if (texto == null) {
            return "";
        }

        return Normalizer.normalize(texto, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase(Locale.ROOT);
    }

    // Evita que los nombres de productos rompan el HTML de las sugerencias
    public String escaparHTML(String texto) {
        if (texto == null) {
            return "";
        }

        return texto.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean sesionIniciada = usuario != null;

    Producto objProducto = new Producto();
    ArrayList<Producto> listaProductos = objProducto.ListarProducto();

    String mensaje = (String) request.getAttribute("mensaje");

    String categoriaParam = request.getParameter("categoria");
    String buscarParam = request.getParameter("buscar");

    int categoriaSeleccionada = 0;

    if (categoriaParam != null && !categoriaParam.isEmpty()) {
        try {
            categoriaSeleccionada = Integer.parseInt(categoriaParam);
        } catch (NumberFormatException e) {
            categoriaSeleccionada = 0;
        }
    }

    String nombreCategoria = "Todos los productos";

    switch (categoriaSeleccionada) {
        case 1: nombreCategoria = "Alimentos y despensa"; break;
        case 2: nombreCategoria = "Frutas y verduras"; break;
        case 3: nombreCategoria = "Carnes y pescados"; break;
        case 4: nombreCategoria = "Lácteos y huevos"; break;
        case 5: nombreCategoria = "Limpieza y hogar"; break;
        case 6: nombreCategoria = "Tecnología"; break;
        case 7: nombreCategoria = "Ropa y accesorios"; break;
        case 8: nombreCategoria = "Calzado"; break;
    }

    String rutaPrincipal = request.getContextPath() + "/Vista/Principal.jsp";
    String rutaTienda = request.getContextPath() + "/Vista/Comprador/Tienda.jsp";
    String rutaCarrito = request.getContextPath() + "/Vista/Comprador/Carrito.jsp";
    String rutaCuenta = request.getContextPath() + "/Vista/Comprador/MiCuenta.jsp";
    String rutaMisCompras = request.getContextPath() + "/CompraControlador?op=4";
    String rutaCerrarSesion = request.getContextPath() + "/CerrarSesionControlador";

    String rutaLogin = request.getContextPath() + "/Vista/Login/Usuario/LoginUsuAntiguo.jsp";
    String rutaRegistro = request.getContextPath() + "/Vista/Login/Usuario/LoginUsuNuevo.jsp";

    String imagenes = request.getContextPath() + "/Imagenes/ImagenesVentPrincipal/";

    String busquedaNormalizada = normalizarTexto(buscarParam);

    int totalProductos = 0;

    if (listaProductos != null) {
        for (Producto p : listaProductos) {

            boolean coincideCategoria =
                    categoriaSeleccionada == 0
                    || p.id_categoria == categoriaSeleccionada;

            boolean coincideBusqueda =
                    buscarParam == null
                    || buscarParam.trim().isEmpty()
                    || (p.nombre != null
                    && normalizarTexto(p.nombre).contains(busquedaNormalizada));

            if (coincideCategoria && coincideBusqueda) {
                totalProductos++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tienda | UNFV Supermarket</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f5f7fa;
            color: #333;
        }

        a {
            text-decoration: none;
        }

        /* ENCABEZADO */

        .encabezado {
            background: white;
            padding: 13px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 22px;
            flex-wrap: wrap;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }

        .logo img {
            width: 145px;
            height: 65px;
            object-fit: contain;
        }

        .zona-categorias {
            position: relative;
        }

        .btn-categorias {
            border: none;
            background: #16477f;
            color: white;
            padding: 13px 17px;
            border-radius: 7px;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-categorias:hover {
            background: #12365f;
        }

        .lista-categorias {
            display: none;
            position: absolute;
            top: 45px;
            left: 0;
            width: 230px;
            background: white;
            box-shadow: 0 5px 18px rgba(0,0,0,0.15);
            border-radius: 8px;
            z-index: 20;
            overflow: hidden;
        }

        .lista-categorias a {
            display: block;
            color: #333;
            padding: 12px 15px;
            font-size: 14px;
            border-bottom: 1px solid #eee;
        }

        .lista-categorias a:hover {
            background: #edf3fa;
            color: #16477f;
        }

        .lista-categorias.mostrar {
            display: block;
        }

        /* BUSCADOR Y PREDICCIONES */

        .zona-buscador {
            position: relative;
            display: flex;
            flex: 1;
            max-width: 470px;
            min-width: 210px;
        }

        .buscador-form {
            display: flex;
            width: 100%;
            height: 44px;
        }

        .buscador-form input {
            width: 100%;
            min-width: 0;
            border: 1px solid #d2d8e0;
            border-right: none;
            padding: 0 15px;
            border-radius: 7px 0 0 7px;
            outline: none;
            font-size: 14px;
        }

        .buscador-form input:focus {
            border-color: #16477f;
        }

        .buscador-form button {
            border: none;
            background: #16477f;
            color: white;
            padding: 0 18px;
            border-radius: 0 7px 7px 0;
            cursor: pointer;
            font-weight: bold;
        }

        .buscador-form button:hover {
            background: #12365f;
        }

        .sugerencias {
            display: none;
            position: absolute;
            top: 51px;
            left: 0;
            width: 100%;
            background: white;
            border: 1px solid #dce3eb;
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.13);
            z-index: 50;
            overflow: hidden;
            max-height: 300px;
            overflow-y: auto;
        }

        .sugerencias.mostrar {
            display: block;
        }

        .titulo-sugerencias {
            padding: 11px 14px;
            color: #8290a0;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            border-bottom: 1px solid #edf0f3;
        }

        .sugerencia {
            display: flex;
            align-items: center;
            gap: 11px;
            width: 100%;
            padding: 12px 14px;
            border: none;
            border-bottom: 1px solid #f0f2f5;
            background: white;
            color: #333;
            text-align: left;
            font-size: 14px;
            cursor: pointer;
        }

        .sugerencia:last-child {
            border-bottom: none;
        }

        .sugerencia:hover {
            background: #edf3fa;
            color: #16477f;
        }

        .icono-sugerencia {
            color: #8295aa;
            font-size: 16px;
        }

        .sin-sugerencias {
            padding: 14px;
            color: #777;
            font-size: 13px;
        }

        /* OPCIONES DEL USUARIO */

        .opciones-usuario {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 19px;
            flex-wrap: wrap;
        }

        .opcion {
            display: flex;
            flex-direction: column;
            color: #333;
            font-size: 13px;
            gap: 4px;
            transition: color 0.2s;
        }

        .opcion strong {
            color: #16477f;
            font-size: 14px;
        }

        .opcion:hover,
        .opcion:hover strong {
            color: #2874b9;
        }

        /* NAVEGACIÓN */

        .barra-navegacion {
            background: #123f73;
            padding: 13px 6%;
        }

        .barra-navegacion nav {
            display: flex;
            gap: 35px;
            align-items: center;
            flex-wrap: wrap;
        }

        .barra-navegacion a {
            color: white;
            font-size: 14px;
            font-weight: bold;
        }

        .barra-navegacion a:hover {
            color: #c9e1ff;
        }

        /* CONTENIDO */

        .contenedor {
            width: 90%;
            max-width: 1250px;
            margin: 35px auto 55px;
        }

        .encabezado-tienda {
            margin-bottom: 25px;
        }

        .encabezado-tienda h1 {
            color: #123f73;
            font-size: 27px;
            margin-bottom: 9px;
        }

        .encabezado-tienda p {
            color: #666;
            font-size: 15px;
        }

        .ruta-categoria {
            margin-bottom: 13px;
            color: #777;
            font-size: 13px;
        }

        .ruta-categoria a {
            color: #16477f;
        }

        .mensaje {
            background: #e5f3e9;
            color: #216338;
            padding: 14px 17px;
            border-radius: 7px;
            margin-bottom: 22px;
            border: 1px solid #c8e6d0;
        }

        .informacion-productos {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 10px;
            flex-wrap: wrap;
        }

        .informacion-productos h2 {
            color: #16477f;
            font-size: 20px;
        }

        .informacion-productos span {
            color: #777;
            font-size: 14px;
        }

        /* PRODUCTOS */

        .productos {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
            gap: 23px;
        }

        .producto {
            background: white;
            border-radius: 11px;
            overflow: hidden;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
            border: 1px solid #edf0f3;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }

        .producto:hover {
            transform: translateY(-4px);
            box-shadow: 0 7px 18px rgba(0,0,0,0.11);
        }

        .imagen-producto {
            height: 205px;
            width: 100%;
            background: #f0f3f7;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .imagen-producto img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.3s;
        }

        .imagen-producto:hover img {
            transform: scale(1.04);
        }

        .sin-imagen {
            display: none;
            width: 100%;
            height: 100%;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #8794a3;
            gap: 9px;
            font-size: 13px;
        }

        .sin-imagen span {
            font-size: 36px;
        }

        .datos-producto {
            padding: 17px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .categoria-producto {
            color: #66809d;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .producto h3 {
            color: #16477f;
            font-size: 17px;
            margin-bottom: 9px;
            min-height: 20px;
        }

        .descripcion {
            color: #666;
            font-size: 13px;
            line-height: 1.5;
            min-height: 39px;
            margin-bottom: 12px;
        }

        .precio {
            color: #222;
            font-size: 21px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .stock {
            color: #777;
            font-size: 12px;
            margin-bottom: 13px;
        }

        .formulario-carrito {
            margin-top: auto;
        }

        .etiqueta-cantidad {
            display: block;
            font-size: 13px;
            color: #555;
            margin-bottom: 7px;
        }

        .control-cantidad {
            display: flex;
            align-items: center;
            width: 125px;
            height: 36px;
            border: 1px solid #d6dce3;
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 13px;
        }

        .control-cantidad button {
            width: 36px;
            height: 100%;
            border: none;
            background: #edf2f7;
            color: #16477f;
            font-size: 19px;
            cursor: pointer;
        }

        .control-cantidad button:hover {
            background: #dce8f5;
        }

        .control-cantidad input {
            width: 51px;
            height: 100%;
            text-align: center;
            border: none;
            outline: none;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            appearance: textfield;
            -moz-appearance: textfield;
        }

        .control-cantidad input::-webkit-inner-spin-button,
        .control-cantidad input::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .agregar {
            width: 100%;
            padding: 11px;
            border: none;
            border-radius: 6px;
            background: #16477f;
            color: white;
            font-weight: bold;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .agregar:hover {
            background: #12365f;
        }

        .agregar:disabled {
            background: #999;
            cursor: not-allowed;
        }

        .sin-productos {
            background: white;
            padding: 45px 20px;
            border-radius: 10px;
            text-align: center;
            grid-column: 1 / -1;
            color: #666;
        }

        .sin-productos h3 {
            color: #16477f;
            margin-bottom: 10px;
        }

        .sin-productos a {
            display: inline-block;
            margin-top: 17px;
            color: #16477f;
            font-weight: bold;
        }

        /* VISTA AMPLIADA */

        .modal-imagen {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.78);
            z-index: 100;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-imagen.mostrar {
            display: flex;
        }

        .contenido-modal {
            position: relative;
            background: white;
            border-radius: 10px;
            padding: 15px;
            max-width: 650px;
            width: 100%;
            max-height: 90vh;
        }

        .contenido-modal img {
            display: block;
            width: 100%;
            max-height: 75vh;
            object-fit: contain;
        }

        .cerrar-modal {
            position: absolute;
            top: -13px;
            right: -13px;
            width: 35px;
            height: 35px;
            border: none;
            border-radius: 50%;
            background: white;
            color: #16477f;
            font-size: 23px;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        /* PIE DE PÁGINA */

        footer {
            background: #123f73;
            color: white;
            padding: 28px 6%;
            text-align: center;
            font-size: 13px;
            line-height: 1.8;
        }

        footer strong {
            font-size: 16px;
        }

        /* RESPONSIVE */

        @media (max-width: 900px) {
            .encabezado {
                justify-content: center;
            }

            .zona-buscador {
                order: 3;
                max-width: 100%;
                flex-basis: 100%;
            }

            .opciones-usuario {
                flex: 1;
            }
        }

        @media (max-width: 600px) {
            .encabezado {
                padding: 15px 5%;
            }

            .opciones-usuario {
                width: 100%;
                justify-content: space-between;
                gap: 12px;
            }

            .barra-navegacion nav {
                gap: 18px;
            }

            .contenedor {
                width: 92%;
            }

            .productos {
                grid-template-columns: repeat(auto-fill, minmax(155px, 1fr));
                gap: 13px;
            }

            .imagen-producto {
                height: 155px;
            }

            .datos-producto {
                padding: 12px;
            }

            .producto h3 {
                font-size: 15px;
            }

            .descripcion {
                font-size: 12px;
            }
        }
    </style>
</head>

<body>

<header class="encabezado">

    <a href="<%=rutaPrincipal%>" class="logo">
        <img src="<%=imagenes%>logo.png" alt="UNFV Supermarket">
    </a>

    <div class="zona-categorias">

        <button type="button" class="btn-categorias" onclick="mostrarCategorias()">
            ☰ Categorías
        </button>

        <div class="lista-categorias" id="listaCategorias">

            <a href="<%=rutaTienda%>">Todos los productos</a>
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

    <!-- BUSCADOR CON PREDICCIONES -->

    <div class="zona-buscador">

        <form class="buscador-form" id="formBuscador"
              action="<%=rutaTienda%>" method="GET">

            <% if (categoriaSeleccionada > 0) { %>
                <input type="hidden" name="categoria"
                       value="<%=categoriaSeleccionada%>">
            <% } %>

            <input
                type="text"
                id="buscadorInput"
                name="buscar"
                placeholder="¿Qué estás buscando?"
                value="<%=escaparHTML(buscarParam)%>"
                autocomplete="off"
            >

            <button type="submit">Buscar</button>

        </form>

        <div class="sugerencias" id="sugerencias">
            <div class="titulo-sugerencias">Productos sugeridos</div>
            <div id="contenidoSugerencias"></div>
        </div>

    </div>

    <!-- LISTA OCULTA CON LOS NOMBRES DE TODOS LOS PRODUCTOS -->

    <div id="fuenteSugerencias" hidden>
        <% if (listaProductos != null) {
            for (Producto productoSugerencia : listaProductos) {
                if (productoSugerencia.nombre != null) {
        %>
            <span data-categoria="<%=productoSugerencia.id_categoria%>"><%=escaparHTML(productoSugerencia.nombre)%></span>
        <%
                }
            }
        } %>
    </div>

    <!-- OPCIONES SEGÚN LA SESIÓN -->

    <div class="opciones-usuario">

        <% if (sesionIniciada) { %>

            <a href="<%=rutaCuenta%>" class="opcion">
                Mi cuenta
                <strong><%=usuario.nombre%></strong>
            </a>

            <a href="<%=rutaMisCompras%>" class="opcion">
                Mis compras
                <strong>Historial de pedidos</strong>
            </a>

            <a href="<%=rutaCarrito%>" class="opcion">
                Mi carrito
                <strong>Ver carrito</strong>
            </a>

            <a href="<%=rutaCerrarSesion%>" class="opcion">
                Cerrar sesión
                <strong>Salir</strong>
            </a>

        <% } else { %>

            <a href="<%=rutaLogin%>" class="opcion">
                Bienvenido
                <strong>Iniciar sesión</strong>
            </a>

            <a href="<%=rutaRegistro%>" class="opcion">
                ¿Eres nuevo?
                <strong>Crear cuenta</strong>
            </a>

        <% } %>

    </div>

</header>

<div class="barra-navegacion">
    <nav>
        <a href="<%=rutaPrincipal%>">Inicio</a>
        <a href="<%=rutaTienda%>">Todos los productos</a>
        <a href="<%=rutaPrincipal%>#categorias">Categorías</a>
        <a href="<%=rutaPrincipal%>#contacto">Contacto</a>
    </nav>
</div>

<main class="contenedor">

    <div class="ruta-categoria">
        <a href="<%=rutaPrincipal%>">Inicio</a> /
        <a href="<%=rutaTienda%>">Tienda</a> /
        <strong><%=nombreCategoria%></strong>
    </div>

    <section class="encabezado-tienda">
        <h1>¡Bienvenido a nuestra tienda!</h1>
        <p>Encuentra lo que necesitas y disfruta de nuestros productos.</p>
    </section>

    <% if (mensaje != null) { %>
        <div class="mensaje">
            <%=mensaje%>
        </div>
    <% } %>

    <div class="informacion-productos">

        <h2>
            <%=nombreCategoria%>
            <% if (buscarParam != null && !buscarParam.trim().isEmpty()) { %>
                - Resultados de búsqueda
            <% } %>
        </h2>

        <span><%=totalProductos%> producto(s) encontrado(s)</span>

    </div>

    <section class="productos" id="listaProductos">

        <%
            boolean encontroProducto = false;

            if (listaProductos != null && !listaProductos.isEmpty()) {

                for (Producto p : listaProductos) {

                    if (categoriaSeleccionada > 0 && p.id_categoria != categoriaSeleccionada) {
                        continue;
                    }

                    if (buscarParam != null && !buscarParam.trim().isEmpty()
                            && (p.nombre == null
                            || !normalizarTexto(p.nombre).contains(busquedaNormalizada))) {
                        continue;
                    }

                    encontroProducto = true;

                    // OBTENER LA RUTA CORRECTA DE LA IMAGEN
                    String nombreImagen = p.imagen != null ? p.imagen.trim() : "";
                    String rutaImagen = "";

                    if (!nombreImagen.isEmpty()) {

                        nombreImagen = nombreImagen.replace("\\", "/");

                        while (nombreImagen.startsWith("/")) {
                            nombreImagen = nombreImagen.substring(1);
                        }

                        if (nombreImagen.startsWith("Imagenes/")) {

                            rutaImagen = request.getContextPath() + "/" + nombreImagen;

                        } else if (nombreImagen.startsWith("ImagenesProductos/")) {

                            rutaImagen = request.getContextPath() + "/Imagenes/" + nombreImagen;

                        } else {

                            rutaImagen = request.getContextPath()
                                    + "/Imagenes/ImagenesProductos/" + nombreImagen;
                        }
                    }

                    String categoriaProducto = p.nombre_categoria != null
                            ? p.nombre_categoria : "Producto";
        %>

        <article class="producto">

            <div class="imagen-producto"
                 onclick="ampliarImagen(this.querySelector('img'))">

                <% if (!nombreImagen.isEmpty()) { %>

                    <img
                        src="<%=rutaImagen%>"
                        alt="<%=escaparHTML(p.nombre)%>"
                        onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                    >

                    <div class="sin-imagen">
                        <span>▧</span>
                        Imagen no disponible
                    </div>

                <% } else { %>

                    <div class="sin-imagen" style="display:flex;">
                        <span>▧</span>
                        Imagen no disponible
                    </div>

                <% } %>

            </div>

            <div class="datos-producto">

                <p class="categoria-producto">
                    <%=categoriaProducto%>
                </p>

                <h3><%=p.nombre%></h3>

                <p class="descripcion">
                    <%=p.descripcion != null ? p.descripcion : "Sin descripción disponible."%>
                </p>

                <p class="precio">
                    S/ <%=String.format(Locale.US, "%.2f", p.precio)%>
                </p>

                <p class="stock">
                    Stock disponible: <%=p.stock%>
                </p>

                <form class="formulario-carrito"
                      action="<%=request.getContextPath()%>/CarritoControlador"
                      method="POST">

                    <input type="hidden" name="op" value="1">

                    <input type="hidden"
                           name="txtidproducto"
                           value="<%=p.id_producto%>">

                    <% if (categoriaSeleccionada > 0) { %>
                        <input type="hidden"
                               name="categoria"
                               value="<%=categoriaSeleccionada%>">
                    <% } %>

                    <% if (buscarParam != null && !buscarParam.trim().isEmpty()) { %>
                        <input type="hidden"
                               name="buscar"
                               value="<%=escaparHTML(buscarParam)%>">
                    <% } %>

                    <label class="etiqueta-cantidad"
                           for="cantidad_<%=p.id_producto%>">
                        Cantidad:
                    </label>

                    <div class="control-cantidad">

                        <button type="button"
                                onclick="cambiarCantidad(this, -1)"
                                <%=p.stock <= 0 ? "disabled" : ""%>>
                            −
                        </button>

                        <input
                            type="number"
                            id="cantidad_<%=p.id_producto%>"
                            name="cantidad"
                            value="1"
                            min="1"
                            max="<%=p.stock%>"
                            required
                            <%=p.stock <= 0 ? "disabled" : ""%>
                        >

                        <button type="button"
                                onclick="cambiarCantidad(this, 1)"
                                <%=p.stock <= 0 ? "disabled" : ""%>>
                            +
                        </button>

                    </div>

                    <button type="submit"
                            class="agregar"
                            <%=p.stock <= 0 ? "disabled" : ""%>>
                        <%=p.stock <= 0 ? "Agotado" : "Agregar al carrito"%>
                    </button>

                </form>

            </div>

        </article>

        <%
                }
            }
        %>

        <% if (!encontroProducto) { %>

            <div class="sin-productos">

                <h3>No encontramos productos.</h3>

                <p>
                    <% if (buscarParam != null && !buscarParam.trim().isEmpty()) { %>
                        No hay resultados para tu búsqueda.
                    <% } else { %>
                        Todavía no hay productos registrados en esta categoría.
                    <% } %>
                </p>

                <a href="<%=rutaTienda%>">Ver todos los productos</a>

            </div>

        <% } %>

    </section>

</main>

<!-- MODAL DE IMAGEN -->

<div class="modal-imagen" id="modalImagen" onclick="cerrarImagen(event)">

    <div class="contenido-modal">

        <button type="button"
                class="cerrar-modal"
                onclick="cerrarImagen()">
            ×
        </button>

        <img src="" id="imagenAmpliada" alt="Imagen del producto">

    </div>

</div>

<footer>
    <strong>UNFV SUPERMARKET</strong>
    <p>Tu tienda de confianza, siempre cerca de ti.</p>
    <p>Atención: lunes a sábado | Teléfono: 900 000 000</p>
    <p>Correo: admin@gmail.com</p>
    <p>© 2026 UNFV Supermarket. Todos los derechos reservados.</p>
</footer>

<script>

    // Normaliza el texto para comparar sin tildes ni diferencias de mayúsculas
    function normalizarTexto(texto) {
        return texto
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .toLowerCase()
            .trim();
    }

    // BUSCADOR CON PREDICCIONES

    const buscadorInput = document.getElementById("buscadorInput");
    const sugerencias = document.getElementById("sugerencias");
    const contenidoSugerencias = document.getElementById("contenidoSugerencias");
    const fuenteSugerencias = document.getElementById("fuenteSugerencias");
    const formBuscador = document.getElementById("formBuscador");

    const categoriaActual = <%=categoriaSeleccionada%>;

    // Obtenemos los nombres de los productos registrados
    const productosParaSugerir = [];

    if (fuenteSugerencias) {

        const elementos = fuenteSugerencias.querySelectorAll("span");
        const nombresRegistrados = new Set();

        elementos.forEach(function(elemento) {

            const nombre = elemento.textContent.trim();
            const categoria = parseInt(elemento.dataset.categoria);

            const clave = normalizarTexto(nombre);

            if (nombre !== "" && !nombresRegistrados.has(clave)) {

                nombresRegistrados.add(clave);

                productosParaSugerir.push({
                    nombre: nombre,
                    categoria: categoria,
                    normalizado: clave
                });
            }
        });
    }

    function mostrarSugerencias() {

        const texto = normalizarTexto(buscadorInput.value);

        contenidoSugerencias.innerHTML = "";

        if (texto.length === 0) {
            sugerencias.classList.remove("mostrar");
            return;
        }

        let resultados = productosParaSugerir.filter(function(producto) {

            const coincideTexto = producto.normalizado.includes(texto);

            const coincideCategoria =
                categoriaActual === 0 ||
                producto.categoria === categoriaActual;

            return coincideTexto && coincideCategoria;
        });

        resultados = resultados.slice(0, 7);

        if (resultados.length === 0) {

            const mensaje = document.createElement("div");
            mensaje.className = "sin-sugerencias";
            mensaje.textContent = "No se encontraron productos similares.";

            contenidoSugerencias.appendChild(mensaje);

            sugerencias.classList.add("mostrar");
            return;
        }

        resultados.forEach(function(producto) {

            const boton = document.createElement("button");

            boton.type = "button";
            boton.className = "sugerencia";

            const icono = document.createElement("span");
            icono.className = "icono-sugerencia";
            icono.textContent = "⌕";

            const nombre = document.createElement("span");
            nombre.textContent = producto.nombre;

            boton.appendChild(icono);
            boton.appendChild(nombre);

            boton.addEventListener("click", function() {

                buscadorInput.value = producto.nombre;

                sugerencias.classList.remove("mostrar");

                formBuscador.submit();
            });

            contenidoSugerencias.appendChild(boton);
        });

        sugerencias.classList.add("mostrar");
    }

    buscadorInput.addEventListener("input", mostrarSugerencias);

    buscadorInput.addEventListener("focus", mostrarSugerencias);

    buscadorInput.addEventListener("keydown", function(event) {

        if (event.key === "Escape") {
            sugerencias.classList.remove("mostrar");
        }
    });

    document.addEventListener("click", function(event) {

        if (!event.target.closest(".zona-buscador")) {
            sugerencias.classList.remove("mostrar");
        }
    });

    formBuscador.addEventListener("submit", function() {
        sugerencias.classList.remove("mostrar");
    });

    // MENÚ DE CATEGORÍAS

    function mostrarCategorias() {
        document.getElementById("listaCategorias").classList.toggle("mostrar");
    }

    document.addEventListener("click", function(event) {

        let menu = document.getElementById("listaCategorias");
        let boton = document.querySelector(".btn-categorias");

        if (!menu.contains(event.target) && !boton.contains(event.target)) {
            menu.classList.remove("mostrar");
        }
    });

    // CONTROL DE CANTIDAD

    function cambiarCantidad(boton, cambio) {

        let control = boton.parentElement;
        let input = control.querySelector("input");

        let actual = parseInt(input.value) || 1;
        let minimo = parseInt(input.min) || 1;
        let maximo = parseInt(input.max);

        let nuevaCantidad = actual + cambio;

        if (nuevaCantidad >= minimo && nuevaCantidad <= maximo) {
            input.value = nuevaCantidad;
        }
    }

    // AMPLIAR IMAGEN

    function ampliarImagen(imagen) {

        if (!imagen || imagen.style.display === "none" || !imagen.src) {
            return;
        }

        let modal = document.getElementById("modalImagen");
        let imagenAmpliada = document.getElementById("imagenAmpliada");

        imagenAmpliada.src = imagen.src;
        modal.classList.add("mostrar");
    }

    function cerrarImagen(event) {

        if (!event || event.target.id === "modalImagen" ||
            event.target.classList.contains("cerrar-modal")) {

            document.getElementById("modalImagen").classList.remove("mostrar");
        }
    }

    document.addEventListener("keydown", function(event) {

        if (event.key === "Escape") {
            document.getElementById("modalImagen").classList.remove("mostrar");
        }
    });

</script>

</body>
</html>
