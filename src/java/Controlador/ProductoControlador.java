
package Controlador;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import Modelo.Producto;
import Modelo.Categoria;

@WebServlet(name = "ProductoControlador", urlPatterns = {"/ProductoControlador"})

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)

public class ProductoControlador extends HttpServlet {

    // Excepción propia para identificar formatos no admitidos
    private static class FormatoImagenException extends Exception {
        public FormatoImagenException(String mensaje) {
            super(mensaje);
        }
    }

    // Obtener la carpeta de imágenes del proyecto y la de ejecución
    private File[] obtenerCarpetasImagenes() throws ServletException {

        String rutaDesplegada = getServletContext().getRealPath(
            "/Imagenes/ImagenesProductos"
        );

        if (rutaDesplegada == null) {
            throw new ServletException(
                "No se pudo localizar la carpeta de imágenes desplegada."
            );
        }

        File carpetaDesplegada = new File(rutaDesplegada);

        File carpetaWeb = carpetaDesplegada.getParentFile().getParentFile();
        File carpetaBuild = carpetaWeb.getParentFile();

        if (!carpetaWeb.getName().equalsIgnoreCase("web")
                || !carpetaBuild.getName().equalsIgnoreCase("build")) {

            throw new ServletException(
                "No se pudo identificar la estructura del proyecto. "
                + "Carpeta encontrada: " + rutaDesplegada
            );
        }

        File proyecto = carpetaBuild.getParentFile();

        File carpetaFuente = new File(
            proyecto,
            "web/Imagenes/ImagenesProductos"
        );

        if (!carpetaFuente.exists() && !carpetaFuente.mkdirs()) {
            throw new ServletException(
                "No se pudo crear la carpeta de imágenes del proyecto."
            );
        }

        if (!carpetaDesplegada.exists() && !carpetaDesplegada.mkdirs()) {
            throw new ServletException(
                "No se pudo crear la carpeta de imágenes desplegada."
            );
        }

        return new File[] {carpetaFuente, carpetaDesplegada};
    }

    // Guardar la imagen en ambas carpetas
    private String guardarImagen(Part archivo)
            throws IOException, ServletException, FormatoImagenException {

        if (archivo == null || archivo.getSize() == 0) {
            return null;
        }

        String nombreOriginal = archivo.getSubmittedFileName();

        if (nombreOriginal == null || !nombreOriginal.contains(".")) {
            throw new FormatoImagenException(
                "El archivo seleccionado no tiene una extensión válida."
            );
        }

        String extension = nombreOriginal.substring(
            nombreOriginal.lastIndexOf(".")
        ).toLowerCase();

        // Formatos admitidos
        if (!(extension.equals(".jpg") ||
              extension.equals(".jpeg") ||
              extension.equals(".png") ||
              extension.equals(".gif") ||
              extension.equals(".webp"))) {

            throw new FormatoImagenException(
                "Formato de imagen no admitido. "
                + "Selecciona una imagen JPG, JPEG, PNG, GIF o WEBP."
            );
        }

        // Comprobar el tipo de contenido cuando el navegador lo proporciona
        String tipo = archivo.getContentType();

        if (tipo != null && tipo.startsWith("image/")) {

            boolean tipoValido =
                (extension.equals(".jpg") || extension.equals(".jpeg"))
                    ? tipo.equalsIgnoreCase("image/jpeg")
                    : extension.equals(".png")
                    ? tipo.equalsIgnoreCase("image/png")
                    : extension.equals(".gif")
                    ? tipo.equalsIgnoreCase("image/gif")
                    : extension.equals(".webp")
                    && tipo.equalsIgnoreCase("image/webp");

            if (!tipoValido) {
                throw new FormatoImagenException(
                    "El formato del archivo no coincide con su extensión."
                );
            }
        }

        String nombreArchivo = UUID.randomUUID().toString() + extension;

        File[] carpetas = obtenerCarpetasImagenes();

        File carpetaFuente = carpetas[0];
        File carpetaDesplegada = carpetas[1];

        File imagenFuente = new File(carpetaFuente, nombreArchivo);
        File imagenDesplegada = new File(carpetaDesplegada, nombreArchivo);

        // Guardar primero en la carpeta permanente del proyecto
        try (java.io.InputStream entrada = archivo.getInputStream()) {
            Files.copy(
                entrada,
                imagenFuente.toPath(),
                StandardCopyOption.REPLACE_EXISTING
            );
        }

        // Copiar también a la carpeta desde donde trabaja el JSP
        if (!imagenFuente.getCanonicalPath().equals(
                imagenDesplegada.getCanonicalPath())) {

            Files.copy(
                imagenFuente.toPath(),
                imagenDesplegada.toPath(),
                StandardCopyOption.REPLACE_EXISTING
            );
        }

        return "Imagenes/ImagenesProductos/" + nombreArchivo;
    }

