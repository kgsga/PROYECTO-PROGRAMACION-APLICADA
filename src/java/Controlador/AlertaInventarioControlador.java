
package Controlador;

import Modelo.AlertaInventario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AlertaInventarioControlador",
            urlPatterns = {"/AlertaInventarioControlador"})
public class AlertaInventarioControlador extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null
                || sesion.getAttribute("administrador") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Vista/Login/Admin/Login.jsp");
            return;
        }

        AlertaInventario objAlerta = new AlertaInventario();

        request.setAttribute(
                "listaStockBajo",
                objAlerta.ListarStockBajo());

        request.setAttribute(
                "listaVencidos",
                objAlerta.ListarLotesVencidos());

        request.setAttribute(
                "listaProximosVencer",
                objAlerta.ListarLotesProximosVencer());

        request.getRequestDispatcher(
                "/Vista/Admin/AlertasInventario.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}

