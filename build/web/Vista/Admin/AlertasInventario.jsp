
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Modelo.AlertaInventario"%>
<%@page import="Modelo.Administrador"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath()
                + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");
    String ruta = request.getContextPath();

    ArrayList<AlertaInventario> listaStockBajo =
            (ArrayList<AlertaInventario>) request.getAttribute("listaStockBajo");

    ArrayList<AlertaInventario> listaVencidos =
            (ArrayList<AlertaInventario>) request.getAttribute("listaVencidos");

    ArrayList<AlertaInventario> listaProximosVencer =
            (ArrayList<AlertaInventario>) request.getAttribute("listaProximosVencer");

    if (listaStockBajo == null) listaStockBajo = new ArrayList<>();
    if (listaVencidos == null) listaVencidos = new ArrayList<>();
    if (listaProximosVencer == null) listaProximosVencer = new ArrayList<>();

    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

    int totalAlertas = listaStockBajo.size()
            + listaVencidos.size()
            + listaProximosVencer.size();
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alertas de inventario</title>

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
            z-index: 100;
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

        .menu form,
        .cerrar form {
            width: 100%;
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
            gap: 20px;
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
            white-space: nowrap;
        }

        /* TARJETAS RESUMEN */

        .resumen {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 30px;
        }

        .tarjeta {
            background: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
            border-left: 5px solid #e84b35;
        }

        .tarjeta.vencidos {
            border-left-color: #dc3545;
        }

        .tarjeta.proximos {
            border-left-color: #f0ad4e;
        }

        .tarjeta.stock {
            border-left-color: #e84b35;
        }

        .tarjeta.total {
            border-left-color: #202c40;
        }

        .tarjeta h3 {
            color: #8993a2;
            font-size: 13px;
            margin-bottom: 12px;
            font-weight: normal;
        }

        .tarjeta .numero {
            font-size: 30px;
            font-weight: bold;
            color: #202c40;
        }

        /* SECCIONES Y TABLAS */

        .seccion {
            background: white;
            padding: 25px;
            border: 1px solid #edf0f4;
            border-radius: 13px;
            margin-bottom: 25px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
        }

        .seccion h2 {
            color: #202c40;
            font-size: 19px;
            margin-bottom: 20px;
        }

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 550px;
        }

        th {
            background: #f1f3f7;
            color: #536176;
            text-align: left;
            padding: 14px 12px;
            font-size: 12px;
            border-bottom: 1px solid #dce1e8;
        }

        td {
            padding: 15px 12px;
            border-bottom: 1px solid #dce1e8;
            font-size: 13px;
            color: #536176;
        }

        tbody tr:hover {
            background: #fafbfc;
        }

        .estado {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .estado-vencido {
            background: #fde2e2;
            color: #c82333;
        }

        .estado-proximo {
            background: #fff0d5;
            color: #a66a00;
        }

        .estado-stock {
            background: #fce4df;
            color: #c0392b;
        }

        .sin-datos {
            text-align: center;
            padding: 30px 20px;
            color: #8993a2;
            font-size: 14px;
        }

        /* PIE DE PAGINA */

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

        @media(max-width: 1100px) {
            .resumen {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

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

            footer {
                margin-left: 0;
            }

            .encabezado {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media(max-width: 600px) {

            .resumen {
                grid-template-columns: 1fr;
            }

            .seccion {
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

            <a href="<%=ruta%>/AlertaInventarioControlador" class="activo">
                ⚠️ &nbsp; Alertas de inventario
            </a>

        </nav>

        <!-- CERRAR SESIÓN -->

        <div class="cerrar">

            <form action="<%=ruta%>/CerrarSesionControlador" method="POST">

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
                <h1>Alertas de inventario</h1>
                <p>Supervisa el stock y las fechas de vencimiento de tus productos.</p>
            </div>

            <div class="perfil">
                👤 <%=admin.nombre%> <%=admin.apellido%>
            </div>

        </header>

        <!-- TARJETAS RESUMEN -->

        <div class="resumen">

            <div class="tarjeta total">
                <h3>Total de alertas</h3>
                <div class="numero"><%=totalAlertas%></div>
            </div>

            <div class="tarjeta vencidos">
                <h3>Lotes vencidos</h3>
                <div class="numero"><%=listaVencidos.size()%></div>
            </div>

            <div class="tarjeta proximos">
                <h3>Próximos a vencer</h3>
                <div class="numero"><%=listaProximosVencer.size()%></div>
            </div>

            <div class="tarjeta stock">
                <h3>Productos con stock bajo</h3>
                <div class="numero"><%=listaStockBajo.size()%></div>
            </div>

        </div>

        <!-- LOTES VENCIDOS -->

        <section class="seccion">

            <h2>🔴 Productos vencidos</h2>

            <div class="tabla-contenedor">

                <table>

                    <thead>
                        <tr>
                            <th>PRODUCTO</th>
                            <th>ID DEL LOTE</th>
                            <th>CANTIDAD DISPONIBLE</th>
                            <th>FECHA DE VENCIMIENTO</th>
                            <th>ESTADO</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (listaVencidos.isEmpty()) { %>

                            <tr>
                                <td colspan="5" class="sin-datos">
                                    No hay lotes vencidos.
                                </td>
                            </tr>

                        <% } else {
                            for (AlertaInventario alerta : listaVencidos) {
                        %>

                            <tr>
                                <td><%=alerta.nombre%></td>
                                <td>#<%=alerta.id_lote%></td>
                                <td><%=alerta.cantidad_disponible%></td>
                                <td><%=formatoFecha.format(alerta.fecha_vencimiento)%></td>
                                <td>
                                    <span class="estado estado-vencido">
                                        Vencido
                                    </span>
                                </td>
                            </tr>

                        <%  }
                           } %>

                    </tbody>

                </table>

            </div>

        </section>

        <!-- LOTES PROXIMOS A VENCER -->

        <section class="seccion">

            <h2>🟠 Productos próximos a vencer</h2>

            <div class="tabla-contenedor">

                <table>

                    <thead>
                        <tr>
                            <th>PRODUCTO</th>
                            <th>ID DEL LOTE</th>
                            <th>CANTIDAD DISPONIBLE</th>
                            <th>FECHA DE VENCIMIENTO</th>
                            <th>ESTADO</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (listaProximosVencer.isEmpty()) { %>

                            <tr>
                                <td colspan="5" class="sin-datos">
                                    No hay productos próximos a vencer.
                                </td>
                            </tr>

                        <% } else {
                            for (AlertaInventario alerta : listaProximosVencer) {
                        %>

                            <tr>
                                <td><%=alerta.nombre%></td>
                                <td>#<%=alerta.id_lote%></td>
                                <td><%=alerta.cantidad_disponible%></td>
                                <td><%=formatoFecha.format(alerta.fecha_vencimiento)%></td>
                                <td>
                                    <span class="estado estado-proximo">
                                        Próximo a vencer
                                    </span>
                                </td>
                            </tr>

                        <%  }
                           } %>

                    </tbody>

                </table>

            </div>

        </section>

        <!-- PRODUCTOS CON STOCK BAJO -->

        <section class="seccion">

            <h2>⚠️ Productos con stock bajo</h2>

            <div class="tabla-contenedor">

                <table>

                    <thead>
                        <tr>
                            <th>PRODUCTO</th>
                            <th>STOCK ACTUAL</th>
                            <th>STOCK MÍNIMO</th>
                            <th>ESTADO</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (listaStockBajo.isEmpty()) { %>

                            <tr>
                                <td colspan="4" class="sin-datos">
                                    No hay productos con stock bajo.
                                </td>
                            </tr>

                        <% } else {
                            for (AlertaInventario alerta : listaStockBajo) {
                        %>

                            <tr>
                                <td><%=alerta.nombre%></td>
                                <td><%=alerta.stock%></td>
                                <td><%=alerta.stock_minimo%></td>
                                <td>
                                    <span class="estado estado-stock">
                                        Stock bajo
                                    </span>
                                </td>
                            </tr>

                        <%  }
                           } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

<footer>
    © 2026 UNFV Supermarket. Todos los derechos reservados.
</footer>

</body>
</html>
