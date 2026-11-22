
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.DetalleCompra"%>
<%@page import="Modelo.Administrador"%>
<%@page import="java.util.ArrayList"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");

    String ruta = request.getContextPath();

    ArrayList<DetalleCompra> lista =
        (ArrayList<DetalleCompra>) request.getAttribute("lista");

    double total = 0;
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles de compra | Supermarket</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f6fa;
            color: #263238;
        }

        .contenedor {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            min-width: 250px;
            background: #202c40;
            color: white;
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
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

        .cerrar {
            margin-top: 15px;
            padding-top: 0;
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

        .columna-principal {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .contenido {
            flex: 1;
            min-width: 0;
            padding: 35px 40px;
        }

        .encabezado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .encabezado h1 {
            color: #202c40;
            font-size: 27px;
        }

        .encabezado p {
            color: #8993a2;
            font-size: 14px;
            margin-top: 8px;
        }

        .perfil {
            background: white;
            padding: 12px 18px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.04);
            font-size: 14px;
            white-space: nowrap;
        }

        .volver {
            display: inline-block;
            margin-bottom: 22px;
            color: #e84b35;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
        }

        .volver:hover {
            text-decoration: underline;
        }

        .panel {
            background: white;
            padding: 25px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,.04);
        }

        .barra {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .barra h2 {
            color: #26364c;
            font-size: 19px;
        }

        .contador {
            background: #fff0ed;
            color: #e84b35;
            padding: 8px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .lista-productos {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .producto-card {
            background: #fff;
            border: 1px solid #e1e5eb;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 22px;
            transition: background 0.2s;
        }

        .producto-card:hover {
            background: #fafbfc;
        }

        .producto-imagen {
            width: 115px;
            height: 115px;
            flex-shrink: 0;
            border-radius: 10px;
            background: #f5f6fa;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }

        .producto-imagen img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .sin-imagen {
            color: #9aa4b2;
            font-size: 12px;
            text-align: center;
            padding: 10px;
        }

        .producto-info {
            flex: 1;
            min-width: 0;
        }

        .producto-info h3 {
            color: #26364c;
            font-size: 17px;
            margin-bottom: 8px;
        }

        .producto-id {
            display: inline-block;
            font-size: 12px;
            color: #778397;
            background: #f0f2f6;
            padding: 5px 9px;
            border-radius: 5px;
            margin-bottom: 13px;
        }

        .datos-producto {
            display: grid;
            grid-template-columns: repeat(3, minmax(100px, 1fr));
            gap: 15px;
        }

        .dato {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .dato small {
            color: #8993a2;
            font-size: 11px;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 0.4px;
        }

        .dato strong {
            color: #344054;
            font-size: 14px;
        }

        .subtotal {
            color: #e84b35 !important;
            font-size: 16px !important;
        }

        .resumen-total {
            margin-top: 25px;
            background: #fff;
            border: 1px solid #e1e5eb;
            border-radius: 10px;
            padding: 23px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .resumen-total span {
            color: #26364c;
            font-size: 16px;
            font-weight: bold;
        }

        .resumen-total strong {
            color: #e84b35;
            font-size: 23px;
        }

        .vacio {
            text-align: center;
            padding: 55px 15px;
            color: #8993a2;
        }

        .vacio-icono {
            font-size: 40px;
            margin-bottom: 15px;
        }

        .vacio h3 {
            color: #26364c;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .vacio p {
            font-size: 13px;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #8993a2;
            font-size: 12px;
            width: 100%;
        }

        @media(max-width: 900px) {
            .contenedor {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                min-width: 0;
                min-height: auto;
            }

            .contenido {
                padding: 25px 20px;
            }

            .encabezado {
                flex-direction: column;
                align-items: flex-start;
            }

            .producto-card {
                align-items: flex-start;
            }
        }

        @media(max-width: 600px) {
            .contenido {
                padding: 20px 15px;
            }

            .producto-card {
                flex-direction: column;
                align-items: stretch;
            }

            .producto-imagen {
                width: 100%;
                height: 180px;
            }

            .datos-producto {
                grid-template-columns: 1fr 1fr;
            }

            .resumen-total {
                gap: 10px;
                flex-direction: column;
                align-items: flex-start;
            }

            .panel {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<div class="contenedor">

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
                <button type="submit">
                    📦 &nbsp; Productos
                </button>
            </form>

            <form action="<%=ruta%>/CompraControlador" method="POST">
                <input type="hidden" name="op" value="2">
                <button type="submit" class="activo">
                    🛒 &nbsp; Compras
                </button>
            </form>

            <form action="<%=ruta%>/ProveedorControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">🏭 &nbsp; Proveedores</button>
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

        <div class="cerrar">
            <form action="<%=ruta%>/CerrarSesionControlador" method="POST">
                <input type="hidden" name="op" value="2">
                <button type="submit">
                    ↪ Cerrar sesión
                </button>
            </form>
        </div>

    </aside>

    <div class="columna-principal">

        <main class="contenido">

            <header class="encabezado">

                <div>
                    <h1>Detalles de compra</h1>
                    <p>Productos y cantidades correspondientes a esta compra.</p>
                </div>

                <div class="perfil">
                    👤 <%=admin.nombre%> <%=admin.apellido%>
                </div>

            </header>

            <a href="<%=ruta%>/CompraControlador?op=2" class="volver">
                ← Volver al historial de compras
            </a>

            <section class="panel">

                <div class="barra">
                    <h2>Productos de la compra</h2>

                    <span class="contador">
                        <%=lista != null ? lista.size() : 0%> productos
                    </span>
                </div>

                <% if (lista != null && !lista.isEmpty()) { %>

                    <section class="lista-productos">

                        <% for (DetalleCompra d : lista) {

                            double subtotal = d.cantidad * d.precio;
                            total += subtotal;

                            String imagenProducto = d.imagen_producto != null
                                    ? d.imagen_producto.trim() : "";

                            String nombreProducto = d.nombre_producto != null
                                    && !d.nombre_producto.trim().isEmpty()
                                    ? d.nombre_producto : "Producto no disponible";

                            String rutaImagen = "";

                            if (!imagenProducto.isEmpty()) {

                                // IMÁGENES DE CLOUDINARY
                                if (imagenProducto.startsWith("https://")
                                        || imagenProducto.startsWith("http://")) {

                                    rutaImagen = imagenProducto;

                                } else {

                                    // IMÁGENES ANTIGUAS GUARDADAS LOCALMENTE
                                    imagenProducto = imagenProducto.replace("\\", "/");

                                    while (imagenProducto.startsWith("/")) {
                                        imagenProducto = imagenProducto.substring(1);
                                    }

                                    if (imagenProducto.startsWith("Imagenes/")) {
                                        rutaImagen = ruta + "/" + imagenProducto;

                                    } else if (imagenProducto.startsWith("ImagenesProductos/")) {
                                        rutaImagen = ruta + "/Imagenes/" + imagenProducto;

                                    } else {
                                        rutaImagen = ruta + "/Imagenes/ImagenesProductos/" + imagenProducto;
                                    }
                                }
                            }
                        %>

                            <article class="producto-card">

                                <div class="producto-imagen">

                                    <% if (!rutaImagen.isEmpty()) { %>

                                        <img src="<%=rutaImagen%>"
                                             alt="<%=nombreProducto%>"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">

                                        <div class="sin-imagen" style="display:none;">
                                            Imagen no disponible
                                        </div>

                                    <% } else { %>

                                        <div class="sin-imagen">
                                            Sin imagen disponible
                                        </div>

                                    <% } %>

                                </div>

                                <div class="producto-info">

                                    <h3><%=nombreProducto%></h3>

                                    <span class="producto-id">
                                        Producto #<%=d.id_producto%>
                                    </span>

                                    <div class="datos-producto">

                                        <div class="dato">
                                            <small>Cantidad</small>
                                            <strong><%=d.cantidad%></strong>
                                        </div>

                                        <div class="dato">
                                            <small>Precio unitario</small>
                                            <strong>
                                                S/ <%=String.format(java.util.Locale.US, "%.2f", d.precio)%>
                                            </strong>
                                        </div>

                                        <div class="dato">
                                            <small>Subtotal</small>
                                            <strong class="subtotal">
                                                S/ <%=String.format(java.util.Locale.US, "%.2f", subtotal)%>
                                            </strong>
                                        </div>

                                    </div>

                                </div>

                            </article>

                        <% } %>

                    </section>

                    <div class="resumen-total">
                        <span>Total de la compra</span>

                        <strong>
                            S/ <%=String.format(java.util.Locale.US, "%.2f", total)%>
                        </strong>
                    </div>

                <% } else { %>

                    <div class="vacio">
                        <div class="vacio-icono">🛒</div>
                        <h3>No hay productos registrados</h3>
                        <p>No se encontraron detalles para esta compra.</p>
                    </div>

                <% } %>

            </section>

        </main>

        <footer>
            © 2026 UNFV Supermarket. Todos los derechos reservados.
        </footer>

    </div>

</div>

</body>
</html>

