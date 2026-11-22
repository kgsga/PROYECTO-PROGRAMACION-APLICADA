package Controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Modelo.Usuario;
import java.util.ArrayList;

@WebServlet(name = "UsuarioControlador", urlPatterns = {"/UsuarioControlador"})

public class UsuarioControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String parametroOp = request.getParameter("op");

        if (parametroOp == null || parametroOp.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Operación no especificada");
            return;
        }

        int op;

        try {
            op = Integer.parseInt(parametroOp);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Operación inválida");
            return;
        }

        Usuario objUsuario = new Usuario();

        switch (op) {

            case 1: // REGISTRAR USUARIO - PÚBLICO

                String nombre = request.getParameter("txtnombre");
                String apellido = request.getParameter("txtapellido");
                String dni = request.getParameter("txtdni");

                String celular = request.getParameter("txtcelular");
                celular = celular == null ? "" : celular.replaceAll("\\D", "");

                String correo = request.getParameter("txtcorreo");
                String contraseña = request.getParameter("txtcontraseña");

                boolean resultado = objUsuario.Insertar(
                    nombre, apellido, dni, celular, correo, contraseña
                );

                if (resultado) {
                    request.setAttribute("mensaje", "Usuario registrado correctamente");
                } else {
                    request.setAttribute("mensaje", "No se pudo registrar el usuario. Verifica tus datos.");
                }

                request.getRequestDispatcher(
                    "/Vista/Login/Usuario/LoginUsuAntiguo.jsp"
                ).forward(request, response);

                break;

            case 2: // LISTAR USUARIOS - SOLO ADMINISTRADOR

                HttpSession sesionAdmin = request.getSession(false);

                if (sesionAdmin == null || sesionAdmin.getAttribute("administrador") == null) {
                    response.sendRedirect(
                        request.getContextPath() + "/Vista/Login/Admin/Login.jsp"
                    );
                    return;
                }

                ArrayList<Usuario> lista = objUsuario.ListarUsuario();

                request.setAttribute("listaUsuarios", lista);

                request.getRequestDispatcher(
                    "/Vista/Admin/GestionUsuarios.jsp"
                ).forward(request, response);

                break;

            case 3: // ELIMINAR USUARIO - SOLO ADMINISTRADOR

                HttpSession sesionEliminar = request.getSession(false);

                if (sesionEliminar == null || sesionEliminar.getAttribute("administrador") == null) {
                    response.sendRedirect(
                        request.getContextPath() + "/Vista/Login/Admin/Login.jsp"
                    );
                    return;
                }

                int id;

                try {
                    id = Integer.parseInt(request.getParameter("txtid"));

                    if (id <= 0) {
                        throw new NumberFormatException();
                    }

                } catch (NumberFormatException e) {

                    request.setAttribute(
                        "mensaje",
                        "El código del usuario no es válido."
                    );

                    request.setAttribute(
                        "listaUsuarios",
                        objUsuario.ListarUsuario()
                    );

                    request.getRequestDispatcher(
                        "/Vista/Admin/GestionUsuarios.jsp"
                    ).forward(request, response);

                    return;
                }

                int eliminado = objUsuario.eliminar(id);

                if (eliminado > 0) {
                    request.setAttribute("mensaje", "Usuario eliminado correctamente");
                } else {
                    request.setAttribute("mensaje", "No se pudo eliminar el usuario");
                }

                ArrayList<Usuario> listaActualizada = objUsuario.ListarUsuario();

                request.setAttribute("listaUsuarios", listaActualizada);

                request.getRequestDispatcher(
                    "/Vista/Admin/GestionUsuarios.jsp"
                ).forward(request, response);

                break;

            case 4: // ACTUALIZAR DATOS DEL COMPRADOR - SOLO CONSUMIDOR

                HttpSession sesion = request.getSession(false);

                if (sesion == null || sesion.getAttribute("usuario") == null) {
                    response.sendRedirect(
                        request.getContextPath() + "/Vista/Principal.jsp"
                    );
                    return;
                }

                Usuario usuarioSesion = (Usuario) sesion.getAttribute("usuario");

                String nuevoNombre = request.getParameter("txtnombre");
                String nuevoApellido = request.getParameter("txtapellido");
                String nuevoDni = request.getParameter("txtdni");

                String nuevoCelular = request.getParameter("txtcelular");
                nuevoCelular = nuevoCelular == null ? "" : nuevoCelular.replaceAll("\\D", "");

                String nuevoCorreo = request.getParameter("txtcorreo");

                String nuevaContraseña = request.getParameter("txtcontraseña");
                String confirmarContraseña = request.getParameter("txtconfirmarcontraseña");

                if (nuevaContraseña == null) {
                    nuevaContraseña = "";
                }

                if (confirmarContraseña == null) {
                    confirmarContraseña = "";
                }

                // VALIDAR QUE LAS CONTRASEÑAS COINCIDAN

                if (!nuevaContraseña.isEmpty() || !confirmarContraseña.isEmpty()) {

                    if (nuevaContraseña.isEmpty() || confirmarContraseña.isEmpty()) {

                        request.setAttribute(
                            "mensaje",
                            "Debes completar los dos campos para cambiar tu contraseña."
                        );

                        request.getRequestDispatcher(
                            "/Vista/Comprador/MiCuenta.jsp"
                        ).forward(request, response);

                        return;
                    }

                    if (!nuevaContraseña.equals(confirmarContraseña)) {

                        request.setAttribute(
                            "mensaje",
                            "Las contraseñas no coinciden. Inténtalo nuevamente."
                        );

                        request.getRequestDispatcher(
                            "/Vista/Comprador/MiCuenta.jsp"
                        ).forward(request, response);

                        return;
                    }
                }

                // ACTUALIZAR LOS DATOS

                boolean actualizado = objUsuario.ActualizarDatos(
                    usuarioSesion.id_usuario,
                    nuevoNombre,
                    nuevoApellido,
                    nuevoDni,
                    nuevoCelular,
                    nuevoCorreo,
                    nuevaContraseña
                );

                if (actualizado) {

                    usuarioSesion.nombre = nuevoNombre;
                    usuarioSesion.apellido = nuevoApellido;
                    usuarioSesion.dni = nuevoDni;
                    usuarioSesion.celular = nuevoCelular;
                    usuarioSesion.correo = nuevoCorreo;

                    if (!nuevaContraseña.trim().isEmpty()) {
                        usuarioSesion.contraseña = nuevaContraseña;
                    }

                    sesion.setAttribute("usuario", usuarioSesion);

                    request.setAttribute(
                        "mensaje",
                        "Tus datos se actualizaron correctamente."
                    );

                } else {

                    request.setAttribute(
                        "mensaje",
                        "No se pudieron actualizar tus datos. Verifica la información."
                    );
                }

                request.getRequestDispatcher(
                    "/Vista/Comprador/MiCuenta.jsp"
                ).forward(request, response);

                break;

            default:

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Operación no válida"
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