
package Controlador;

import Modelo.Proveedor;
import Modelo.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProveedorControlador", urlPatterns = {"/ProveedorControlador"})
public class ProveedorControlador extends HttpServlet {

    Proveedor objProveedor = new Proveedor();

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
                request.getContextPath() + "/ProveedorControlador?op=1"
            );
            return;
        }

        try {

            switch (op) {

                // LISTAR PROVEEDORES Y PRODUCTOS DISPONIBLES
                case "1":

                    request.setAttribute("lista", objProveedor.Listar());

                    Producto objProducto = new Producto();

                    request.setAttribute(
                        "listaProductos",
                        objProducto.ListarProducto()
                    );

                    request.getRequestDispatcher(
                        "/Vista/Admin/GestionProveedores.jsp"
                    ).forward(request, response);

                    break;

                // REGISTRAR PROVEEDOR Y SUS PRODUCTOS
                case "2":

                    Proveedor nuevo = new Proveedor();

                    nuevo.nombre = request.getParameter("txtnombre");
                    nuevo.ruc = request.getParameter("txtruc");
                    nuevo.telefono = request.getParameter("txttelefono");
                    nuevo.correo = request.getParameter("txtcorreo");
                    nuevo.direccion = request.getParameter("txtdireccion");

                    String[] productosNuevos =
                        request.getParameterValues("productos");

                    boolean registrado = nuevo.Registrar(productosNuevos);

                    response.sendRedirect(
                        request.getContextPath()
                        + "/ProveedorControlador?op=1&mensaje="
                        + (registrado ? "registrado" : "error")
                    );

                    break;

                // MODIFICAR PROVEEDOR Y SUS PRODUCTOS
                case "3":

                    Proveedor modificar = new Proveedor();

                    modificar.id_proveedor = Integer.parseInt(
                        request.getParameter("txtid")
                    );

                    modificar.nombre = request.getParameter("txtnombre");
                    modificar.ruc = request.getParameter("txtruc");
                    modificar.telefono = request.getParameter("txttelefono");
                    modificar.correo = request.getParameter("txtcorreo");
                    modificar.direccion = request.getParameter("txtdireccion");

                    String[] productosModificados =
                        request.getParameterValues("productos");

                    boolean actualizado =
                        modificar.Modificar(productosModificados);

                    response.sendRedirect(
                        request.getContextPath()
                        + "/ProveedorControlador?op=1&mensaje="
                        + (actualizado ? "actualizado" : "error")
                    );

                    break;

                // ELIMINAR PROVEEDOR
                case "4":

                    int id = Integer.parseInt(
                        request.getParameter("txtid")
                    );

                    boolean eliminado = objProveedor.Eliminar(id);

                    response.sendRedirect(
                        request.getContextPath()
                        + "/ProveedorControlador?op=1&mensaje="
                        + (eliminado ? "eliminado" : "noeliminado")
                    );

                    break;

                default:

                    response.sendRedirect(
                        request.getContextPath() + "/ProveedorControlador?op=1"
                    );

                    break;
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/ProveedorControlador?op=1&mensaje=error"
            );

        } catch (Exception e) {

            System.out.println(
                "Error en ProveedorControlador: " + e.getMessage()
            );

            response.sendRedirect(
                request.getContextPath()
                + "/ProveedorControlador?op=1&mensaje=error"
            );
        }
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
        return "Controlador de proveedores";
    }
}
