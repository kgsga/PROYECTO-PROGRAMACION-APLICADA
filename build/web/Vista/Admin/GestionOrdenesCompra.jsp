
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Administrador"%>
<%@page import="Modelo.Proveedor"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.OrdenCompra"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.BigDecimal"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");

    String ruta = request.getContextPath();

    ArrayList<Proveedor> listaProveedores =
        (ArrayList<Proveedor>) request.getAttribute("listaProveedores");

    ArrayList<Producto> listaProductos =
        (ArrayList<Producto>) request.getAttribute("listaProductos");

    ArrayList<OrdenCompra> listaOrdenes =
        (ArrayList<OrdenCompra>) request.getAttribute("listaOrdenes");

    String mensaje = request.getParameter("mensaje");

    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Órdenes de compra</title>

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

        /* BIENVENIDA */

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

        /* SECCIONES */

        .titulo-seccion {
            font-size: 19px;
            margin-bottom: 18px;
            color: #26364c;
        }

        .seccion {
            background: white;
            padding: 28px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
            border: 1px solid #edf0f4;
            margin-bottom: 30px;
        }

        .descripcion-seccion {
            color: #8993a2;
            font-size: 13px;
            margin-bottom: 23px;
            line-height: 1.5;
        }

        /* FORMULARIO */

        .grupo {
            margin-bottom: 20px;
        }

        .grupo label {
            display: block;
            color: #34445a;
            font-size: 13px;
            font-weight: bold;
            margin-bottom: 9px;
        }

        .grupo input,
        .grupo select {
            width: 100%;
            padding: 12px;
            border: 1px solid #dce2ea;
            border-radius: 7px;
            outline: none;
            font-size: 14px;
            background: white;
            color: #263238;
        }

        .grupo input:focus,
        .grupo select:focus {
            border-color: #e84b35;
        }

        .productos-titulo {
            color: #34445a;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 7px;
        }

        .productos-ayuda {
            font-size: 12px;
            color: #8993a2;
            margin-bottom: 15px;
        }

        .productos-proveedor {
            display: none;
            border: 1px solid #e3e7ed;
            border-radius: 9px;
            padding: 15px;
            margin-bottom: 18px;
            background: #fafbfc;
        }

        /* FILAS DE PRODUCTOS */

        .producto-item {
            display: grid;
            grid-template-columns: minmax(150px, 1fr) 100px 120px 150px;
            align-items: center;
            gap: 12px;
            padding: 13px 8px;
            border-bottom: 1px solid #e0e5ec;
        }

        .producto-item:last-child {
            border-bottom: none;
        }

        .producto-nombre {
            display: flex;
            align-items: center;
            gap: 9px;
            font-size: 13px;
            color: #34445a;
            font-weight: bold;
        }

        .producto-nombre input {
            accent-color: #e84b35;
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .producto-item input[type="number"],
        .producto-item input[type="date"] {
            width: 100%;
            padding: 9px;
            border: 1px solid #dce2ea;
            border-radius: 6px;
            outline: none;
            font-size: 12px;
            min-width: 0;
        }

        .producto-item input:disabled {
            background: #edf0f4;
            cursor: not-allowed;
        }

        .encabezado-productos {
            display: grid;
            grid-template-columns: minmax(150px, 1fr) 100px 120px 150px;
            gap: 12px;
            padding: 0 8px 10px;
            color: #8993a2;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .sin-productos {
            display: none;
            padding: 18px;
            text-align: center;
            background: #fff8e8;
            color: #99732b;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 18px;
        }

        .boton-principal {
            background: #e84b35;
            color: white;
            padding: 13px 20px;
            border: none;
            border-radius: 7px;
            font-weight: bold;
            font-size: 13px;
            cursor: pointer;
            transition: 0.3s;
        }

        .boton-principal:hover {
            background: #c93629;
        }

        .boton-detalle {
            display: inline-block;
            background: #fff0ed;
            color: #e84b35;
            padding: 9px 13px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: bold;
        }

        .boton-detalle:hover {
            background: #e84b35;
            color: white;
        }

        /* MENSAJES */

        .mensaje {
            padding: 13px 16px;
            border-radius: 8px;
            margin-bottom: 22px;
            font-size: 13px;
        }

        .mensaje.exito {
            background: #e8f7ed;
            color: #237443;
            border: 1px solid #c9ebd4;
        }

        .mensaje.error {
            background: #fff0ed;
            color: #c93629;
            border: 1px solid #f5d0c9;
        }

        /* TABLA DE ÓRDENES */

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
            padding: 15px 12px;
            border-bottom: 1px solid #e0e5ec;
            font-size: 13px;
            color: #34445a;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: #fafbfc;
        }

        .estado {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
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

        .form-estado {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .form-estado select {
            padding: 8px;
            border: 1px solid #dce2ea;
            border-radius: 6px;
            font-size: 12px;
            background: white;
        }

        .form-estado button {
            padding: 8px 10px;
            border: none;
            border-radius: 6px;
            background: #344761;
            color: white;
            font-size: 11px;
            cursor: pointer;
        }

        .form-estado button:hover {
            background: #202c40;
        }

        .form-estado button:disabled {
            background: #8993a2;
            cursor: not-allowed;
        }

        .sin-registros {
            text-align: center;
            padding: 30px;
            color: #8993a2;
            font-size: 14px;
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

        @media(max-width: 900px) {

            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                min-height: auto;
            }

            .contenedor {
                flex-direction: column;
            }

            .contenido {
                margin-left: 0;
                padding: 25px 20px;
            }

            footer {
                margin-left: 0;
            }
        }

        @media(max-width: 700px) {

            .producto-item,
            .encabezado-productos {
                grid-template-columns: minmax(150px, 1fr) 100px 120px 150px;
                gap: 8px;
            }

            .productos-proveedor {
                overflow-x: auto;
            }

            .encabezado-productos,
            .producto-item {
                min-width: 540px;
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

            .bienvenida {
                padding: 23px;
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
                <button type="submit">
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
                <h1>Órdenes de compra</h1>
                <p>Gestiona los pedidos de productos realizados a tus proveedores.</p>
            </div>

            <div class="perfil">
                👤 <%=admin.nombre%> <%=admin.apellido%>
            </div>

        </header>

        <section class="bienvenida">

            <h2>Gestión de órdenes a proveedores</h2>

            <p>
                Registra los productos que necesitas solicitar a tus proveedores,
                consulta las órdenes realizadas y actualiza su estado cuando
                sean enviadas o recibidas.
            </p>

        </section>

        <!-- MENSAJES -->

        <% if ("registrado".equals(mensaje)) { %>

            <div class="mensaje exito">
                La orden de compra se registró correctamente.
            </div>

        <% } else if ("actualizado".equals(mensaje)) { %>

            <div class="mensaje exito">
                El estado de la orden se actualizó correctamente.
                Si fue marcada como recibida, el stock de los productos también se actualizó.
            </div>

        <% } else if ("errorestado".equals(mensaje)) { %>

            <div class="mensaje error">
                No se pudo actualizar el estado. Verifica que la orden exista
                y que todavía permita cambios.
            </div>

        <% } else if ("datos".equals(mensaje)) { %>

            <div class="mensaje error">
                Revisa los datos ingresados. Debes seleccionar un proveedor
                y al menos un producto con cantidad y precio válidos.
            </div>

        <% } else if ("error".equals(mensaje)) { %>

            <div class="mensaje error">
                No se pudo completar la operación. Verifica los datos e inténtalo nuevamente.
            </div>

        <% } %>

        <!-- REGISTRAR ORDEN -->

        <section class="seccion">

            <h2 class="titulo-seccion">Registrar nueva orden</h2>

            <p class="descripcion-seccion">
                Selecciona un proveedor para visualizar los productos que ofrece.
                Después indica la cantidad, el precio de compra y la fecha de vencimiento
                de cada producto, si corresponde.
            </p>

            <form action="<%=ruta%>/OrdenCompraControlador" method="POST"
                  id="formOrden">

                <input type="hidden" name="op" value="2">

                <div class="grupo">

                    <label for="id_proveedor">Proveedor</label>

                    <select name="id_proveedor" id="id_proveedor" required>

                        <option value="">Seleccionar proveedor</option>

                        <% if (listaProveedores != null) {
                            for (Proveedor p : listaProveedores) { %>

                                <option value="<%=p.id_proveedor%>">
                                    <%=p.nombre%>
                                </option>

                        <%  }
                        } %>

                    </select>

                </div>

                <div class="productos-titulo">
                    Productos disponibles del proveedor
                </div>

                <p class="productos-ayuda">
                    Marca la casilla de cada producto que deseas solicitar.
                    Luego completa su cantidad, precio de compra y fecha de vencimiento.
                    La fecha es opcional.
                </p>

                <div id="mensajeSinProveedor" class="sin-productos"
                     style="display:block;">
                    Primero selecciona un proveedor para mostrar sus productos.
                </div>

                <% if (listaProveedores != null && listaProductos != null) {
                    for (Proveedor prov : listaProveedores) { %>

                    <div class="productos-proveedor"
                         data-proveedor="<%=prov.id_proveedor%>">

                        <div class="encabezado-productos">
                            <span>Producto</span>
                            <span>Cantidad</span>
                            <span>Precio compra (S/)</span>
                            <span>Vencimiento</span>
                        </div>

                        <%
                            boolean tieneProductos = false;

                            if (prov.productos != null) {
                                for (Producto producto : listaProductos) {

                                    if (prov.productos.contains(producto.nombre)) {
                                        tieneProductos = true;
                        %>

                            <div class="producto-item">

                                <label class="producto-nombre">

                                    <input type="checkbox"
                                           class="check-producto"
                                           name="id_producto"
                                           value="<%=producto.id_producto%>">

                                    <span><%=producto.nombre%></span>

                                </label>

                                <input type="number"
                                       class="cantidad-producto"
                                       name="cantidad"
                                       min="1"
                                       step="1"
                                       placeholder="Cantidad"
                                       disabled>

                                <input type="number"
                                       class="precio-producto"
                                       name="precio"
                                       min="0"
                                       step="0.01"
                                       placeholder="0.00"
                                       disabled>

                                <input type="date"
                                       class="fecha-vencimiento"
                                       name="fecha_vencimiento"
                                       disabled>

                            </div>

                        <%
                                    }
                                }
                            }

                            if (!tieneProductos) {
                        %>

                            <div class="sin-productos" style="display:block;">
                                Este proveedor todavía no tiene productos asignados.
                            </div>

                        <% } %>

                    </div>

                <%  }
                } %>

                <button type="submit" class="boton-principal">
                    + Registrar orden de compra
                </button>

            </form>

        </section>

        <!-- LISTADO DE ÓRDENES -->

        <section class="seccion">

            <h2 class="titulo-seccion">Órdenes registradas</h2>

            <p class="descripcion-seccion">
                Consulta las órdenes realizadas y actualiza su estado
                conforme avance el pedido al proveedor.
            </p>

            <div class="tabla-contenedor">

                <table>

                    <thead>
                        <tr>
                            <th>N.º ORDEN</th>
                            <th>PROVEEDOR</th>
                            <th>FECHA</th>
                            <th>TOTAL</th>
                            <th>ESTADO</th>
                            <th>DETALLES</th>
                            <th>ACTUALIZAR ESTADO</th>
                        </tr>
                    </thead>

                    <tbody>

                    <% if (listaOrdenes != null && !listaOrdenes.isEmpty()) {

                        for (OrdenCompra orden : listaOrdenes) {

                            String claseEstado = "pendiente";

                            if ("Enviada".equals(orden.estado)) {
                                claseEstado = "enviada";
                            } else if ("Recibida".equals(orden.estado)) {
                                claseEstado = "recibida";
                            } else if ("Cancelada".equals(orden.estado)) {
                                claseEstado = "cancelada";
                            }
                    %>

                        <tr>

                            <td><strong>#<%=orden.id_orden%></strong></td>

                            <td><%=orden.nombre_proveedor%></td>

                            <td>
                                <%=orden.fecha != null
                                    ? formatoFecha.format(orden.fecha)
                                    : "Sin fecha"%>
                            </td>

                            <td>
                                S/ <%=orden.total != null
                                    ? orden.total.toString()
                                    : "0.00"%>
                            </td>

                            <td>
                                <span class="estado <%=claseEstado%>">
                                    <%=orden.estado%>
                                </span>
                            </td>

                            <td>
                                <a class="boton-detalle"
                                   href="<%=ruta%>/OrdenCompraControlador?op=4&id_orden=<%=orden.id_orden%>">
                                    Ver detalles
                                </a>
                            </td>

                            <td>

                                <form action="<%=ruta%>/OrdenCompraControlador"
                                      method="POST"
                                      class="form-estado">

                                    <input type="hidden" name="op" value="3">

                                    <input type="hidden" name="id_orden"
                                           value="<%=orden.id_orden%>">

                                    <select name="estado"
                                            <%=("Recibida".equals(orden.estado)
                                                || "Cancelada".equals(orden.estado))
                                                ? "disabled" : ""%>>

                                        <option value="Pendiente"
                                            <%= "Pendiente".equals(orden.estado)
                                                ? "selected" : "" %>>
                                            Pendiente
                                        </option>

                                        <option value="Enviada"
                                            <%= "Enviada".equals(orden.estado)
                                                ? "selected" : "" %>>
                                            Enviada
                                        </option>

                                        <option value="Recibida"
                                            <%= "Recibida".equals(orden.estado)
                                                ? "selected" : "" %>>
                                            Recibida
                                        </option>

                                        <option value="Cancelada"
                                            <%= "Cancelada".equals(orden.estado)
                                                ? "selected" : "" %>>
                                            Cancelada
                                        </option>

                                    </select>

                                    <button type="submit"
                                        <%=("Recibida".equals(orden.estado)
                                            || "Cancelada".equals(orden.estado))
                                            ? "disabled" : ""%>>
                                        Guardar
                                    </button>

                                </form>

                            </td>

                        </tr>

                    <%  }
                    } else { %>

                        <tr>
                            <td colspan="7" class="sin-registros">
                                Todavía no hay órdenes de compra registradas.
                            </td>
                        </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

<footer>
    © 2026 UNFV Supermarket. Todos los derechos reservados.
</footer>

<script>

    // MOSTRAR LOS PRODUCTOS DEL PROVEEDOR SELECCIONADO

    const selectorProveedor = document.getElementById("id_proveedor");

    const panelesProductos =
        document.querySelectorAll(".productos-proveedor");

    const mensajeSinProveedor =
        document.getElementById("mensajeSinProveedor");

    function mostrarProductosProveedor() {

        const idProveedor = selectorProveedor.value;

        let encontroPanel = false;

        panelesProductos.forEach(function(panel) {

            const coincide =
                panel.dataset.proveedor === idProveedor;

            panel.style.display = coincide ? "block" : "none";

            if (coincide) {
                encontroPanel = true;
            }

        });

        if (idProveedor === "") {

            mensajeSinProveedor.style.display = "block";
            mensajeSinProveedor.textContent =
                "Primero selecciona un proveedor para mostrar sus productos.";

        } else if (!encontroPanel) {

            mensajeSinProveedor.style.display = "block";
            mensajeSinProveedor.textContent =
                "No se encontraron productos para este proveedor.";

        } else {

            mensajeSinProveedor.style.display = "none";

        }

    }

    selectorProveedor.addEventListener(
        "change",
        mostrarProductosProveedor
    );

    // ACTIVAR LOS CAMPOS CUANDO SE SELECCIONA UN PRODUCTO

    document.querySelectorAll(".check-producto").forEach(function(checkbox) {

        checkbox.addEventListener("change", function() {

            const fila = this.closest(".producto-item");

            const cantidad =
                fila.querySelector(".cantidad-producto");

            const precio =
                fila.querySelector(".precio-producto");

            const fecha =
                fila.querySelector(".fecha-vencimiento");

            cantidad.disabled = !this.checked;
            precio.disabled = !this.checked;
            fecha.disabled = !this.checked;

            cantidad.required = this.checked;
            precio.required = this.checked;

            if (!this.checked) {
                cantidad.value = "";
                precio.value = "";
                fecha.value = "";
            }

        });

    });

    // VALIDAR EL FORMULARIO ANTES DE REGISTRAR

    document.getElementById("formOrden").addEventListener(
        "submit",
        function(e) {

            if (selectorProveedor.value === "") {

                e.preventDefault();
                alert("Selecciona un proveedor.");
                return;

            }

            const seleccionados =
                document.querySelectorAll(
                    ".productos-proveedor[data-proveedor='" +
                    selectorProveedor.value +
                    "'] .check-producto:checked"
                );

            if (seleccionados.length === 0) {

                e.preventDefault();
                alert("Selecciona al menos un producto.");
                return;

            }

            for (let checkbox of seleccionados) {

                const fila = checkbox.closest(".producto-item");

                const cantidad =
                    fila.querySelector(".cantidad-producto");

                const precio =
                    fila.querySelector(".precio-producto");

                if (cantidad.value === "" ||
                    Number(cantidad.value) <= 0 ||
                    precio.value === "" ||
                    Number(precio.value) < 0) {

                    e.preventDefault();

                    alert(
                        "Completa una cantidad válida y el precio de compra de cada producto seleccionado."
                    );

                    return;
                }

            }

        }
    );

</script>

</body>
</html>
