package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Modelo.Compra;
import Modelo.Usuario;
import Modelo.Producto;
import java.util.ArrayList;

@WebServlet(name = "CompraControlador", urlPatterns = {"/CompraControlador"})

public class CompraControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int op;

        try {
            op = Integer.parseInt(request.getParameter("op"));
        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/Vista/Principal.jsp"
            );
            return;
        }

        Compra objCompra = new Compra();

        String contexto = request.getContextPath();

        switch (op) {

            case 1: // REGISTRAR COMPRA COMPLETA - SOLO COMPRADOR

                HttpSession sesion = request.getSession(false);

                if (sesion == null || sesion.getAttribute("usuario") == null) {

                    response.sendRedirect(
                        contexto + "/Vista/Principal.jsp"
                    );

                    return;
                }

                Usuario objUsuario = (Usuario) sesion.getAttribute("usuario");

                ArrayList<Producto> carrito =
                    (ArrayList<Producto>) sesion.getAttribute("carrito");

                if (carrito == null || carrito.isEmpty()) {

                    response.sendRedirect(
                        contexto + "/Vista/Comprador/Carrito.jsp"
                    );

                    return;
                }

                boolean resultado = objCompra.RegistrarCompra(
                    objUsuario.id_usuario, carrito
                );

                if (resultado) {

                    sesion.removeAttribute("carrito");

                    request.setAttribute(
                        "mensaje", "¡Tu compra se registró correctamente!"
                    );

                } else {

                    request.setAttribute(
                        "mensaje",
                        "No se pudo registrar la compra. Verifica el stock disponible."
                    );
                }

                request.getRequestDispatcher(
                    "/Vista/Comprador/Tienda.jsp"
                ).forward(request, response);

                break;

            case 2: // LISTAR COMPRAS - SOLO ADMINISTRADOR

                HttpSession sesionLista = request.getSession(false);

                if (sesionLista == null
                        || sesionLista.getAttribute("administrador") == null) {

                    response.sendRedirect(
                        contexto + "/Vista/Login/Admin/Login.jsp"
                    );

                    return;
                }

                ArrayList<Compra> lista = objCompra.ListarCompra();

                request.setAttribute("lista", lista);

                request.getRequestDispatcher(
                    "/Vista/Admin/GestionCompras.jsp"
                ).forward(request, response);

                break;

            case 3: // ESTADÍSTICAS DE VENTAS - SOLO ADMINISTRADOR

                HttpSession sesionEstadisticas = request.getSession(false);

                if (sesionEstadisticas == null
                        || sesionEstadisticas.getAttribute("administrador") == null) {

                    response.sendRedirect(
                        contexto + "/Vista/Login/Admin/Login.jsp"
                    );

                    return;
                }

                int totalCompras = objCompra.TotalCompras();

                double totalIngresos = objCompra.TotalIngresos();

                int pendientes = objCompra.ComprasPendientes();

                request.setAttribute("totalCompras", totalCompras);
                request.setAttribute("totalIngresos", totalIngresos);
                request.setAttribute("pendientes", pendientes);

                request.getRequestDispatcher(
                    "/Vista/Admin/Estadisticas.jsp"
                ).forward(request, response);

                break;

            case 4: // MIS COMPRAS DEL USUARIO - SOLO COMPRADOR

                HttpSession sesionComprador = request.getSession(false);

                if (sesionComprador == null
                        || sesionComprador.getAttribute("usuario") == null) {

                    response.sendRedirect(
                        contexto + "/Vista/Principal.jsp"
                    );

                    return;
                }

                Usuario comprador =
                    (Usuario) sesionComprador.getAttribute("usuario");

                ArrayList<Compra> misCompras =
                    objCompra.ListarComprasUsuario(comprador.id_usuario);

                request.setAttribute("listaCompras", misCompras);

                request.getRequestDispatcher(
                    "/Vista/Comprador/MisCompras.jsp"
                ).forward(request, response);

                break;

            case 5: // ACTUALIZAR ESTADO DE UNA COMPRA - SOLO ADMINISTRADOR

                HttpSession sesionAdmin = request.getSession(false);

                if (sesionAdmin == null
                        || sesionAdmin.getAttribute("administrador") == null) {

                    response.sendRedirect(
                        contexto + "/Vista/Login/Admin/Login.jsp"
                    );

                    return;
                }

                int idCompra;
                String nuevoEstado = request.getParameter("estado");

                try {

                    idCompra = Integer.parseInt(
                        request.getParameter("txtidcompra")
                    );

                    if (idCompra <= 0) {
                        throw new NumberFormatException();
                    }

                } catch (NumberFormatException e) {

                    response.sendRedirect(
                        contexto + "/CompraControlador?op=2&actualizado=0"
                    );

                    return;
                }

                if (nuevoEstado == null || nuevoEstado.trim().isEmpty()) {

                    response.sendRedirect(
                        contexto + "/CompraControlador?op=2&actualizado=0"
                    );

                    return;
                }

                boolean actualizado = objCompra.ActualizarEstado(
                    idCompra, nuevoEstado
                );

                response.sendRedirect(
                    contexto + "/CompraControlador?op=2&actualizado="
                    + (actualizado ? "1" : "0")
                );

                break;

            default:

                response.sendRedirect(
                    contexto + "/Vista/Principal.jsp"
                );

                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}