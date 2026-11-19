
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Proveedor"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.Administrador"%>
<%@page import="java.util.ArrayList"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");
    String ruta = request.getContextPath();

    ArrayList<Proveedor> lista =
        (ArrayList<Proveedor>) request.getAttribute("lista");

    ArrayList<Producto> listaProductos =
        (ArrayList<Producto>) request.getAttribute("listaProductos");

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de proveedores</title>

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
            gap: 20px;
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
            white-space: nowrap;
        }

        /* MENSAJES */

        .mensaje {
            padding: 14px 17px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .mensaje.exito {
            background: #e5f7ed;
            color: #207548;
            border: 1px solid #b8e6cb;
        }

        .mensaje.error {
            background: #fdebea;
            color: #b52d27;
            border: 1px solid #f3c2bf;
        }

        /* PANELES */

        .panel,
        .panel-listado {
            background: white;
            border: 1px solid #edf0f4;
            border-radius: 13px;
            padding: 27px;
            margin-bottom: 25px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.04);
        }

        .panel h2,
        .titulo-listado h2 {
            font-size: 19px;
            color: #26364c;
        }

        .panel h2 {
            margin-bottom: 22px;
        }

        /* FORMULARIOS */

        .formulario {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .campo.completo {
            grid-column: 1 / -1;
        }

        .campo label {
            color: #59677a;
            font-size: 13px;
            font-weight: bold;
        }

        .campo input {
            width: 100%;
            padding: 12px;
            border: 1px solid #dce1e8;
            border-radius: 7px;
            outline: none;
            font-size: 14px;
            color: #26364c;
        }

        .campo input:focus {
            border-color: #526d91;
        }

        /* SELECCIÓN DE PRODUCTOS */

        .productos-selector {
            grid-column: 1 / -1;
            border: 1px solid #dce1e8;
            border-radius: 9px;
            padding: 17px;
            background: #fafbfd;
        }

        .productos-selector h3 {
            font-size: 14px;
            margin-bottom: 6px;
            color: #26364c;
        }

        .ayuda-productos {
            color: #8993a2;
            font-size: 12px;
            margin-bottom: 13px;
        }

        .buscador-productos {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #dce1e8;
            border-radius: 7px;
            outline: none;
            font-size: 13px;
            margin-bottom: 12px;
            color: #26364c;
            background: white;
        }

        .buscador-productos:focus {
            border-color: #526d91;
        }

        .lista-productos {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 9px;
            max-height: 230px;
            overflow-y: auto;
            padding: 3px;
        }

        .producto-opcion {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 11px;
            background: white;
            border: 1px solid #e1e5eb;
            border-radius: 7px;
            cursor: pointer;
            font-size: 13px;
            color: #536176;
            transition: .2s;
        }

        .producto-opcion:hover {
            border-color: #526d91;
            background: #f3f6fa;
        }

        .producto-opcion input {
            width: 16px;
            height: 16px;
            accent-color: #26364c;
            cursor: pointer;
            flex-shrink: 0;
        }

        .producto-opcion.oculto {
            display: none;
        }

        .sin-productos {
            font-size: 13px;
            color: #8993a2;
            padding: 12px 0;
        }

        .sin-coincidencias {
            display: none;
            color: #8993a2;
            font-size: 13px;
            padding: 12px 0;
        }

        .sin-coincidencias.visible {
            display: block;
        }

        .seleccionados {
            margin-top: 12px;
            color: #526d91;
            font-size: 12px;
            font-weight: bold;
        }

        .acciones-formulario {
            grid-column: 1 / -1;
            display: flex;
            gap: 10px;
            margin-top: 5px;
        }

        .btn-registrar {
            padding: 12px 20px;
            background: #e84b35;
            color: white;
            border: none;
            border-radius: 7px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }

        .btn-registrar:hover {
            background: #c93629;
        }

        /* LISTADO */

        .titulo-listado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .contador {
            background: #f0f2f6;
            color: #59677a;
            padding: 7px 12px;
            border-radius: 6px;
            font-size: 12px;
        }

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        th {
            background: #f1f3f7;
            color: #536176;
            font-size: 12px;
            text-align: left;
            padding: 14px 12px;
            border-bottom: 1px solid #dce1e8;
        }

        td {
            padding: 15px 12px;
            border-bottom: 1px solid #dce1e8;
            font-size: 13px;
            color: #536176;
            vertical-align: top;
        }

        tbody tr:hover {
            background: #fafbfc;
        }

        .nombre-proveedor {
            color: #26364c;
            font-weight: bold;
        }

        .productos-proveedor {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            max-width: 330px;
        }

        .etiqueta-producto {
            display: inline-block;
            padding: 6px 9px;
            background: #edf2f8;
            color: #3e587b;
            border: 1px solid #d7e0eb;
            border-radius: 5px;
            font-size: 11px;
        }

        .sin-asignar {
            color: #8993a2;
            font-style: italic;
        }

        .acciones {
            display: flex;
            gap: 7px;
            align-items: center;
        }

        .acciones form {
            display: inline;
        }

        .btn-modificar,
        .btn-eliminar {
            border: none;
            padding: 9px 11px;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-size: 12px;
        }

        .btn-modificar {
            background: #526d91;
        }

        .btn-modificar:hover {
            background: #3e587b;
        }

        .btn-eliminar {
            background: #e84b35;
        }

        .btn-eliminar:hover {
            background: #c93629;
        }

        /* EDICIÓN */

        .form-edicion {
            display: none;
            background: #f7f8fb;
            padding: 20px;
            border: 1px solid #dce1e8;
            border-radius: 9px;
            margin-top: 15px;
        }

        .form-edicion.visible {
            display: block;
        }

        .form-edicion h3 {
            font-size: 16px;
            margin-bottom: 17px;
        }

        .botones-edicion {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-guardar {
            background: #e84b35;
            color: white;
            border: none;
            padding: 10px 17px;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn-guardar:hover {
            background: #c93629;
        }

        .btn-cancelar {
            background: #e1e5eb;
            color: #26364c;
            border: none;
            padding: 10px 17px;
            border-radius: 6px;
            cursor: pointer;
        }

        .vacio {
            padding: 45px 20px;
            text-align: center;
            color: #8993a2;
        }

        .vacio h3 {
            color: #26364c;
            margin-bottom: 10px;
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

        @media(max-width: 1000px) {
            .lista-productos {
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
                gap: 15px;
            }
        }

        @media(max-width: 600px) {

            .formulario {
                grid-template-columns: 1fr;
            }

            .campo.completo,
            .acciones-formulario,
            .productos-selector {
                grid-column: 1;
            }

            .panel,
            .panel-listado {
                padding: 18px;
            }

            .titulo-listado {
                align-items: flex-start;
                flex-direction: column;
            }

            .lista-productos {
                grid-template-columns: 1fr;
            }

            .acciones {
                flex-wrap: wrap;
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
                <button type="submit" class="activo">🏭 &nbsp; Proveedores</button>
            </form>

            <form action="<%=ruta%>/OrdenCompraControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">📋 &nbsp; Órdenes de compra</button>
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
                <h1>Gestión de proveedores</h1>
                <p>Registra y administra los proveedores y los productos que ofrecen.</p>
            </div>

            <div class="perfil">
                👤 <%=admin.nombre%> <%=admin.apellido%>
            </div>

        </header>

        <% if ("registrado".equals(mensaje)) { %>
            <div class="mensaje exito">
                Proveedor registrado correctamente.
            </div>
        <% } else if ("actualizado".equals(mensaje)) { %>
            <div class="mensaje exito">
                Proveedor actualizado correctamente.
            </div>
        <% } else if ("eliminado".equals(mensaje)) { %>
            <div class="mensaje exito">
                Proveedor eliminado correctamente.
            </div>
        <% } else if ("noeliminado".equals(mensaje)) { %>
            <div class="mensaje error">
                No se pudo eliminar. Es posible que este proveedor tenga órdenes de compra registradas.
            </div>
        <% } else if ("error".equals(mensaje)) { %>
            <div class="mensaje error">
                No se pudo completar la operación. Revisa los datos e inténtalo nuevamente.
            </div>
        <% } %>

        <!-- REGISTRAR PROVEEDOR -->

        <section class="panel">

            <h2>➕ Registrar nuevo proveedor</h2>

            <form action="<%=ruta%>/ProveedorControlador"
                  method="post"
                  class="formulario">

                <input type="hidden" name="op" value="2">

                <div class="campo">
                    <label>Nombre del proveedor *</label>
                    <input type="text"
                           name="txtnombre"
                           maxlength="100"
                           placeholder="Nombre o razón social"
                           required>
                </div>

                <div class="campo">
                    <label>RUC</label>
                    <input type="text"
                           name="txtruc"
                           maxlength="20"
                           placeholder="Número de RUC">
                </div>

                <div class="campo">
                    <label>Teléfono</label>
                    <input type="text"
                           name="txttelefono"
                           maxlength="20"
                           placeholder="Número de contacto">
                </div>

                <div class="campo">
                    <label>Correo electrónico</label>
                    <input type="email"
                           name="txtcorreo"
                           maxlength="100"
                           placeholder="correo@ejemplo.com">
                </div>

                <div class="campo completo">
                    <label>Dirección</label>
                    <input type="text"
                           name="txtdireccion"
                           maxlength="200"
                           placeholder="Dirección del proveedor">
                </div>

                <div class="productos-selector">

                    <h3>📦 Productos que ofrece</h3>

                    <p class="ayuda-productos">
                        Marca todos los productos que este proveedor puede suministrar.
                        Puedes seleccionar varios.
                    </p>

                    <% if (listaProductos != null && !listaProductos.isEmpty()) { %>

                        <input type="text"
                               class="buscador-productos"
                               placeholder="🔎 Buscar producto..."
                               oninput="buscarProductos(this)">

                        <div class="lista-productos">

                            <% for (Producto producto : listaProductos) { %>

                                <label class="producto-opcion">

                                    <input type="checkbox"
                                           name="productos"
                                           value="<%=producto.id_producto%>"
                                           onchange="actualizarContador(this.form)">

                                    <span><%=producto.nombre%></span>

                                </label>

                            <% } %>

                        </div>

                        <p class="sin-coincidencias">
                            No se encontraron productos con ese nombre.
                        </p>

                        <div class="seleccionados">
                            Productos seleccionados:
                            <span class="contador-seleccion">0</span>
                        </div>

                    <% } else { %>

                        <p class="sin-productos">
                            No hay productos registrados. Primero registra productos en la sección Productos.
                        </p>

                    <% } %>

                </div>

                <div class="acciones-formulario">
                    <button type="submit" class="btn-registrar">
                        Registrar proveedor
                    </button>
                </div>

            </form>

        </section>

        <!-- LISTADO DE PROVEEDORES -->

        <section class="panel-listado">

            <div class="titulo-listado">
                <h2>📋 Proveedores registrados</h2>

                <span class="contador">
                    <%=lista != null ? lista.size() : 0%> proveedores
                </span>
            </div>

            <% if (lista != null && !lista.isEmpty()) { %>

                <div class="tabla-contenedor">

                    <table>

                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>PROVEEDOR</th>
                                <th>RUC</th>
                                <th>TELÉFONO</th>
                                <th>CORREO</th>
                                <th>PRODUCTOS QUE OFRECE</th>
                                <th>ACCIONES</th>
                            </tr>
                        </thead>

                        <tbody>

                            <% for (Proveedor p : lista) { %>

                                <tr>

                                    <td>#<%=p.id_proveedor%></td>

                                    <td class="nombre-proveedor">
                                        <%=p.nombre != null ? p.nombre : ""%>
                                    </td>

                                    <td>
                                        <%=p.ruc != null && !p.ruc.isEmpty() ? p.ruc : "—"%>
                                    </td>

                                    <td>
                                        <%=p.telefono != null && !p.telefono.isEmpty() ? p.telefono : "—"%>
                                    </td>

                                    <td>
                                        <%=p.correo != null && !p.correo.isEmpty() ? p.correo : "—"%>
                                    </td>

                                    <td>

                                        <% if (p.productos != null && !p.productos.isEmpty()) { %>

                                            <div class="productos-proveedor">

                                                <% for (String nombreProducto : p.productos) { %>

                                                    <span class="etiqueta-producto">
                                                        <%=nombreProducto%>
                                                    </span>

                                                <% } %>

                                            </div>

                                        <% } else { %>

                                            <span class="sin-asignar">
                                                Sin productos asignados
                                            </span>

                                        <% } %>

                                    </td>

                                    <td>

                                        <div class="acciones">

                                            <button type="button"
                                                    class="btn-modificar"
                                                    onclick="mostrarEdicion(<%=p.id_proveedor%>)">
                                                ✏️ Modificar
                                            </button>

                                            <form action="<%=ruta%>/ProveedorControlador"
                                                  method="post"
                                                  onsubmit="return confirm('¿Estás seguro de eliminar este proveedor?');">

                                                <input type="hidden" name="op" value="4">
                                                <input type="hidden" name="txtid" value="<%=p.id_proveedor%>">

                                                <button type="submit" class="btn-eliminar">
                                                    🗑️ Eliminar
                                                </button>

                                            </form>

                                        </div>

                                    </td>

                                </tr>

                                <!-- FORMULARIO DE MODIFICACIÓN -->

                                <tr>
                                    <td colspan="7" style="padding:0; border-bottom:none;">

                                        <div class="form-edicion"
                                             id="edicion-<%=p.id_proveedor%>">

                                            <h3>✏️ Modificar proveedor #<%=p.id_proveedor%></h3>

                                            <form action="<%=ruta%>/ProveedorControlador"
                                                  method="post">

                                                <input type="hidden" name="op" value="3">
                                                <input type="hidden" name="txtid" value="<%=p.id_proveedor%>">

                                                <div class="formulario">

                                                    <div class="campo">
                                                        <label>Nombre del proveedor *</label>
                                                        <input type="text"
                                                               name="txtnombre"
                                                               maxlength="100"
                                                               value="<%=p.nombre != null ? p.nombre : ""%>"
                                                               required>
                                                    </div>

                                                    <div class="campo">
                                                        <label>RUC</label>
                                                        <input type="text"
                                                               name="txtruc"
                                                               maxlength="20"
                                                               value="<%=p.ruc != null ? p.ruc : ""%>">
                                                    </div>

                                                    <div class="campo">
                                                        <label>Teléfono</label>
                                                        <input type="text"
                                                               name="txttelefono"
                                                               maxlength="20"
                                                               value="<%=p.telefono != null ? p.telefono : ""%>">
                                                    </div>

                                                    <div class="campo">
                                                        <label>Correo electrónico</label>
                                                        <input type="email"
                                                               name="txtcorreo"
                                                               maxlength="100"
                                                               value="<%=p.correo != null ? p.correo : ""%>">
                                                    </div>

                                                    <div class="campo completo">
                                                        <label>Dirección</label>
                                                        <input type="text"
                                                               name="txtdireccion"
                                                               maxlength="200"
                                                               value="<%=p.direccion != null ? p.direccion : ""%>">
                                                    </div>

                                                    <div class="productos-selector">

                                                        <h3>📦 Productos que ofrece</h3>

                                                        <p class="ayuda-productos">
                                                            Marca los productos que este proveedor puede suministrar.
                                                        </p>

                                                        <% if (listaProductos != null && !listaProductos.isEmpty()) { %>

                                                            <input type="text"
                                                                   class="buscador-productos"
                                                                   placeholder="🔎 Buscar producto..."
                                                                   oninput="buscarProductos(this)">

                                                            <div class="lista-productos">

                                                                <% for (Producto producto : listaProductos) {
                                                                    boolean seleccionado = p.productos != null
                                                                        && p.productos.contains(producto.nombre);
                                                                %>

                                                                    <label class="producto-opcion">

                                                                        <input type="checkbox"
                                                                               name="productos"
                                                                               value="<%=producto.id_producto%>"
                                                                               <%=seleccionado ? "checked" : ""%>
                                                                               onchange="actualizarContador(this.form)">

                                                                        <span><%=producto.nombre%></span>

                                                                    </label>

                                                                <% } %>

                                                            </div>

                                                            <p class="sin-coincidencias">
                                                                No se encontraron productos con ese nombre.
                                                            </p>

                                                            <div class="seleccionados">
                                                                Productos seleccionados:
                                                                <span class="contador-seleccion">
                                                                    <%=p.productos != null ? p.productos.size() : 0%>
                                                                </span>
                                                            </div>

                                                        <% } else { %>

                                                            <p class="sin-productos">
                                                                No hay productos registrados.
                                                            </p>

                                                        <% } %>

                                                    </div>

                                                </div>

                                                <div class="botones-edicion">

                                                    <button type="submit" class="btn-guardar">
                                                        💾 Guardar cambios
                                                    </button>

                                                    <button type="button"
                                                            class="btn-cancelar"
                                                            onclick="cancelarEdicion(<%=p.id_proveedor%>)">
                                                        ✖ Cancelar
                                                    </button>

                                                </div>

                                            </form>

                                        </div>

                                    </td>
                                </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            <% } else { %>

                <div class="vacio">
                    <h3>📭 Aún no hay proveedores registrados</h3>
                    <p>Registra tu primer proveedor utilizando el formulario superior.</p>
                </div>

            <% } %>

        </section>

    </main>

</div>

<footer>
    © 2026 UNFV Supermarket. Todos los derechos reservados.
</footer>

<script>

    function mostrarEdicion(id) {

        document.querySelectorAll(".form-edicion").forEach(function(formulario) {
            formulario.classList.remove("visible");
        });

        var formulario = document.getElementById("edicion-" + id);

        if (formulario) {
            formulario.classList.add("visible");

            actualizarContador(formulario.querySelector("form"));

            formulario.scrollIntoView({
                behavior: "smooth",
                block: "center"
            });
        }
    }

    function cancelarEdicion(id) {

        var formulario = document.getElementById("edicion-" + id);

        if (formulario) {
            formulario.classList.remove("visible");
        }
    }

    // BUSCAR PRODUCTOS POR NOMBRE

    function buscarProductos(buscador) {

        var texto = buscador.value
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim();

        var selector = buscador.closest(".productos-selector");
        var opciones = selector.querySelectorAll(".producto-opcion");
        var mensaje = selector.querySelector(".sin-coincidencias");

        var encontrados = 0;

        opciones.forEach(function(opcion) {

            var nombre = opcion.textContent
                .toLowerCase()
                .normalize("NFD")
                .replace(/[\u0300-\u036f]/g, "")
                .trim();

            if (nombre.includes(texto)) {
                opcion.classList.remove("oculto");
                encontrados++;
            } else {
                opcion.classList.add("oculto");
            }

        });

        if (mensaje) {
            mensaje.classList.toggle("visible", encontrados === 0);
        }
    }

    // CONTAR PRODUCTOS SELECCIONADOS

    function actualizarContador(formulario) {

        if (!formulario) return;

        var seleccionados = formulario.querySelectorAll(
            'input[name="productos"]:checked'
        ).length;

        var contador = formulario.querySelector(".contador-seleccion");

        if (contador) {
            contador.textContent = seleccionados;
        }
    }

    document.addEventListener("DOMContentLoaded", function() {

        document.querySelectorAll(".formulario").forEach(function(formulario) {
            actualizarContador(formulario);
        });

    });

</script>

</body>
</html>
