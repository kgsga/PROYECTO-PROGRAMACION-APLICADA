
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Compra"%>
<%@page import="Modelo.Administrador"%>
<%@page import="java.util.ArrayList"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    Administrador admin = (Administrador) session.getAttribute("administrador");

    ArrayList<Compra> lista =
        (ArrayList<Compra>) request.getAttribute("lista");

    if (lista == null) {
        lista = new ArrayList<Compra>();
    }

    String ruta = request.getContextPath();

    String actualizado = request.getParameter("actualizado");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de compras | Supermarket</title>

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

        /* MENÚ LATERAL */

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
            transition: .3s;
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

        /* CERRAR SESIÓN */

        .cerrar {
            margin-top: 15px;
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

        .columna-principal {
            flex: 1;
            min-width: 0;
            margin-left: 250px;
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
            box-shadow: 0 3px 12px rgba(0,0,0,.04);
            font-size: 14px;
            white-space: nowrap;
        }

        /* PANEL */

        .panel {
            background: white;
            padding: 25px;
            border-radius: 13px;
            box-shadow: 0 3px 15px rgba(0,0,0,.04);
            margin-bottom: 25px;
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

        /* MENSAJES */

        .mensaje {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .mensaje.exito {
            background: #eaf8ef;
            color: #247a43;
            border: 1px solid #bce6ca;
        }

        .mensaje.error {
            background: #fff0ed;
            color: #d94732;
            border: 1px solid #ffd1c9;
        }

        /* TARJETAS DE COMPRAS */

        .lista-compras {
            display: flex;
            flex-direction: column;
        }

        .compra {
            padding: 24px 10px;
            border-bottom: 2px solid #c5cdd7;
            transition: background .2s;
        }

        .compra:first-child {
            border-top: 1px solid #e0e5eb;
        }

        .compra:last-child {
            border-bottom: none;
        }

        .compra:hover {
            background: #fafbfc;
        }

        .compra-superior {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 18px;
        }

        .compra-codigo {
            color: #26364c;
            font-size: 16px;
            font-weight: bold;
        }

        .compra-fecha {
            color: #8993a2;
            font-size: 12px;
            margin-top: 7px;
        }

        /* ESTADOS */

        .estado {
            display: inline-block;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            text-align: center;
        }

        .estado-pendiente {
            background: #fff4df;
            color: #b47a17;
        }

        .estado-preparacion {
            background: #eaf1ff;
            color: #3764ad;
        }

        .estado-enviado {
            background: #eeeaff;
            color: #6951ad;
        }

        .estado-entregado {
            background: #e5f6eb;
            color: #26834a;
        }

        .estado-cancelado {
            background: #ffe9e7;
            color: #c93629;
        }

        /* DATOS DE COMPRA */

        .compra-datos {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .dato {
            display: flex;
            flex-direction: column;
            gap: 7px;
            min-width: 0;
        }

        .dato-titulo {
            color: #8993a2;
            font-size: 11px;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: .4px;
        }

        .dato-valor {
            color: #344054;
            font-size: 14px;
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .precio {
            color: #e84b35;
            font-size: 17px;
            font-weight: bold;
        }

        /* CAMBIAR ESTADO */

        .actualizar-estado {
            margin-top: 20px;
            padding: 16px;
            background: #f8f9fc;
            border: 1px solid #e1e6ed;
            border-radius: 9px;
        }

        .actualizar-estado label {
            display: block;
            color: #526174;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 9px;
        }

        .controles-estado {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .selector-estado {
            flex: 1;
            min-width: 0;
            padding: 11px 12px;
            border: 1px solid #dce1e8;
            border-radius: 7px;
            background: white;
            color: #344054;
            font-size: 13px;
            outline: none;
        }

        .selector-estado:focus {
            border-color: #e84b35;
        }

        .guardar-estado {
            padding: 11px 16px;
            background: #202c40;
            color: white;
            border: none;
            border-radius: 7px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: .2s;
            white-space: nowrap;
        }

        .guardar-estado:hover {
            background: #344761;
        }

        /* BOTÓN DETALLES */

        .compra-acciones {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
        }

        .detalles {
            background: #e84b35;
            color: white;
            border: none;
            padding: 11px 17px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: .2s;
        }

        .detalles:hover {
            background: #c93629;
        }

        /* SIN COMPRAS */

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

        /* ACTUALIZAR HISTORIAL */

        .zona-actualizar {
            display: flex;
            justify-content: flex-end;
            margin-top: 25px;
        }

        .actualizar {
            padding: 12px 18px;
            background: #202c40;
            color: white;
            border: none;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
            font-size: 13px;
            transition: .2s;
        }

        .actualizar:hover {
            background: #344761;
        }

        /* PIE DE PÁGINA */

        footer {
            text-align: center;
            padding: 15px;
            color: #8993a2;
            font-size: 13px;
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

            .columna-principal {
                margin-left: 0;
            }

            .contenido {
                padding: 25px 20px;
            }

            .encabezado,
            .barra {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media(max-width: 600px) {

            .compra-datos {
                grid-template-columns: 1fr 1fr;
                gap: 18px;
            }

            .compra-superior {
                flex-direction: column;
            }

            .compra-acciones {
                justify-content: stretch;
            }

            .compra-acciones form,
            .detalles {
                width: 100%;
            }

            .controles-estado {
                flex-direction: column;
                align-items: stretch;
            }

            .guardar-estado {
                width: 100%;
            }

            .panel {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<div class="contenedor">

    <!-- MENÚ LATERAL -->

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

    <div class="columna-principal">

        <main class="contenido">

            <header class="encabezado">

                <div>
                    <h1>Historial de compras</h1>
                    <p>Consulta y administra las compras realizadas por los clientes.</p>
                </div>

                <div class="perfil">
                    👤 <%=admin.nombre%> <%=admin.apellido%>
                </div>

            </header>

            <section class="panel">

                <div class="barra">

                    <h2>🛒 Compras registradas</h2>

                    <span class="contador">
                        <%=lista.size()%> compras
                    </span>

                </div>

                <% if ("1".equals(actualizado)) { %>

                    <div class="mensaje exito">
                        El estado de la compra se actualizó correctamente.
                    </div>

                <% } else if ("0".equals(actualizado)) { %>

                    <div class="mensaje error">
                        No se pudo actualizar el estado. Verifica los datos e inténtalo nuevamente.
                    </div>

                <% } %>

                <% if (lista.isEmpty()) { %>

                    <div class="vacio">

                        <div class="vacio-icono">🛒</div>

                        <h3>No hay compras registradas</h3>

                        <p>Cuando los clientes realicen compras, aparecerán aquí.</p>

                    </div>

                <% } else { %>

                    <div class="lista-compras">

                        <% for (Compra c : lista) {

                            String estadoActual = c.estado == null
                                ? "Pendiente" : c.estado;

                            String claseEstado = "estado-pendiente";

                            if ("En preparación".equals(estadoActual)) {
                                claseEstado = "estado-preparacion";
                            } else if ("Enviado".equals(estadoActual)) {
                                claseEstado = "estado-enviado";
                            } else if ("Entregado".equals(estadoActual)) {
                                claseEstado = "estado-entregado";
                            } else if ("Cancelado".equals(estadoActual)) {
                                claseEstado = "estado-cancelado";
                            }
                        %>

                            <article class="compra">

                                <div class="compra-superior">

                                    <div>

                                        <div class="compra-codigo">
                                            Compra #<%=c.id_compra%>
                                        </div>

                                        <div class="compra-fecha">
                                            📅 <%=c.fecha%>
                                        </div>

                                    </div>

                                    <span class="estado <%=claseEstado%>">
                                        <%=estadoActual%>
                                    </span>

                                </div>

                                <div class="compra-datos">

                                    <div class="dato">

                                        <span class="dato-titulo">Cliente</span>

                                        <span class="dato-valor">
                                            <%=c.nombre_usuario%>
                                            <%=c.apellido_usuario%>
                                        </span>

                                    </div>

                                    <div class="dato">

                                        <span class="dato-titulo">Fecha de compra</span>

                                        <span class="dato-valor">
                                            <%=c.fecha%>
                                        </span>

                                    </div>

                                    <div class="dato">

                                        <span class="dato-titulo">Total de compra</span>

                                        <span class="precio">
                                            S/ <%=String.format(java.util.Locale.US, "%.2f", c.total)%>
                                        </span>

                                    </div>

                                </div>

                                <!-- CAMBIAR ESTADO -->

                                <div class="actualizar-estado">

                                    <form action="<%=ruta%>/CompraControlador"
                                          method="POST">

                                        <input type="hidden" name="op" value="5">

                                        <input type="hidden"
                                               name="txtidcompra"
                                               value="<%=c.id_compra%>">

                                        <label>
                                            Cambiar estado de esta compra
                                        </label>

                                        <div class="controles-estado">

                                            <select name="estado"
                                                    class="selector-estado"
                                                    required>

                                                <option value="Pendiente"
                                                    <%= "Pendiente".equals(estadoActual) ? "selected" : "" %>>
                                                    Pendiente
                                                </option>

                                                <option value="En preparación"
                                                    <%= "En preparación".equals(estadoActual) ? "selected" : "" %>>
                                                    En preparación
                                                </option>

                                                <option value="Enviado"
                                                    <%= "Enviado".equals(estadoActual) ? "selected" : "" %>>
                                                    Enviado
                                                </option>

                                                <option value="Entregado"
                                                    <%= "Entregado".equals(estadoActual) ? "selected" : "" %>>
                                                    Entregado
                                                </option>

                                                <option value="Cancelado"
                                                    <%= "Cancelado".equals(estadoActual) ? "selected" : "" %>>
                                                    Cancelado
                                                </option>

                                            </select>

                                            <button type="submit" class="guardar-estado">
                                                Actualizar estado
                                            </button>

                                        </div>

                                    </form>

                                </div>

                                <!-- VER DETALLES -->

                                <div class="compra-acciones">

                                    <form action="<%=ruta%>/DetalleCompraControlador"
                                          method="POST">

                                        <input type="hidden" name="op" value="2">

                                        <input type="hidden"
                                               name="txtidcompra"
                                               value="<%=c.id_compra%>">

                                        <button type="submit" class="detalles">
                                            Ver detalles →
                                        </button>

                                    </form>

                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } %>

                <!-- ACTUALIZAR HISTORIAL -->

                <div class="zona-actualizar">

                    <form action="<%=ruta%>/CompraControlador"
                          method="POST">

                        <input type="hidden" name="op" value="2">

                        <button type="submit" class="actualizar">
                            ↻ Actualizar historial
                        </button>

                    </form>

                </div>

            </section>

        </main>

        <footer>
            © 2026 UNFV Supermarket. Todos los derechos reservados.
        </footer>

    </div>

</div>

</body>
</html>
