package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Modelo.DetalleCompra;
import java.util.ArrayList;

@WebServlet(name = "DetalleCompraControlador", urlPatterns = {"/DetalleCompraControlador"})

public class DetalleCompraControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession(false);

        int op;

        try {
            op = Integer.parseInt(request.getParameter("op"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (op) {

            case 1: // REGISTRAR DETALLE DE COMPRA

                if (sesion == null || sesion.getAttribute("usuario") == null) {
                    response.sendRedirect(
                        request.getContextPath() + "/Vista/Principal.jsp"
                    );
                    return;
                }

                DetalleCompra objDetalle = new DetalleCompra();

                int idCompra = Integer.parseInt(request.getParameter("txtidcompra"));
                int idProducto = Integer.parseInt(request.getParameter("txtidproducto"));
                int cantidad = Integer.parseInt(request.getParameter("txtcantidad"));
                double precio = Double.parseDouble(request.getParameter("txtprecio"));

                boolean resultado = objDetalle.Insertar(
                    idCompra, idProducto, cantidad, precio
                );

                if (resultado) {
                    request.setAttribute("mensaje", "Detalle registrado correctamente");
                } else {
                    request.setAttribute("mensaje", "No se pudo registrar el detalle");
                }

                request.getRequestDispatcher(
                    "/Vista/Comprador/Tienda.jsp"
                ).forward(request, response);

                break;

            case 2: // LISTAR DETALLES DE UNA COMPRA

                if (sesion == null || sesion.getAttribute("administrador") == null) {
                    response.sendRedirect(
                        request.getContextPath() + "/Vista/Login/Admin/Login.jsp"
                    );
                    return;
                }

                DetalleCompra objDetalleAdmin = new DetalleCompra();

                int id = Integer.parseInt(request.getParameter("txtidcompra"));

                ArrayList<DetalleCompra> lista =
                    objDetalleAdmin.ListarDetalleCompra(id);

                request.setAttribute("lista", lista);

                request.getRequestDispatcher(
                    "/Vista/Admin/DetalleCompra.jsp"
                ).forward(request, response);

                break;

            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}