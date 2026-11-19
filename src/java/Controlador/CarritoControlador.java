
package Controlador;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Modelo.Producto;

@WebServlet(name = "CarritoControlador", urlPatterns = {"/CarritoControlador"})

public class CarritoControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession();

        String contexto = request.getContextPath();

        String rutaTienda = "/Vista/Comprador/Tienda.jsp";
        String rutaCarrito = contexto + "/Vista/Comprador/Carrito.jsp";
        String rutaLogin = contexto + "/Vista/Login/Usuario/LoginUsuAntiguo.jsp";

        int op;

        try {
            op = Integer.parseInt(request.getParameter("op"));
        } catch (NumberFormatException e) {
            response.sendRedirect(contexto + rutaTienda);
            return;
        }

        /*
         * OPERACIÓN 1:
         * AGREGAR PRODUCTO AL CARRITO
         *
         * Si el comprador no inició sesión, guardamos
         * la página donde estaba y lo enviamos al login.
         */

        if (op == 1 && sesion.getAttribute("usuario") == null) {

            String categoria = request.getParameter("categoria");
            String buscar = request.getParameter("buscar");

            StringBuilder paginaRetorno = new StringBuilder(rutaTienda);
            boolean tieneParametro = false;

            if (categoria != null && !categoria.trim().isEmpty()) {

                paginaRetorno.append("?categoria=")
                        .append(URLEncoder.encode(categoria, StandardCharsets.UTF_8));

                tieneParametro = true;
            }

            if (buscar != null && !buscar.trim().isEmpty()) {

                paginaRetorno.append(tieneParametro ? "&" : "?");

                paginaRetorno.append("buscar=")
                        .append(URLEncoder.encode(buscar, StandardCharsets.UTF_8));
            }

            // Guardamos la página para regresar después del login
            sesion.setAttribute("paginaRetorno", paginaRetorno.toString());

            response.sendRedirect(rutaLogin);
            return;
        }

        /*
         * Las demás operaciones del carrito requieren sesión.
         */

        if (sesion.getAttribute("usuario") == null) {

            sesion.setAttribute("paginaRetorno",
                    "/Vista/Comprador/Carrito.jsp");

            response.sendRedirect(rutaLogin);
            return;
        }

        ArrayList<Producto> carrito =
                (ArrayList<Producto>) sesion.getAttribute("carrito");

        if (carrito == null) {
            carrito = new ArrayList<>();
        }

        switch (op) {

            case 1: // AGREGAR PRODUCTO

                int idProducto;
                int cantidadAgregar;

                try {
                    idProducto = Integer.parseInt(
                            request.getParameter("txtidproducto"));

                    cantidadAgregar = Integer.parseInt(
                            request.getParameter("cantidad"));

                } catch (NumberFormatException e) {

                    request.setAttribute("mensaje",
                            "Los datos del producto no son válidos.");

                    request.getRequestDispatcher(rutaTienda)
                            .forward(request, response);
                    return;
                }

                Producto modelo = new Producto();
                ArrayList<Producto> productos = modelo.ListarProducto();

                boolean agregado = false;

                if (productos != null) {

                    for (Producto p : productos) {

                        if (p.id_producto == idProducto && p.stock > 0) {

                            int cantidadActual = 0;
                            Producto productoCarrito = null;

                            for (Producto item : carrito) {

                                if (item.id_producto == idProducto) {

                                    cantidadActual = item.cantidad;
                                    productoCarrito = item;
                                    break;
                                }
                            }

                            if (cantidadAgregar > 0
                                    && cantidadActual + cantidadAgregar <= p.stock) {

                                if (productoCarrito != null) {

                                    productoCarrito.cantidad += cantidadAgregar;

                                } else {

                                    p.cantidad = cantidadAgregar;
                                    carrito.add(p);
                                }

                                agregado = true;
                            }

                            break;
                        }
                    }
                }

                sesion.setAttribute("carrito", carrito);

                if (agregado) {

                    request.setAttribute("mensaje",
                            "¡Producto agregado al carrito correctamente!");

                } else {

                    request.setAttribute("mensaje",
                            "No se pudo agregar. Verifica la cantidad y el stock disponible.");
                }

                // Regresamos a la tienda conservando categoría y búsqueda
                request.getRequestDispatcher(rutaTienda)
                        .forward(request, response);

                break;

            case 2: // ELIMINAR PRODUCTO

                int idEliminar = Integer.parseInt(
                        request.getParameter("txtidproducto"));

                carrito.removeIf(p -> p.id_producto == idEliminar);

                sesion.setAttribute("carrito", carrito);

                response.sendRedirect(rutaCarrito);
                break;

            case 3: // VACIAR CARRITO

                carrito.clear();

                sesion.setAttribute("carrito", carrito);

                response.sendRedirect(rutaCarrito);
                break;

            case 4: // AUMENTAR CANTIDAD

                int idAumentar = Integer.parseInt(
                        request.getParameter("txtidproducto"));

                Producto modeloAumentar = new Producto();
                ArrayList<Producto> lista = modeloAumentar.ListarProducto();

                if (lista != null) {

                    for (Producto item : carrito) {

                        if (item.id_producto == idAumentar) {

                            for (Producto p : lista) {

                                if (p.id_producto == idAumentar
                                        && item.cantidad < p.stock) {

                                    item.cantidad++;
                                    break;
                                }
                            }

                            break;
                        }
                    }
                }

                sesion.setAttribute("carrito", carrito);

                response.sendRedirect(rutaCarrito);
                break;

            case 5: // DISMINUIR CANTIDAD

                int idDisminuir = Integer.parseInt(
                        request.getParameter("txtidproducto"));

                for (int i = 0; i < carrito.size(); i++) {

                    Producto item = carrito.get(i);

                    if (item.id_producto == idDisminuir) {

                        if (item.cantidad > 1) {

                            item.cantidad--;

                        } else {

                            carrito.remove(i);
                        }

                        break;
                    }
                }

                sesion.setAttribute("carrito", carrito);

                response.sendRedirect(rutaCarrito);
                break;

            default:

                response.sendRedirect(rutaCarrito);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}