    // Cargar la vista de gestión de productos
    private void cargarVista(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        Producto objProducto = new Producto();
        Categoria objCategoria = new Categoria();

        ArrayList<Producto> lista = objProducto.ListarProducto();
        ArrayList<Categoria> categorias = objCategoria.ListarCategorias();

        request.setAttribute("lista", lista);
        request.setAttribute("categorias", categorias);

        request.getRequestDispatcher(
            "/Vista/Admin/GestionProductos.jsp"
        ).forward(request, response);
    }

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String operacion = request.getParameter("op");

        if (operacion == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int op = Integer.parseInt(operacion);

        Producto objProducto = new Producto();

        switch (op) {

            // Mostrar productos
            case 1:
                cargarVista(request, response);
                break;

            // Registrar producto
            case 2:

                String nombre = request.getParameter("txtnombre");
                String descripcion = request.getParameter("txtdescripcion");

                double precio = Double.parseDouble(
                    request.getParameter("txtprecio")
                );

                int stock = Integer.parseInt(
                    request.getParameter("txtstock")
                );

                int idCategoria = Integer.parseInt(
                    request.getParameter("txtcategoria")
                );

                Part archivoNuevo = request.getPart("archivoImagen");

                String imagen;

                try {
                    imagen = guardarImagen(archivoNuevo);
                } catch (FormatoImagenException e) {

                    request.setAttribute("mensaje", e.getMessage());
                    request.setAttribute("tipoMensaje", "error");

                    cargarVista(request, response);
                    return;
                }

                if (imagen == null) {
                    imagen = "";
                }

                boolean resultado = objProducto.Insertar(
                    nombre,
                    descripcion,
                    precio,
                    stock,
                    imagen,
                    idCategoria
                );

                if (resultado) {
                    request.setAttribute(
                        "mensaje",
                        "Producto registrado correctamente"
                    );
                    request.setAttribute("tipoMensaje", "exito");
                } else {
                    request.setAttribute(
                        "mensaje",
                        "No se pudo registrar el producto"
                    );
                    request.setAttribute("tipoMensaje", "error");
                }

                cargarVista(request, response);
                break;

            // Modificar producto
            case 3:

                int id = Integer.parseInt(
                    request.getParameter("txtid")
                );

                String nombreModificar = request.getParameter("txtnombre");
                String descripcionModificar = request.getParameter("txtdescripcion");

                double precioModificar = Double.parseDouble(
                    request.getParameter("txtprecio")
                );

                int stockModificar = Integer.parseInt(
                    request.getParameter("txtstock")
                );

                int categoriaModificar = Integer.parseInt(
                    request.getParameter("txtcategoria")
                );

                String imagenModificar = request.getParameter("txtimagen");

                Part archivoModificar = request.getPart("archivoImagen");

                String nuevaImagen;

                try {
                    nuevaImagen = guardarImagen(archivoModificar);
                } catch (FormatoImagenException e) {

                    request.setAttribute("mensaje", e.getMessage());
                    request.setAttribute("tipoMensaje", "error");

                    cargarVista(request, response);
                    return;
                }

                if (nuevaImagen != null) {
                    imagenModificar = nuevaImagen;
                }

                boolean modificado = objProducto.Modificar(
                    id,
                    nombreModificar,
                    descripcionModificar,
                    precioModificar,
                    stockModificar,
                    imagenModificar,
                    categoriaModificar
                );

                if (modificado) {
                    request.setAttribute(
                        "mensaje",
                        "Producto modificado correctamente"
                    );
                    request.setAttribute("tipoMensaje", "exito");
                } else {
                    request.setAttribute(
                        "mensaje",
                        "No se pudo modificar el producto"
                    );
                    request.setAttribute("tipoMensaje", "error");
                }

                cargarVista(request, response);
                break;

            // Eliminar producto
            case 4:

                int idEliminar = Integer.parseInt(
                    request.getParameter("txtid")
                );

                int eliminado = objProducto.eliminar(idEliminar);

                if (eliminado > 0) {
                    request.setAttribute(
                        "mensaje",
                        "Producto eliminado correctamente"
                    );
                    request.setAttribute("tipoMensaje", "exito");
                } else {
                    request.setAttribute(
                        "mensaje",
                        "No se pudo eliminar el producto"
                    );
                    request.setAttribute("tipoMensaje", "error");
                }

                cargarVista(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}
