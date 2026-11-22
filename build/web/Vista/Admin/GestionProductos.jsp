
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.Categoria"%>
<%@page import="Modelo.Administrador"%>

<%!
    // OBTENER LA RUTA DE UNA IMAGEN
    // Acepta imágenes de Cloudinary y las antiguas imágenes locales.

    private String obtenerRutaImagen(String imagen, String contexto) {

        if (imagen == null || imagen.trim().isEmpty()) {
            return "";
        }

        imagen = imagen.trim().replace("\\", "/");

        // IMÁGENES DE CLOUDINARY
        if (imagen.startsWith("https://") || imagen.startsWith("http://")) {
            return imagen;
        }

        // QUITAR BARRAS INICIALES
        while (imagen.startsWith("/")) {
            imagen = imagen.substring(1);
        }

        // IMÁGENES LOCALES ANTIGUAS
        if (imagen.startsWith("Imagenes/")) {
            return contexto + "/" + imagen;
        }

        if (imagen.startsWith("ImagenesProductos/")) {
            return contexto + "/Imagenes/" + imagen;
        }

        return contexto + "/Imagenes/ImagenesProductos/" + imagen;
    }
%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    ArrayList<Producto> lista =
        (ArrayList<Producto>) request.getAttribute("lista");

    ArrayList<Categoria> categorias =
        (ArrayList<Categoria>) request.getAttribute("categorias");

    if (categorias == null) {
        categorias = new ArrayList<Categoria>();
    }

    Administrador admin =
        (Administrador) session.getAttribute("administrador");

    String ruta = request.getContextPath();

    String tipoMensaje = (String) request.getAttribute("tipoMensaje");
    String mensaje = (String) request.getAttribute("mensaje");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de productos</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        html, body {
            min-height: 100%;
        }

        body {
            background: #f4f6fa;
            color: #263238;
            min-height: 100vh;
        }

        .contenedor {
            display: flex;
            min-height: 100vh;
        }

        /* MENU LATERAL */

        .sidebar {
            width: 250px;
            height: 100vh;
            background: #202c40;
            color: white;
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            overflow-y: auto;
            flex-shrink: 0;
        }

        .logo {
            margin-bottom: 45px;
            text-align: center;
        }

        .logo img {
            width: 155px;
            max-height: 100px;
            object-fit: contain;
        }

        .menu-titulo {
            color: #9daabd;
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 15px;
            padding-left: 12px;
            letter-spacing: 1px;
        }

        .menu a,
        .menu button {
            display: block;
            width: 100%;
            padding: 14px 13px;
            color: #dce3ed;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 8px;
            font-size: 14px;
            transition: 0.3s;
            background: transparent;
            border: none;
            text-align: left;
            cursor: pointer;
        }

        .menu a:hover,
        .menu a.activo,
        .menu button:hover,
        .menu button.activo {
            background: #344761;
            color: white;
        }

        .menu form {
            width: 100%;
            margin: 0;
            padding: 0;
        }

        .cerrar {
            margin-top: 15px;
            padding-top: 0;
        }

        .cerrar form {
            width: 100%;
        }

        .cerrar button {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 8px;
            background: #e84b35;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .cerrar button:hover {
            background: #c93629;
        }

        /* CONTENIDO PRINCIPAL */

        .contenido {
            flex: 1;
            min-width: 0;
            margin-left: 250px;
            padding: 35px 40px;
        }

        .encabezado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
        }

        .encabezado h1 {
            font-size: 27px;
            color: #202c40;
        }

        .encabezado p {
            color: #8993a2;
            font-size: 14px;
            margin-top: 7px;
        }

        .perfil {
            background: white;
            padding: 12px 18px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.04);
            font-size: 14px;
        }

        /* MENSAJES */

        .mensaje {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .mensaje.error {
            background: #fff0ed;
            color: #d94732;
            border: 1px solid #ffd1c9;
        }

        .mensaje.exito {
            background: #eaf8ef;
            color: #247a43;
            border: 1px solid #bce6ca;
        }

        /* ADVERTENCIA DE IMAGEN */

        .advertencia-imagen {
            display: none;
            background: #fff0ed;
            color: #c93629;
            border: 1px solid #ffc9bf;
            border-radius: 8px;
            padding: 11px;
            margin-top: 12px;
            font-size: 12px;
            line-height: 1.5;
            text-align: left;
        }

        .advertencia-imagen.visible {
            display: block;
        }

        /* PANELES */

        .panel {
            background: white;
            padding: 27px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
            border: 1px solid #edf0f4;
            margin-bottom: 25px;
        }

        .panel h2 {
            color: #26364c;
            font-size: 19px;
            margin-bottom: 22px;
        }

        /* FORMULARIO */

        .formulario {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 17px;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .campo label {
            font-size: 13px;
            font-weight: bold;
            color: #526174;
        }

        .campo input,
        .campo textarea,
        .campo select {
            padding: 12px;
            border: 1px solid #dce1e8;
            border-radius: 7px;
            outline: none;
            font-size: 13px;
            width: 100%;
            background: white;
        }

        .campo input:focus,
        .campo textarea:focus,
        .campo select:focus {
            border-color: #e84b35;
        }

        .campo textarea {
            resize: vertical;
            min-height: 80px;
        }

        .completo {
            grid-column: 1 / -1;
        }

        /* IMAGEN */

        .zona-imagen {
            border: 2px dashed #b9c4d2;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            background: #f8f9fc;
            transition: 0.2s;
            cursor: pointer;
        }

        .zona-imagen:hover,
        .zona-imagen.arrastrando {
            border-color: #e84b35;
            background: #fff5f2;
        }

        .zona-imagen p {
            color: #526174;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .zona-imagen small {
            color: #8993a2;
            font-size: 11px;
            display: block;
            margin-top: 8px;
        }

        .zona-imagen input[type="file"] {
            display: block;
            width: 100%;
            margin-top: 12px;
            font-size: 12px;
            cursor: pointer;
        }

        .vista-previa {
            max-width: 170px;
            max-height: 140px;
            object-fit: contain;
            border-radius: 8px;
            margin: 12px auto 0;
            display: none;
        }

        .nombre-archivo {
            color: #526174;
            font-size: 12px;
            margin-top: 8px;
            word-break: break-all;
        }

        /* BOTONES */

        .btn {
            border: none;
            padding: 12px 18px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
            font-size: 13px;
            transition: 0.2s;
        }

        .btn-agregar,
        .btn-guardar {
            background: #e84b35;
            color: white;
        }

        .btn-agregar:hover,
        .btn-guardar:hover {
            background: #c93629;
        }

        .btn-listar,
        .btn-modificar {
            background: #202c40;
            color: white;
        }

        .btn-listar:hover,
        .btn-modificar:hover {
            background: #344761;
        }

        .btn-eliminar {
            background: #ffe9e6;
            color: #d94732;
        }

        .btn-eliminar:hover {
            background: #e84b35;
            color: white;
        }

        .btn-cancelar {
            background: #e9edf2;
            color: #526174;
        }

        .btn-cancelar:hover {
            background: #d8dee7;
        }

        /* BUSCADOR */

        .buscador-contenedor {
            margin-bottom: 18px;
        }

        .buscador {
            display: flex;
            align-items: center;
            gap: 12px;
            background: #f8f9fc;
            border: 1px solid #dce1e8;
            border-radius: 9px;
            padding: 0 15px;
            transition: 0.2s;
        }

        .buscador:focus-within {
            border-color: #e84b35;
            box-shadow: 0 0 0 3px rgba(232,75,53,0.08);
            background: white;
        }

        .buscador-icono {
            font-size: 19px;
            color: #8993a2;
        }

        .buscador input {
            flex: 1;
            min-width: 0;
            border: none;
            outline: none;
            background: transparent;
            padding: 15px 0;
            font-size: 14px;
            color: #263238;
        }

        .buscador input::placeholder {
            color: #9aa4b2;
        }

        .btn-limpiar-busqueda {
            border: none;
            background: transparent;
            color: #8993a2;
            font-size: 20px;
            cursor: pointer;
            display: none;
            padding: 5px;
        }

        .btn-limpiar-busqueda:hover {
            color: #e84b35;
        }

        .resultado-busqueda {
            font-size: 12px;
            color: #8993a2;
            margin-top: 9px;
        }

        /* LISTA DE PRODUCTOS */

        .lista-productos {
            display: flex;
            flex-direction: column;
        }

        .producto-card {
            padding: 24px 10px;
            border-bottom: 2px solid #c5cdd7;
        }

        .producto-card:last-child {
            border-bottom: none;
        }

        .producto-vista {
            display: flex;
            gap: 22px;
            align-items: flex-start;
        }

        .producto-imagen {
            width: 145px;
            height: 145px;
            object-fit: contain;
            border-radius: 10px;
            background: #f4f6fa;
            border: 1px solid #dce1e8;
            flex-shrink: 0;
        }

        .producto-sin-imagen {
            width: 145px;
            height: 145px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            background: #f4f6fa;
            border: 1px solid #dce1e8;
            border-radius: 10px;
            color: #8993a2;
            font-size: 12px;
            flex-shrink: 0;
        }

        .producto-info {
            flex: 1;
            min-width: 0;
        }

        .producto-info h3 {
            color: #202c40;
            font-size: 19px;
            margin-bottom: 8px;
        }

        .producto-categoria {
            display: inline-block;
            background: #eef2f7;
            color: #526174;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
            margin-bottom: 12px;
        }

        .producto-descripcion {
            color: #667386;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .producto-precio {
            color: #e84b35;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 6px;
        }

        .producto-stock {
            color: #526174;
            font-size: 13px;
        }

        .producto-id {
            color: #8993a2;
            font-size: 11px;
            margin-bottom: 8px;
        }

        .producto-acciones {
            display: flex;
            gap: 10px;
            margin-top: 18px;
            flex-wrap: wrap;
        }

        /* EDICIÓN */

        .producto-edicion {
            display: none;
            margin-top: 20px;
            padding: 22px;
            background: #f8f9fc;
            border: 1px solid #dce1e8;
            border-radius: 10px;
        }

        .producto-edicion h3 {
            color: #202c40;
            font-size: 17px;
            margin-bottom: 18px;
        }

        .formulario-edicion {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .formulario-edicion .campo input,
        .formulario-edicion .campo textarea,
        .formulario-edicion .campo select {
            padding: 10px;
        }

        .acciones-edicion {
            display: flex;
            gap: 10px;
            margin-top: 18px;
            flex-wrap: wrap;
        }

        .sin-datos {
            text-align: center;
            color: #8993a2;
            padding: 30px;
        }

        /* PIE DE PÁGINA */

        footer {
            margin-left: 250px;
            text-align: center;
            padding: 15px;
            color: #8993a2;
            font-size: 13px;
            background: transparent;
            border: none;
        }

        /* RESPONSIVE */

        @media(max-width: 800px) {

            .contenedor {
                flex-direction: column;
            }

            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                min-height: auto;
                overflow: visible;
            }

            .contenido {
                margin-left: 0;
                padding: 25px 20px;
            }

            .encabezado {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .formulario,
            .formulario-edicion {
                grid-template-columns: 1fr;
            }

            .completo {
                grid-column: auto;
            }

            .producto-vista {
                flex-direction: column;
            }

            .producto-imagen,
            .producto-sin-imagen {
                width: 100%;
                max-width: 220px;
            }

            footer {
                margin-left: 0;
            }
        }

        @media(max-width: 500px) {
            .panel {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<div class="contenedor">

    <!-- MENU LATERAL -->

    <aside class="sidebar">

        <div class="logo">
            <img src="<%=ruta%>/Imagenes/ImagenesVentPrincipal/logo.png"
                 alt="Logo de la tienda">
        </div>

        <div class="menu-titulo">MENÚ PRINCIPAL</div>

        <nav class="menu">

            <a href="<%=ruta%>/Vista/Admin/PanelAdmin.jsp">
                🏠 &nbsp; Inicio
            </a>

            <form action="<%=ruta%>/UsuarioControlador" method="POST">
                <input type="hidden" name="op" value="2">
                <button type="submit">
                    👥 &nbsp; Usuarios
                </button>
            </form>

            <form action="<%=ruta%>/ProductoControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit" class="activo">
                    📦 &nbsp; Productos
                </button>
            </form>

            <form action="<%=ruta%>/CompraControlador" method="POST">
                <input type="hidden" name="op" value="2">
                <button type="submit">
                    🛒 &nbsp; Compras
                </button>
            </form>

            <form action="<%=ruta%>/ProveedorControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">
                    🏭 &nbsp; Proveedores
                </button>
            </form>

            <form action="<%=ruta%>/OrdenCompraControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">
                    📋 &nbsp; Órdenes de compra
                </button>
            </form>

            <a href="<%=ruta%>/AlertaInventarioControlador">
                ⚠️ &nbsp; Alertas de inventario
            </a>

        </nav>

        <!-- CERRAR SESIÓN -->

        <div class="cerrar">

            <form action="<%=ruta%>/CerrarSesionControlador"
                  method="POST">

                <input type="hidden" name="op" value="2">

                <button type="submit">
                    ↪ Cerrar sesión
                </button>

            </form>

        </div>

    </aside>

    <!-- CONTENIDO PRINCIPAL -->

    <main class="contenido">

        <header class="encabezado">

            <div>
                <h1>Gestión de productos</h1>
                <p>Administra el catálogo de productos de tu tienda.</p>
            </div>

            <div class="perfil">
                👤 <%=admin.nombre%> <%=admin.apellido%>
            </div>

        </header>

        <!-- MENSAJE -->

        <% if (mensaje != null) { %>

            <div class="mensaje <%= "exito".equals(tipoMensaje) ? "exito" : "error" %>">
                <%=mensaje%>
            </div>

        <% } %>

        <!-- REGISTRAR PRODUCTO -->

        <section class="panel">

            <h2>➕ Registrar nuevo producto</h2>

            <form action="<%=ruta%>/ProductoControlador"
                  method="POST"
                  enctype="multipart/form-data"
                  class="formulario formulario-producto">

                <input type="hidden" name="op" value="2">

                <div class="campo">
                    <label>Nombre del producto</label>
                    <input type="text" name="txtnombre" required>
                </div>

                <div class="campo">
                    <label>Precio (S/)</label>
                    <input type="number" name="txtprecio"
                           step="0.01" min="0.01" required>
                </div>

                <div class="campo completo">
                    <label>Descripción</label>
                    <textarea name="txtdescripcion"></textarea>
                </div>

                <div class="campo">
                    <label>Stock disponible</label>
                    <input type="number" name="txtstock"
                           min="0" required>
                </div>

                <div class="campo">
                    <label>Categoría</label>

                    <select name="txtcategoria" required>
                        <option value="">Seleccionar categoría</option>

                        <% for (Categoria c : categorias) { %>
                            <option value="<%=c.id_categoria%>">
                                <%=c.nombre%>
                            </option>
                        <% } %>

                    </select>
                </div>

                <div class="campo completo">

                    <label>Imagen del producto</label>

                    <div class="zona-imagen" tabindex="0">

                        <p>📷 Arrastra una imagen aquí</p>
                        <p>O selecciona un archivo de tu ordenador</p>

                        <input type="file"
                               name="archivoImagen"
                               accept=".jpg,.jpeg,.png,.gif,.webp,image/jpeg,image/png,image/gif,image/webp"
                               class="archivo-imagen"
                               required>

                        <small>
                            Formatos admitidos: JPG, JPEG, PNG, GIF y WEBP.
                            Máximo 5 MB.
                        </small>

                        <div class="advertencia-imagen"></div>

                        <img class="vista-previa" alt="Vista previa">

                        <div class="nombre-archivo"></div>

                    </div>

                </div>

                <div class="completo">
                    <button type="submit" class="btn btn-agregar">
                        Registrar producto
                    </button>
                </div>

            </form>

        </section>

        <!-- PRODUCTOS REGISTRADOS -->

        <section class="panel">

            <h2>📦 Productos registrados</h2>

            <!-- BUSCADOR -->

            <div class="buscador-contenedor">

                <div class="buscador">

                    <span class="buscador-icono">🔍</span>

                    <input type="text"
                           id="buscarProducto"
                           placeholder="Buscar por nombre, categoría, descripción o ID..."
                           autocomplete="off">

                    <button type="button"
                            id="limpiarBusqueda"
                            class="btn-limpiar-busqueda"
                            title="Limpiar búsqueda">
                        ✕
                    </button>

                </div>

                <p class="resultado-busqueda" id="resultadoBusqueda">
                    Mostrando todos los productos.
                </p>

            </div>

            <form action="<%=ruta%>/ProductoControlador"
                  method="POST"
                  style="margin-bottom:20px;">

                <input type="hidden" name="op" value="1">

                <button type="submit" class="btn btn-listar">
                    Actualizar lista
                </button>

            </form>

            <div class="lista-productos" id="listaProductos">

                <% if (lista != null && !lista.isEmpty()) { %>

                    <% for (Producto p : lista) { %>

                        <article class="producto-card"
                                 data-busqueda="<%=(
                                     (p.nombre != null ? p.nombre : "") + " " +
                                     (p.nombre_categoria != null ? p.nombre_categoria : "") + " " +
                                     (p.descripcion != null ? p.descripcion : "") + " " +
                                     p.id_producto
                                 ).replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;")%>">

                            <!-- VISTA NORMAL DEL PRODUCTO -->

                            <div class="producto-vista"
                                 id="vista<%=p.id_producto%>">

                                <% if (p.imagen != null && !p.imagen.trim().isEmpty()) { %>

                                    <img class="producto-imagen"
                                         src="<%=obtenerRutaImagen(p.imagen, ruta)%>"
                                         alt="Imagen de <%=p.nombre%>">

                                <% } else { %>

                                    <div class="producto-sin-imagen">
                                        Sin imagen disponible
                                    </div>

                                <% } %>

                                <div class="producto-info">

                                    <div class="producto-id">
                                        PRODUCTO N.º <%=p.id_producto%>
                                    </div>

                                    <h3><%=p.nombre%></h3>

                                    <span class="producto-categoria">
                                        <%=p.nombre_categoria != null
                                            ? p.nombre_categoria
                                            : "Sin categoría"%>
                                    </span>

                                    <p class="producto-descripcion">
                                        <%=p.descripcion != null
                                            ? p.descripcion
                                            : "Sin descripción"%>
                                    </p>

                                    <div class="producto-precio">
                                        S/ <%=String.format("%.2f", p.precio)%>
                                    </div>

                                    <div class="producto-stock">
                                        Stock disponible: <strong><%=p.stock%></strong>
                                    </div>

                                    <div class="producto-acciones">

                                        <button type="button"
                                                class="btn btn-modificar"
                                                onclick="mostrarEdicion(<%=p.id_producto%>)">
                                            ✎ Modificar
                                        </button>

                                        <form action="<%=ruta%>/ProductoControlador"
                                              method="POST"
                                              onsubmit="return confirm('¿Estás seguro de eliminar este producto?');">

                                            <input type="hidden" name="op" value="4">

                                            <input type="hidden" name="txtid"
                                                   value="<%=p.id_producto%>">

                                            <button type="submit"
                                                    class="btn btn-eliminar">
                                                🗑 Eliminar
                                            </button>

                                        </form>

                                    </div>

                                </div>

                            </div>

                            <!-- FORMULARIO DE EDICIÓN -->

                            <div class="producto-edicion"
                                 id="edicion<%=p.id_producto%>">

                                <h3>✎ Modificar producto</h3>

                                <form action="<%=ruta%>/ProductoControlador"
                                      method="POST"
                                      enctype="multipart/form-data"
                                      class="formulario-edicion formulario-producto">

                                    <input type="hidden" name="op" value="3">

                                    <input type="hidden" name="txtid"
                                           value="<%=p.id_producto%>">

                                    <input type="hidden" name="txtimagen"
                                           value="<%=p.imagen != null ? p.imagen : ""%>">

                                    <div class="campo">
                                        <label>Nombre del producto</label>

                                        <input type="text"
                                               name="txtnombre"
                                               value="<%=p.nombre%>"
                                               required>
                                    </div>

                                    <div class="campo">
                                        <label>Precio (S/)</label>

                                        <input type="number"
                                               name="txtprecio"
                                               value="<%=p.precio%>"
                                               step="0.01"
                                               min="0.01"
                                               required>
                                    </div>

                                    <div class="campo completo">
                                        <label>Descripción</label>

                                        <textarea name="txtdescripcion"><%=p.descripcion != null ? p.descripcion : ""%></textarea>
                                    </div>

                                    <div class="campo">
                                        <label>Stock disponible</label>

                                        <input type="number"
                                               name="txtstock"
                                               value="<%=p.stock%>"
                                               min="0"
                                               required>
                                    </div>

                                    <div class="campo">
                                        <label>Categoría</label>

                                        <select name="txtcategoria" required>

                                            <% for (Categoria c : categorias) { %>

                                                <option value="<%=c.id_categoria%>"
                                                    <%=c.id_categoria == p.id_categoria ? "selected" : ""%>>
                                                    <%=c.nombre%>
                                                </option>

                                            <% } %>

                                        </select>
                                    </div>

                                    <div class="campo completo">

                                        <label>Cambiar imagen del producto</label>

                                        <div class="zona-imagen" tabindex="0">

                                            <p>📷 Arrastra o pega una nueva imagen</p>

                                            <input type="file"
                                                   name="archivoImagen"
                                                   accept=".jpg,.jpeg,.png,.gif,.webp,image/jpeg,image/png,image/gif,image/webp"
                                                   class="archivo-imagen">

                                            <small>
                                                Formatos admitidos: JPG, JPEG, PNG, GIF y WEBP.
                                                Si no eliges otra imagen, se conservará la actual.
                                            </small>

                                            <div class="advertencia-imagen"></div>

                                            <img class="vista-previa"
                                                 src="<%=obtenerRutaImagen(p.imagen, ruta)%>"
                                                 data-original-src="<%=obtenerRutaImagen(p.imagen, ruta)%>"
                                                 alt="Vista previa"
                                                 style="<%=p.imagen != null && !p.imagen.trim().isEmpty() ? "display:block;" : "display:none;"%>">

                                            <div class="nombre-archivo">
                                                Imagen actual
                                            </div>

                                        </div>

                                    </div>

                                    <div class="campo completo">

                                        <div class="acciones-edicion">

                                            <button type="submit"
                                                    class="btn btn-guardar">
                                                Guardar cambios
                                            </button>

                                            <button type="button"
                                                    class="btn btn-cancelar"
                                                    onclick="cancelarEdicion(<%=p.id_producto%>)">
                                                Cancelar
                                            </button>

                                        </div>

                                    </div>

                                </form>

                            </div>

                        </article>

                    <% } %>

                <% } else { %>

                    <div class="sin-datos">
                        No hay productos registrados.
                    </div>

                <% } %>

                <div class="sin-datos" id="sinResultados" style="display:none;">
                    <h3>No se encontraron productos.</h3>
                    <p style="margin-top:8px;">
                        Intenta buscar con otro nombre o palabra.
                    </p>
                </div>

            </div>

        </section>

    </main>

</div>

<footer>
    © 2026 UNFV Supermarket. Todos los derechos reservados.
</footer>

<script>

    // BUSCADOR DE PRODUCTOS

    const buscador = document.getElementById("buscarProducto");
    const botonLimpiar = document.getElementById("limpiarBusqueda");
    const resultadoBusqueda = document.getElementById("resultadoBusqueda");
    const tarjetasProductos = document.querySelectorAll(".producto-card");
    const sinResultados = document.getElementById("sinResultados");

    function normalizarTexto(texto) {

        return texto
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim();

    }

    function filtrarProductos() {

        const texto = normalizarTexto(buscador.value);

        let encontrados = 0;

        tarjetasProductos.forEach(function(tarjeta) {

            const contenido = normalizarTexto(
                tarjeta.getAttribute("data-busqueda") || ""
            );

            const coincide = contenido.includes(texto);

            tarjeta.style.display = coincide ? "block" : "none";

            if (coincide) {
                encontrados++;
            }

        });

        botonLimpiar.style.display = buscador.value.length > 0
            ? "block"
            : "none";

        if (texto === "") {

            resultadoBusqueda.textContent =
                "Mostrando todos los productos (" +
                tarjetasProductos.length + ").";

        } else if (encontrados === 1) {

            resultadoBusqueda.textContent =
                "Se encontró 1 producto.";

        } else {

            resultadoBusqueda.textContent =
                "Se encontraron " + encontrados + " productos.";

        }

        sinResultados.style.display =
            (tarjetasProductos.length > 0 && encontrados === 0)
                ? "block"
                : "none";

    }

    buscador.addEventListener("input", filtrarProductos);

    botonLimpiar.addEventListener("click", function() {

        buscador.value = "";
        filtrarProductos();
        buscador.focus();

    });

    filtrarProductos();


    // FORMATOS PERMITIDOS

    const extensionesPermitidas = [
        ".jpg",
        ".jpeg",
        ".png",
        ".gif",
        ".webp"
    ];

    const tiposPermitidos = [
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/webp"
    ];

    const TAMANO_MAXIMO = 5 * 1024 * 1024;

    function mostrarAdvertencia(zona, mensaje) {

        const advertencia = zona.querySelector(".advertencia-imagen");

        advertencia.textContent = "⚠ " + mensaje;
        advertencia.classList.add("visible");

    }

    function quitarAdvertencia(zona) {

        const advertencia = zona.querySelector(".advertencia-imagen");

        advertencia.textContent = "";
        advertencia.classList.remove("visible");

    }

    function validarImagen(archivo, zona) {

        if (!archivo) {
            return false;
        }

        const nombre = archivo.name.toLowerCase();
        const extension = nombre.substring(nombre.lastIndexOf("."));

        if (!extensionesPermitidas.includes(extension)) {

            mostrarAdvertencia(
                zona,
                "Formato de imagen no admitido. Selecciona JPG, JPEG, PNG, GIF o WEBP."
            );

            return false;
        }

        if (archivo.type && !tiposPermitidos.includes(archivo.type.toLowerCase())) {

            mostrarAdvertencia(
                zona,
                "El tipo de imagen no es compatible. Usa JPG, JPEG, PNG, GIF o WEBP."
            );

            return false;
        }

        if (archivo.size > TAMANO_MAXIMO) {

            mostrarAdvertencia(
                zona,
                "La imagen supera el límite de 5 MB."
            );

            return false;
        }

        quitarAdvertencia(zona);

        return true;
    }


    // FUNCIONES DE EDICIÓN

    function mostrarEdicion(id) {

        const vista = document.getElementById("vista" + id);
        const edicion = document.getElementById("edicion" + id);

        vista.style.display = "none";
        edicion.style.display = "block";

        edicion.scrollIntoView({
            behavior: "smooth",
            block: "center"
        });
    }

    function cancelarEdicion(id) {

        const vista = document.getElementById("vista" + id);
        const edicion = document.getElementById("edicion" + id);

        const formulario = edicion.querySelector("form");

        formulario.reset();

        const preview = formulario.querySelector(".vista-previa");

        // RECUPERAR LA URL ORIGINAL DE LA IMAGEN
        // Funciona tanto con Cloudinary como con imágenes locales.

        const imagenOriginal = preview.getAttribute("data-original-src");

        if (imagenOriginal) {
            preview.src = imagenOriginal;
            preview.style.display = "block";
        } else {
            preview.src = "";
            preview.style.display = "none";
        }

        const nombre = formulario.querySelector(".nombre-archivo");
        nombre.textContent = "Imagen actual";

        const zona = formulario.querySelector(".zona-imagen");
        quitarAdvertencia(zona);

        edicion.style.display = "none";
        vista.style.display = "flex";
    }


    // SELECCIONAR, ARRASTRAR Y PEGAR IMÁGENES

    document.querySelectorAll(".zona-imagen").forEach(function(zona) {

        const input = zona.querySelector(".archivo-imagen");
        const preview = zona.querySelector(".vista-previa");
        const nombre = zona.querySelector(".nombre-archivo");

        function mostrarImagen(archivo) {

            if (!archivo) {
                return;
            }

            if (!validarImagen(archivo, zona)) {

                input.value = "";

                return;
            }

            const url = URL.createObjectURL(archivo);

            preview.src = url;
            preview.style.display = "block";

            nombre.textContent = archivo.name || "Imagen pegada";
        }

        input.addEventListener("change", function() {

            if (input.files.length > 0) {
                mostrarImagen(input.files[0]);
            }

        });

        function asignarArchivo(archivo) {

            if (!archivo) {
                return;
            }

            if (!validarImagen(archivo, zona)) {
                input.value = "";
                return;
            }

            const transferencia = new DataTransfer();

            transferencia.items.add(archivo);

            input.files = transferencia.files;

            mostrarImagen(archivo);
        }

        zona.addEventListener("dragover", function(e) {

            e.preventDefault();
            zona.classList.add("arrastrando");

        });

        zona.addEventListener("dragleave", function() {

            zona.classList.remove("arrastrando");

        });

        zona.addEventListener("drop", function(e) {

            e.preventDefault();

            zona.classList.remove("arrastrando");

            const archivos = e.dataTransfer.files;

            if (archivos.length > 0) {

                asignarArchivo(archivos[0]);

            } else {

                alert("El navegador no entregó la imagen como archivo. Prueba copiándola y pegándola aquí.");

            }

        });

        zona.addEventListener("paste", function(e) {

            const elementos = e.clipboardData.items;

            for (let i = 0; i < elementos.length; i++) {

                if (elementos[i].type.startsWith("image/")) {

                    const archivo = elementos[i].getAsFile();

                    if (archivo) {

                        e.preventDefault();
                        asignarArchivo(archivo);
                        return;

                    }

                }

            }

        });

    });


    // COMPROBAR ANTES DE ENVIAR LOS FORMULARIOS

    document.querySelectorAll(".formulario-producto").forEach(function(formulario) {

        formulario.addEventListener("submit", function(e) {

            const input = formulario.querySelector(".archivo-imagen");
            const zona = input.closest(".zona-imagen");

            if (input.files.length > 0) {

                const archivo = input.files[0];

                if (!validarImagen(archivo, zona)) {

                    e.preventDefault();

                    zona.scrollIntoView({
                        behavior: "smooth",
                        block: "center"
                    });

                    return false;
                }

            }

            if (input.required && input.files.length === 0) {

                e.preventDefault();

                mostrarAdvertencia(
                    zona,
                    "Debes seleccionar una imagen para registrar el producto."
                );

                zona.scrollIntoView({
                    behavior: "smooth",
                    block: "center"
                });

                return false;
            }

        });

    });

</script>

</body>
</html>
