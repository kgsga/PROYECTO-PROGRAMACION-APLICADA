
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Administrador"%>

<%
    if (session.getAttribute("administrador") == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login/Admin/Login.jsp");
        return;
    }

    ArrayList<Usuario> lista =
        (ArrayList<Usuario>) request.getAttribute("listaUsuarios");

    Administrador admin =
        (Administrador) session.getAttribute("administrador");

    String ruta = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de usuarios</title>

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

        /* MENU LATERAL FIJO */

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

        /* PANEL */

        .panel {
            background: white;
            padding: 28px;
            border-radius: 14px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.04);
        }

        .barra {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .barra h2 {
            font-size: 19px;
            color: #26364c;
        }

        .boton {
            border: none;
            background: #e84b35;
            color: white;
            padding: 12px 18px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .boton:hover {
            background: #c93629;
        }

        /* TABLA */

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        th {
            background: #f5f6f9;
            color: #566176;
            text-align: left;
            padding: 15px 12px;
            font-size: 13px;
        }

        td {
            padding: 15px 12px;
            border-bottom: 1px solid #edf0f4;
            font-size: 13px;
            color: #555f70;
        }

        tr:hover td {
            background: #fafbfc;
        }

        .eliminar {
            background: #fff0ed;
            color: #d94330;
            border: none;
            padding: 9px 12px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
        }

        .eliminar:hover {
            background: #e84b35;
            color: white;
        }

        .vacio {
            text-align: center;
            padding: 35px;
            color: #8993a2;
        }

        .mensaje {
            padding: 13px;
            background: #fff0ed;
            color: #c93629;
            border-radius: 8px;
            margin-bottom: 20px;
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

            .encabezado,
            .barra {
                align-items: flex-start;
                flex-direction: column;
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

            <!-- USUARIOS -->
            <form action="<%=ruta%>/UsuarioControlador" method="POST">
                <input type="hidden" name="op" value="2">
                <button type="submit" class="activo">
                    👥 &nbsp; Usuarios
                </button>
            </form>

            <!-- PRODUCTOS -->
            <form action="<%=ruta%>/ProductoControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">
                    📦 &nbsp; Productos
                </button>
            </form>

            <!-- COMPRAS DE CLIENTES -->
            <form action="<%=ruta%>/CompraControlador" method="POST">
                <input type="hidden" name="op" value="2">
                <button type="submit">
                    🛒 &nbsp; Compras
                </button>
            </form>

            <!-- PROVEEDORES -->
            <form action="<%=ruta%>/ProveedorControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">
                    🏭 &nbsp; Proveedores
                </button>
            </form>

            <!-- ÓRDENES DE COMPRA -->
            <form action="<%=ruta%>/OrdenCompraControlador" method="POST">
                <input type="hidden" name="op" value="1">
                <button type="submit">
                    📋 &nbsp; Órdenes de compra
                </button>
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
                <h1>Gestión de usuarios</h1>
                <p>Consulta y administra las cuentas de los compradores.</p>
            </div>

            <div class="perfil">
                👤 <%=admin.nombre%> <%=admin.apellido%>
            </div>

        </header>

        <section class="panel">

            <div class="barra">

                <h2>Usuarios registrados</h2>

                <form action="<%=ruta%>/UsuarioControlador"
                      method="POST">

                    <input type="hidden" name="op" value="2">

                    <button type="submit" class="boton">
                        Actualizar lista
                    </button>

                </form>

            </div>

            <% if (request.getAttribute("mensaje") != null) { %>

                <div class="mensaje">
                    <%=request.getAttribute("mensaje")%>
                </div>

            <% } %>

            <div class="tabla-contenedor">

                <table>

                    <thead>
                        <tr>
                            <th>CÓDIGO</th>
                            <th>NOMBRE</th>
                            <th>APELLIDO</th>
                            <th>DNI</th>
                            <th>CELULAR</th>
                            <th>CORREO</th>
                            <th>ACCIÓN</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (lista != null && !lista.isEmpty()) { %>

                            <% for (Usuario u : lista) { %>

                                <tr>

                                    <td><%=u.id_usuario%></td>
                                    <td><%=u.nombre%></td>
                                    <td><%=u.apellido%></td>
                                    <td><%=u.dni%></td>
                                    <td><%=u.celular%></td>
                                    <td><%=u.correo%></td>

                                    <td>

                                        <form action="<%=ruta%>/UsuarioControlador"
                                              method="POST"
                                              onsubmit="return confirm('¿Deseas eliminar este usuario?');">

                                            <input type="hidden" name="op" value="3">

                                            <input type="hidden"
                                                   name="txtid"
                                                   value="<%=u.id_usuario%>">

                                            <button type="submit" class="eliminar">
                                                Eliminar
                                            </button>

                                        </form>

                                    </td>

                                </tr>

                            <% } %>

                        <% } else { %>

                            <tr>
                                <td colspan="7" class="vacio">
                                    No hay usuarios para mostrar.
                                    Pulsa «Actualizar lista» para consultar los registros.
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

</body>
</html>
