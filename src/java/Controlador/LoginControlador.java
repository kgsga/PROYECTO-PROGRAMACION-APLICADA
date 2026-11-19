

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

        int op = Integer.parseInt(request.getParameter("op"));

        switch (op) {

            case 1: // INICIAR SESION COMPRADOR

                String correoUsuario = request.getParameter("txtcorreo");
                String contraseñaUsuario = request.getParameter("txtcontraseña");

                Usuario objUsuario = new Usuario();

                if (objUsuario.IniciarSesion(correoUsuario, contraseñaUsuario)) {

                    HttpSession sesion = request.getSession();
                    sesion.setAttribute("usuario", objUsuario);

                    // Recuperar la página desde donde se solicitó iniciar sesión
                    String paginaRetorno = (String) sesion.getAttribute("paginaRetorno");

                    // Eliminar el dato para que no afecte futuros inicios de sesión
                    sesion.removeAttribute("paginaRetorno");

                    // Validar que sea una ruta interna de la aplicación
                    if (paginaRetorno != null
                            && paginaRetorno.startsWith("/Vista/")
                            && !paginaRetorno.startsWith("//")
                            && !paginaRetorno.contains("://")) {

                        response.sendRedirect(
                            request.getContextPath() + paginaRetorno
                        );

                    } else {

                        response.sendRedirect(
                            request.getContextPath() + "/Vista/Principal.jsp"
                        );
                    }

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
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}
