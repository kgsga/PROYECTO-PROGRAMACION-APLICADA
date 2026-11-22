
package Controlador;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Modelo.Usuario;
import Modelo.Administrador;

@WebServlet(name = "LoginControlador", urlPatterns = {"/LoginControlador"})

public class LoginControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        switch (op) {

            case 1: // INICIAR SESION COMPRADOR

                String correoUsuario = request.getParameter("txtcorreo");
                String contraseñaUsuario = request.getParameter("txtcontraseña");

                Usuario objUsuario = new Usuario();

                if (objUsuario.IniciarSesion(correoUsuario, contraseñaUsuario)) {

                    HttpSession sesion = request.getSession();

                    // Limpiar datos de una sesión anterior
                    sesion.removeAttribute("administrador");
                    sesion.removeAttribute("usuario");
                    sesion.removeAttribute("carrito");
                    sesion.removeAttribute("paginaRetorno");

                    // Registrar al comprador en esta sesión
                    sesion.setAttribute("usuario", objUsuario);

                    response.sendRedirect(
                            request.getContextPath() + "/Vista/Principal.jsp"
                    );

                } else {

                    request.setAttribute("mensaje", "Correo o contraseña incorrectos");

                    request.getRequestDispatcher(
                            "/Vista/Login/Usuario/LoginUsuAntiguo.jsp"
                    ).forward(request, response);
                }

                break;

            case 2: // INICIAR SESION ADMINISTRADOR

                String correoAdmin = request.getParameter("txtcorreo");
                String contraseñaAdmin = request.getParameter("txtcontraseña");

                Administrador objAdministrador = new Administrador();

                if (objAdministrador.IniciarSesion(correoAdmin, contraseñaAdmin)) {

                    HttpSession sesion = request.getSession();

                    // Limpiar datos de una sesión anterior
                    sesion.removeAttribute("usuario");
                    sesion.removeAttribute("administrador");
                    sesion.removeAttribute("carrito");
                    sesion.removeAttribute("paginaRetorno");

                    // Registrar al administrador en esta sesión
                    sesion.setAttribute("administrador", objAdministrador);

                    response.sendRedirect(
                            request.getContextPath() + "/Vista/Admin/PanelAdmin.jsp"
                    );

                } else {

                    request.setAttribute("mensaje", "Correo o contraseña incorrectos");

                    request.getRequestDispatcher(
                            "/Vista/Login/Admin/Login.jsp"
                    ).forward(request, response);
                }

                break;

            default:

                response.sendRedirect(
                        request.getContextPath() + "/Vista/Principal.jsp"
                );

                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}
