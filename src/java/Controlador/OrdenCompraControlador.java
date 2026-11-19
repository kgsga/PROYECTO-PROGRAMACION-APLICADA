
package Controlador;

import Modelo.OrdenCompra;
import Modelo.Proveedor;
import Modelo.Producto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;

@WebServlet(name = "OrdenCompraControlador", urlPatterns = {"/OrdenCompraControlador"})
public class OrdenCompraControlador extends HttpServlet {

    OrdenCompra objOrden = new OrdenCompra();

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("administrador") == null) {
            response.sendRedirect(
                request.getContextPath() + "/Vista/Login/Admin/Login.jsp"
            );
            return;
        }

        String op = request.getParameter("op");

        if (op == null) {
            response.sendRedirect(
                request.getContextPath() + "/OrdenCompraControlador?op=1"
            );
            return;
        }

        try {

            switch (op) {

                // MOSTRAR ÓRDENES, PROVEEDORES Y PRODUCTOS
                case "1":

                    cargarVista(request, response);
                    break;

                // REGISTRAR NUEVA ORDEN
                case "2":

                    int idProveedor = Integer.parseInt(
                        request.getParameter("id_proveedor")
                    );

                    String[] idsProductos =
                        request.getParameterValues("id_producto");

                    String[] cantidades =
                        request.getParameterValues("cantidad");

                    String[] precios =
                        request.getParameterValues("precio");

                    String[] fechasVencimiento =
                        request.getParameterValues("fecha_vencimiento");

                    if (idsProductos == null ||
                        cantidades == null ||
                        precios == null ||
                        fechasVencimiento == null ||
                        idsProductos.length == 0 ||
                        idsProductos.length != cantidades.length ||
                        idsProductos.length != precios.length ||
                        idsProductos.length != fechasVencimiento.length) {

                        response.sendRedirect(
                            request.getContextPath()
                            + "/OrdenCompraControlador?op=1&mensaje=datos"
                        );

                        return;
                    }

                    ArrayList<OrdenCompra.Detalle> detalles =
                        new ArrayList<>();

                    for (int i = 0; i < idsProductos.length; i++) {

                        OrdenCompra.Detalle detalle =
                            new OrdenCompra.Detalle();

                        detalle.id_producto =
                            Integer.parseInt(idsProductos[i]);

                        detalle.cantidad =
                            Integer.parseInt(cantidades[i]);

                        detalle.precio =
                            new BigDecimal(precios[i]);

                        // LEER FECHA DE VENCIMIENTO
                        String fecha = fechasVencimiento[i];

                        if (fecha != null && !fecha.trim().isEmpty()) {
                            detalle.fecha_vencimiento =
                                Date.valueOf(fecha);
                        } else {
                            detalle.fecha_vencimiento = null;
                        }

                        detalles.add(detalle);
                    }

                    boolean registrado =
                        objOrden.Registrar(idProveedor, detalles);

                    response.sendRedirect(
                        request.getContextPath()
                        + "/OrdenCompraControlador?op=1&mensaje="
                        + (registrado ? "registrado" : "error")
                    );

                    break;

                // ACTUALIZAR ESTADO DE UNA ORDEN
                case "3":

                    int idOrden = Integer.parseInt(
                        request.getParameter("id_orden")
                    );

                    String nuevoEstado =
                        request.getParameter("estado");

                    boolean actualizado =
                        objOrden.ActualizarEstado(idOrden, nuevoEstado);

                    response.sendRedirect(
                        request.getContextPath()
                        + "/OrdenCompraControlador?op=1&mensaje="
                        + (actualizado ? "actualizado" : "errorestado")
                    );

                    break;

                // VER DETALLES DE UNA ORDEN
                case "4":

                    int idDetalle = Integer.parseInt(
                        request.getParameter("id_orden")
                    );

                    OrdenCompra ordenDetalle = new OrdenCompra();

                    ordenDetalle.id_orden = idDetalle;

                    ArrayList<OrdenCompra> ordenes = objOrden.Listar();

                    for (OrdenCompra orden : ordenes) {

                        if (orden.id_orden == idDetalle) {
                            ordenDetalle = orden;
                            break;
                        }
                    }

                    ordenDetalle.detalles =
                        objOrden.ObtenerDetalles(idDetalle);

                    request.setAttribute("ordenDetalle", ordenDetalle);

                    cargarDatosGenerales(request);

                    request.getRequestDispatcher(
                        "/Vista/Admin/DetalleOrdenCompra.jsp"
                    ).forward(request, response);

                    break;

                default:

                    response.sendRedirect(
                        request.getContextPath()
                        + "/OrdenCompraControlador?op=1"
                    );

                    break;
            }

            } catch (IllegalArgumentException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/OrdenCompraControlador?op=1&mensaje=datos"
            );

        } catch (Exception e) {

            System.out.println(
                "Error en OrdenCompraControlador: " + e.getMessage()
            );

            response.sendRedirect(
                request.getContextPath()
                + "/OrdenCompraControlador?op=1&mensaje=error"
            );
        }
    }

    // CARGAR LA PANTALLA PRINCIPAL
    private void cargarVista(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        cargarDatosGenerales(request);

        request.setAttribute("listaOrdenes", objOrden.Listar());

        request.getRequestDispatcher(
            "/Vista/Admin/GestionOrdenesCompra.jsp"
        ).forward(request, response);
    }

    // CARGAR PROVEEDORES Y PRODUCTOS
    private void cargarDatosGenerales(HttpServletRequest request) {

        Proveedor objProveedor = new Proveedor();
        Producto objProducto = new Producto();

        request.setAttribute(
            "listaProveedores",
            objProveedor.Listar()
        );

        request.setAttribute(
            "listaProductos",
            objProducto.ListarProducto()
        );
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador de órdenes de compra a proveedores";
    }
}
