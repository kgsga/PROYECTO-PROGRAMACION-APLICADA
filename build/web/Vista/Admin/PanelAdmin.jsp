
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Administrador"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");

    String ruta = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración</title>

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
        .menu button:hover {
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

        /* BIENVENIDA */

        .bienvenida {
            background: linear-gradient(110deg, #e84b35, #f17c62);
            padding: 35px;
            border-radius: 15px;
            color: white;
            margin-bottom: 35px;
        }

        .bienvenida h2 {
            font-size: 25px;
            margin-bottom: 12px;
        }

        .bienvenida p {
            font-size: 14px;
            color: #fff0ed;
            line-height: 1.6;
        }

        /* TARJETAS */

        .titulo-seccion {
            font-size: 19px;
            margin-bottom: 20px;
            color: #26364c;
        }

        .tarjetas {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .tarjeta {
            background: white;
            padding: 27px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
            border: 1px solid #edf0f4;
            transition: 0.3s;
        }

        .tarjeta:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .tarjeta .icono {
            font-size: 32px;
            margin-bottom: 17px;
        }

        .tarjeta h3 {
            font-size: 17px;
            margin-bottom: 10px;
            color: #26364c;
        }

        .tarjeta p {
            color: #8993a2;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .tarjeta button {
            display: inline-block;
            background: #fff0ed;
            color: #e84b35;
            padding: 10px 16px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .tarjeta button:hover {
            background: #e84b35;
            color: white;
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
            }

            .contenido {
                margin-left: 0;
                padding: 25px 20px;
            }

            .tarjetas {
                grid-template-columns: 1fr;
            }

            .encabezado {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            footer {
                margin-left: 0;
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

                <a href="<%=ruta%>/Vista/Admin/PanelAdmin.jsp" class="activo">
                    🏠 &nbsp; Inicio
                </a>

                <form action="<%=ruta%>/UsuarioControlador" method="POST">
                    <input type="hidden" name="op" value="2">
                    <button type="submit">👥 &nbsp; Usuarios</button>
                </form>

                <form action="<%=ruta%>/ProductoControlador" method="POST">
                    <input type="hidden" name="op" value="1">
                    <button type="submit">📦 &nbsp; Productos</button>
                </form>

                <form action="<%=ruta%>/CompraControlador" method="POST">
                    <input type="hidden" name="op" value="2">
                    <button type="submit">🛒 &nbsp; Compras</button>
                </form>

                <form action="<%=ruta%>/ProveedorControlador" method="POST">
                    <input type="hidden" name="op" value="1">
                    <button type="submit">🏭 &nbsp; Proveedores</button>
                </form>

                <form action="<%=ruta%>/OrdenCompraControlador" method="POST">
                    <input type="hidden" name="op" value="1">
                    <button type="submit">📋 &nbsp; Órdenes de compra</button>
                </form>

                <!-- ALERTAS DE INVENTARIO -->
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
                    <h1>Panel de administración</h1>
                    <p>Gestiona y supervisa tu tienda.</p>
                </div>

                <div class="perfil">
                    👤 <%=admin.nombre%> <%=admin.apellido%>
                </div>

            </header>

            <section class="bienvenida">

                <h2>¡Bienvenido, <%=admin.nombre%>!</h2>

                <p>
                    Desde este panel podrás administrar los usuarios,
                    controlar los productos y el inventario, revisar las compras
                    de los clientes, gestionar proveedores, emitir órdenes de compra
                    y consultar las estadísticas de ventas.
                </p>

            </section>

            <h2 class="titulo-seccion">Administración de la tienda</h2>

            <section class="tarjetas">

                <!-- USUARIOS -->

                <div class="tarjeta">

                    <div class="icono">👥</div>

                    <h3>Gestión de usuarios</h3>

                    <p>
                        Consulta los usuarios registrados
                        y administra sus cuentas.
                    </p>

                    <form action="<%=ruta%>/UsuarioControlador" method="POST">
                        <input type="hidden" name="op" value="2">
                        <button type="submit">Ver usuarios →</button>
                    </form>

                </div>

                <!-- PRODUCTOS -->

                <div class="tarjeta">

                    <div class="icono">📦</div>

                    <h3>Gestión de productos</h3>

                    <p>
                        Registra nuevos productos, modifica sus datos
                        y controla el stock disponible.
                    </p>

                    <form action="<%=ruta%>/ProductoControlador" method="POST">
                        <input type="hidden" name="op" value="1">
                        <button type="submit">Ver productos →</button>
                    </form>

                </div>

                <!-- COMPRAS DE CLIENTES -->

                <div class="tarjeta">

                    <div class="icono">🛒</div>

                    <h3>Historial de compras</h3>

                    <p>
                        Revisa las compras realizadas
                        por los clientes y actualiza sus estados.
                    </p>

                    <form action="<%=ruta%>/CompraControlador" method="POST">
                        <input type="hidden" name="op" value="2">
                        <button type="submit">Ver compras →</button>
                    </form>

                </div>

                <!-- PROVEEDORES -->

                <div class="tarjeta">

                    <div class="icono">🏭</div>

                    <h3>Gestión de proveedores</h3>

                    <p>
                        Registra proveedores, consulta sus datos
                        y administra los productos que ofrecen.
                    </p>

                    <form action="<%=ruta%>/ProveedorControlador" method="POST">
                        <input type="hidden" name="op" value="1">
                        <button type="submit">Ver proveedores →</button>
                    </form>

                </div>

                <!-- ÓRDENES DE COMPRA -->

                <div class="tarjeta">

                    <div class="icono">📋</div>

                    <h3>Órdenes de compra</h3>

                    <p>
                        Genera pedidos de productos a tus proveedores,
                        consulta sus detalles y realiza el seguimiento
                        de cada orden.
                    </p>

                    <form action="<%=ruta%>/OrdenCompraControlador" method="POST">
                        <input type="hidden" name="op" value="1">
                        <button type="submit">Ver órdenes →</button>
                    </form>

                </div>

                <!-- ALERTAS DE INVENTARIO -->

                <div class="tarjeta">

                    <div class="icono">⚠️</div>

                    <h3>Alertas de inventario</h3>

                    <p>
                        Consulta los productos con stock bajo,
                        los lotes vencidos y aquellos próximos a vencer.
                    </p>

                    <a href="<%=ruta%>/AlertaInventarioControlador">
                        <button type="button">Ver alertas →</button>
                    </a>

                </div>

            </section>

        </main>

    </div>

    <footer>
        © 2026 UNFV Supermarket. Todos los derechos reservados.
    </footer>

</body>
</html>
