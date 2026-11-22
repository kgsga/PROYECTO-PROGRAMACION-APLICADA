package Controlador;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import Modelo.Producto;
import Modelo.Categoria;
import Util.Cloudinary;

@WebServlet(name = "ProductoControlador", urlPatterns = {"/ProductoControlador"})

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)

public class ProductoControlador extends HttpServlet {

    // Excepción para formatos de imagen no admitidos
    private static class FormatoImagenException extends Exception {
        public FormatoImagenException(String mensaje) {
            super(mensaje);
        }
    }

    // Validar y subir imagen a Cloudinary
    private Map<String, String> guardarImagen(Part archivo)
            throws Exception {

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

        if (!(extension.equals(".jpg")
                || extension.equals(".jpeg")
                || extension.equals(".png")
                || extension.equals(".gif")
                || extension.equals(".webp"))) {

            throw new FormatoImagenException(
                "Formato de imagen no admitido. "
                + "Selecciona JPG, JPEG, PNG, GIF o WEBP."
            );
        }

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

        // Subir la imagen a Cloudinary
        try (InputStream entrada = archivo.getInputStream()) {
            return Cloudinary.subirImagen(entrada);
        }
    }

    // Eliminar imagen de Cloudinary sin interrumpir la operación
    private boolean eliminarImagenCloudinary(String publicId) {

        if (publicId == null || publicId.trim().isEmpty()) {
            return true;
        }

        try {
            return Cloudinary.eliminarImagen(publicId);
        } catch (Exception e) {
            System.out.println(
                "No se pudo eliminar la imagen de Cloudinary: "
                + e.getMessage()
            );
            return false;
        }
    }

    // Cargar la vista de gestión de productos
    private void cargarVista(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        Producto objProducto = new Producto();
        Categoria objCategoria = new Categoria();

        request.setAttribute(
            "lista",
            objProducto.ListarProducto()
        );

        request.setAttribute(
            "categorias",
            objCategoria.ListarCategorias()
        );

        request.getRequestDispatcher(
            "/Vista/Admin/GestionProductos.jsp"
        ).forward(request, response);
    }

    // Mostrar mensaje de error y volver a la gestión
    private void mostrarError(HttpServletRequest request,
                              HttpServletResponse response,
                              String mensaje)
            throws ServletException, IOException {

        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", "error");

        cargarVista(request, response);
    }

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Todas las operaciones requieren administrador
        HttpSession sesion = request.getSession(false);

        if (sesion == null
                || sesion.getAttribute("administrador") == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/Vista/Login/Admin/Login.jsp"
            );

