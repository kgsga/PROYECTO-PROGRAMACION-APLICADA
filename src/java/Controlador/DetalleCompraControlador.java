
package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import Modelo.DetalleCompra;
import java.util.ArrayList;

@WebServlet(name = "DetalleCompraControlador", urlPatterns = {"/DetalleCompraControlador"})

public class DetalleCompraControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        int op = Integer.parseInt(request.getParameter("op"));

        DetalleCompra objDetalle = new DetalleCompra();

        switch (op) {

            case 1: // REGISTRAR DETALLE DE COMPRA

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

                int id = Integer.parseInt(request.getParameter("txtidcompra"));

                ArrayList<DetalleCompra> lista =
                    objDetalle.ListarDetalleCompra(id);

                request.setAttribute("lista", lista);

                request.getRequestDispatcher(
                    "/Vista/Admin/DetalleCompra.jsp"
                ).forward(request, response);

                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}
