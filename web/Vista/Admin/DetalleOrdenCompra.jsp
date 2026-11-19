
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Administrador"%>
<%@page import="Modelo.OrdenCompra"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.BigDecimal"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");

    OrdenCompra orden = (OrdenCompra) request.getAttribute("ordenDetalle");

    String ruta = request.getContextPath();

    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat formatoVencimiento = new SimpleDateFormat("dd/MM/yyyy");

    if (orden == null) {
        response.sendRedirect(ruta + "/OrdenCompraControlador?op=1");
        return;
    }

    String claseEstado = "pendiente";

    if ("Enviada".equals(orden.estado)) {
        claseEstado = "enviada";
    } else if ("Recibida".equals(orden.estado)) {
        claseEstado = "recibida";
    } else if ("Cancelada".equals(orden.estado)) {
        claseEstado = "cancelada";
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Detalle de orden de compra</title>

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

        /* CONTENIDO */

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
            margin-bottom: 30px;
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

        /* ENCABEZADO DE ORDEN */

        .bienvenida {
            background: linear-gradient(110deg, #e84b35, #f17c62);
            padding: 30px;
            border-radius: 15px;
            color: white;
            margin-bottom: 30px;
        }

        .bienvenida h2 {
            font-size: 23px;
            margin-bottom: 10px;
        }

        .bienvenida p {
            font-size: 14px;
            color: #fff0ed;
            line-height: 1.6;
        }

        /* TARJETAS */

        .tarjetas {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-bottom: 30px;
        }

        .tarjeta {
            background: white;
            padding: 23px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
            border: 1px solid #edf0f4;
        }

        .tarjeta .etiqueta {
            font-size: 12px;
            color: #8993a2;
            margin-bottom: 10px;
        }

        .tarjeta .valor {
            font-size: 17px;
            font-weight: bold;
            color: #26364c;
        }

        .estado {
            display: inline-block;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .pendiente {
            background: #fff3d8;
            color: #9a6b12;
        }

        .enviada {
            background: #e5efff;
            color: #315f9e;
        }

        .recibida {
            background: #e2f5e9;
            color: #287548;
        }

        .cancelada {
            background: #ffe8e6;
            color: #b83a32;
        }

        /* SECCIÓN */

        .seccion {
            background: white;
            padding: 28px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
            border: 1px solid #edf0f4;
            margin-bottom: 25px;
        }

        .titulo-seccion {
            font-size: 19px;
            margin-bottom: 20px;
            color: #26364c;
        }

        /* TABLA */

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 750px;
        }

        thead {
            background: #f4f6fa;
        }

        th {
            text-align: left;
            padding: 14px 12px;
            color: #647185;
            font-size: 11px;
            letter-spacing: 0.4px;
        }

        td {
            padding: 16px 12px;
            border-bottom: 1px solid #e0e5ec;
            font-size: 13px;
            color: #34445a;
        }

        tbody tr:hover {
            background: #fafbfc;
        }

        tfoot td {
            border-bottom: none;
            padding-top: 20px;
            font-weight: bold;
        }

        .total {
            text-align: right;
            color: #202c40;
            font-size: 17px;
        }

        .sin-registros {
            text-align: center;
            padding: 30px;
            color: #8993a2;
        }

        /* BOTONES */

        .acciones {
            display: flex;
            justify-content: flex-end;
            margin-top: 25px;
        }

        .boton-volver {
            display: inline-block;
            background: #e84b35;
            color: white;
            padding: 13px 20px;
            border-radius: 7px;
            text-decoration: none;
            font-weight: bold;
            font-size: 13px;
            transition: 0.3s;
        }

        .boton-volver:hover {
            background: #c93629;
        }

        /* FOOTER */

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

        @media(max-width: 900px) {

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

            footer {
                margin-left: 0;
            }
        }

        @media(max-width: 600px) {

            .encabezado {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
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
                <button type="submit" class="activo">
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

    <!-- CONTENIDO PRINCIPAL -->

    <main class="contenido">

        <header class="encabezado">

            <div>
                <h1>Detalle de orden</h1>
                <p>Consulta los productos incluidos en esta orden de compra.</p>
            </div>

            <div class="perfil">
                👤 <%=admin.nombre%> <%=admin.apellido%>
            </div>

        </header>

        <section class="bienvenida">

            <h2>Orden de compra #<%=orden.id_orden%></h2>

            <p>
                Aquí puedes revisar la información del pedido realizado
                al proveedor y el detalle de los productos solicitados.
            </p>

        </section>

        <!-- INFORMACIÓN GENERAL -->

        <section class="tarjetas">

            <div class="tarjeta">

                <div class="etiqueta">Proveedor</div>

                <div class="valor">
                    <%=orden.nombre_proveedor != null
                        ? orden.nombre_proveedor
                        : "No disponible"%>
                </div>

            </div>

            <div class="tarjeta">

                <div class="etiqueta">Fecha de registro</div>

                <div class="valor">
                    <%=orden.fecha != null
                        ? formatoFecha.format(orden.fecha)
                        : "Sin fecha"%>
                </div>

            </div>

            <div class="tarjeta">

                <div class="etiqueta">Estado de la orden</div>

                <div class="valor">
                    <span class="estado <%=claseEstado%>">
                        <%=orden.estado%>
                    </span>
                </div>

            </div>

        </section>

        <!-- PRODUCTOS DE LA ORDEN -->

        <section class="seccion">

            <h2 class="titulo-seccion">Productos solicitados</h2>

            <div class="tabla-contenedor">

                <table>

                    <thead>
                        <tr>
                            <th>PRODUCTO</th>
                            <th>CANTIDAD</th>
                            <th>PRECIO UNITARIO</th>
                            <th>FECHA DE VENCIMIENTO</th>
                            <th>SUBTOTAL</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                        BigDecimal totalCalculado = BigDecimal.ZERO;

                        if (orden.detalles != null && !orden.detalles.isEmpty()) {

                            for (OrdenCompra.Detalle detalle : orden.detalles) {

                                BigDecimal subtotal = detalle.getSubtotal();

                                totalCalculado = totalCalculado.add(subtotal);
                    %>

                        <tr>

                            <td>
                                <strong>
                                    <%=detalle.nombre_producto != null
                                        ? detalle.nombre_producto
                                        : "Producto no disponible"%>
                                </strong>
                            </td>

                            <td>
                                <%=detalle.cantidad%>
                            </td>

                            <td>
                                S/ <%=detalle.precio != null
                                    ? detalle.precio.toString()
                                    : "0.00"%>
                            </td>

                            <td>
                                <%=detalle.fecha_vencimiento != null
                                    ? formatoVencimiento.format(detalle.fecha_vencimiento)
                                    : "No registrada"%>
                            </td>

                            <td>
                                S/ <%=subtotal.toString()%>
                            </td>

                        </tr>

                    <%
                            }
                        } else {
                    %>

                        <tr>
                            <td colspan="5" class="sin-registros">
                                Esta orden no tiene productos registrados.
                            </td>
                        </tr>

                    <% } %>

                    </tbody>

                    <tfoot>

                        <tr>
                            <td colspan="4" class="total">
                                TOTAL DE LA ORDEN
                            </td>

                            <td class="total">
                                S/ <%=orden.total != null
                                    ? orden.total.toString()
                                    : totalCalculado.toString()%>
                            </td>
                        </tr>

                    </tfoot>

                </table>

            </div>

            <div class="acciones">

                <a href="<%=ruta%>/OrdenCompraControlador?op=1"
                   class="boton-volver">
                    ← Volver a órdenes de compra
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