            return;
        }

        String operacion = request.getParameter("op");

        int op;

        try {
            op = Integer.parseInt(operacion);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Producto objProducto = new Producto();

        switch (op) {

            // LISTAR PRODUCTOS
            case 1:

                cargarVista(request, response);
                break;

            // REGISTRAR PRODUCTO
            case 2:

                String nombre = request.getParameter("txtnombre");
                String descripcion = request.getParameter("txtdescripcion");

                double precio;
                int stock;
                int idCategoria;

                try {
                    precio = Double.parseDouble(
                        request.getParameter("txtprecio")
                    );

                    stock = Integer.parseInt(
                        request.getParameter("txtstock")
                    );

                    idCategoria = Integer.parseInt(
                        request.getParameter("txtcategoria")
                    );

                } catch (Exception e) {
                    mostrarError(
                        request,
                        response,
                        "Los datos numéricos del producto no son válidos."
                    );
                    return;
                }

                if (precio <= 0 || stock < 0) {
                    mostrarError(
                        request,
                        response,
                        "El precio debe ser mayor que cero y el stock no puede ser negativo."
                    );
                    return;
                }

                Part archivoNuevo = request.getPart("archivoImagen");

                if (archivoNuevo == null || archivoNuevo.getSize() == 0) {
                    mostrarError(
                        request,
                        response,
                        "Debes seleccionar una imagen para el producto."
                    );
                    return;
                }

                Map<String, String> imagenSubida;

                try {
                    imagenSubida = guardarImagen(archivoNuevo);

                } catch (FormatoImagenException e) {
                    mostrarError(request, response, e.getMessage());
                    return;

                } catch (Exception e) {
                    System.out.println(
                        "Error al subir imagen: " + e.getMessage()
                    );

                    mostrarError(
                        request,
                        response,
                        "No se pudo subir la imagen a Cloudinary. "
                        + "Verifica la configuración e inténtalo nuevamente."
                    );
                    return;
                }

                String imagen = imagenSubida.get("url");
                String publicId = imagenSubida.get("public_id");

                boolean resultado = objProducto.Insertar(
                    nombre,
                    descripcion,
                    precio,
                    stock,
                    imagen,
                    publicId,
                    idCategoria
                );

                if (resultado) {

                    request.setAttribute(
                        "mensaje",
                        "Producto registrado correctamente."
                    );
                    request.setAttribute("tipoMensaje", "exito");

                } else {

                    // Si no se guardó en la base de datos,
                    // eliminar la imagen que acabamos de subir.
                    eliminarImagenCloudinary(publicId);

                    request.setAttribute(
                        "mensaje",
                        "No se pudo registrar el producto."
                    );
                    request.setAttribute("tipoMensaje", "error");
                }

                cargarVista(request, response);
                break;

            // MODIFICAR PRODUCTO
            case 3:

                int id;

                double precioModificar;
                int stockModificar;
                int categoriaModificar;

                try {
                    id = Integer.parseInt(
                        request.getParameter("txtid")
                    );

                    precioModificar = Double.parseDouble(
                        request.getParameter("txtprecio")
                    );

                    stockModificar = Integer.parseInt(
                        request.getParameter("txtstock")
                    );

                    categoriaModificar = Integer.parseInt(
                        request.getParameter("txtcategoria")
                    );

                } catch (Exception e) {
                    mostrarError(
                        request,
                        response,
                        "Los datos del producto no son válidos."
                    );
                    return;
                }

                if (precioModificar <= 0 || stockModificar < 0) {
                    mostrarError(
                        request,
                        response,
                        "El precio debe ser mayor que cero y el stock no puede ser negativo."
                    );
                    return;
                }

                String nombreModificar =
                    request.getParameter("txtnombre");

                String descripcionModificar =
                    request.getParameter("txtdescripcion");

                // Recuperar el public_id de la imagen anterior
                String publicIdAnterior =
                    objProducto.obtenerPublicId(id);

                // Mantener la URL y el public_id anteriores
                String imagenModificar =
                    request.getParameter("txtimagen");

                String publicIdModificar = publicIdAnterior;

                Part archivoModificar =
                    request.getPart("archivoImagen");

                Map<String, String> nuevaImagen = null;

                // Solo subir una imagen si el administrador seleccionó otra
                if (archivoModificar != null
                        && archivoModificar.getSize() > 0) {

                    try {
                        nuevaImagen = guardarImagen(archivoModificar);

                    } catch (FormatoImagenException e) {
                        mostrarError(request, response, e.getMessage());
                        return;

                    } catch (Exception e) {
                        System.out.println(
                            "Error al subir nueva imagen: " + e.getMessage()
                        );

                        mostrarError(
                            request,
                            response,
                            "No se pudo subir la nueva imagen a Cloudinary."
                        );
                        return;
                    }

                    imagenModificar = nuevaImagen.get("url");
                    publicIdModificar = nuevaImagen.get("public_id");
                }

                boolean modificado = objProducto.Modificar(
                    id,
                    nombreModificar,
                    descripcionModificar,
                    precioModificar,
                    stockModificar,
                    imagenModificar,
                    publicIdModificar,
                    categoriaModificar
                );

                if (modificado) {

                    // Eliminar la imagen anterior únicamente después
                    // de confirmar que la modificación se guardó.
                    if (nuevaImagen != null
                            && publicIdAnterior != null
                            && !publicIdAnterior.equals(publicIdModificar)) {

                        boolean eliminada =
                            eliminarImagenCloudinary(publicIdAnterior);

                        if (!eliminada) {
                            request.setAttribute(
                                "mensaje",
                                "Producto modificado, pero no se pudo eliminar la imagen anterior de Cloudinary."
                            );
                            request.setAttribute("tipoMensaje", "error");
                        } else {
                            request.setAttribute(
                                "mensaje",
                                "Producto modificado correctamente."
                            );
                            request.setAttribute("tipoMensaje", "exito");
                        }

                    } else {
                        request.setAttribute(
                            "mensaje",
                            "Producto modificado correctamente."
                        );
                        request.setAttribute("tipoMensaje", "exito");
                    }

                } else {

                    // Si falló la modificación, conservar la imagen anterior
                    // y eliminar la nueva que se había subido.
                    if (nuevaImagen != null) {
                        eliminarImagenCloudinary(
                            nuevaImagen.get("public_id")
                        );
                    }

                    request.setAttribute(
                        "mensaje",
                        "No se pudo modificar el producto."
                    );
                    request.setAttribute("tipoMensaje", "error");
                }

                cargarVista(request, response);
                break;

            // ELIMINAR PRODUCTO
            case 4:

                int idEliminar;

                try {
                    idEliminar = Integer.parseInt(
                        request.getParameter("txtid")
                    );
                } catch (Exception e) {
                    mostrarError(
                        request,
                        response,
                        "El código del producto no es válido."
                    );
                    return;
                }

                // Obtener la imagen antes de eliminar el registro
                String publicIdEliminar =
                    objProducto.obtenerPublicId(idEliminar);

                int eliminado = objProducto.eliminar(idEliminar);

                if (eliminado > 0) {

                    boolean imagenEliminada =
                        eliminarImagenCloudinary(publicIdEliminar);

                    if (imagenEliminada) {
                        request.setAttribute(
                            "mensaje",
                            "Producto eliminado correctamente."
                        );
                        request.setAttribute("tipoMensaje", "exito");
                    } else {
                        request.setAttribute(
                            "mensaje",
                            "Producto eliminado de la base de datos, pero no se pudo eliminar su imagen de Cloudinary."
                        );
                        request.setAttribute("tipoMensaje", "error");
                    }

                } else {
                    request.setAttribute(
                        "mensaje",
                        "No se pudo eliminar el producto."
                    );
                    request.setAttribute("tipoMensaje", "error");
                }

                cargarVista(request, response);
                break;

            default:

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST
                );
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
