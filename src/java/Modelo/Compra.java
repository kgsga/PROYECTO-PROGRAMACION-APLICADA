
package Modelo;

import java.sql.*;
import Util.ConexionBD;
import java.util.ArrayList;
import java.util.HashMap;

public class Compra {

    public int id_compra;
    public int id_usuario;
    public String nombre_usuario;
    public String apellido_usuario;
    public String fecha;
    public double total;
    public String estado;

    public ArrayList<Producto> detalles = new ArrayList<>();

    Connection cn = null;
    PreparedStatement pt = null;
    ResultSet rs = null;

    ArrayList<Compra> lista;

    // LISTAR TODAS LAS COMPRAS (ADMINISTRADOR)
    public ArrayList<Compra> ListarCompra() {

        lista = new ArrayList<>();

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT c.*, " +
                "CASE WHEN c.id_usuario IS NULL THEN 'Usuario eliminado' ELSE u.nombre END AS nombre, " +
                "CASE WHEN c.id_usuario IS NULL THEN '' ELSE u.apellido END AS apellido " +
                "FROM compras c " +
                "LEFT JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                "ORDER BY c.fecha DESC"
            );

            rs = pt.executeQuery();

            while (rs.next()) {

                Compra objCompra = new Compra();

                objCompra.id_compra = rs.getInt("id_compra");
                objCompra.id_usuario = rs.getInt("id_usuario");
                objCompra.nombre_usuario = rs.getString("nombre");
                objCompra.apellido_usuario = rs.getString("apellido");
                objCompra.fecha = rs.getString("fecha");
                objCompra.total = rs.getDouble("total");
                objCompra.estado = rs.getString("estado");

                lista.add(objCompra);
            }

        } catch (Exception e) {
            System.out.println("Error al listar compras: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }

        return lista;
    }

    // ACTUALIZAR ESTADO DE UNA COMPRA
    public boolean ActualizarEstado(int idCompra, String nuevoEstado) {

        String[] estadosPermitidos = {
            "Pendiente",
            "En preparación",
            "Enviado",
            "Entregado",
            "Cancelado"
        };

        boolean valido = false;

        if (nuevoEstado == null) {
            return false;
        }

        for (String estadoPermitido : estadosPermitidos) {
            if (estadoPermitido.equals(nuevoEstado)) {
                valido = true;
                break;
            }
        }

        if (!valido || idCompra <= 0) {
            return false;
        }

        boolean resultado = false;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "UPDATE compras SET estado = ? WHERE id_compra = ?"
            );

            pt.setString(1, nuevoEstado);
            pt.setInt(2, idCompra);

            resultado = pt.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println(
                "Error al actualizar estado de compra: " + e.getMessage()
            );
        } finally {
            cerrarRecursos();
        }

        return resultado;
    }

    // LISTAR COMPRAS DE UN COMPRADOR CON SUS PRODUCTOS
    public ArrayList<Compra> ListarComprasUsuario(int idUsuario) {

        ArrayList<Compra> compras = new ArrayList<>();
        HashMap<Integer, Compra> mapaCompras = new HashMap<>();

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT c.id_compra, c.id_usuario, c.fecha, " +
                "c.total, c.estado, " +
                "d.id_detalle, d.id_producto, d.cantidad, d.precio, " +
                "p.nombre AS nombre_producto, p.imagen AS imagen_producto " +
                "FROM compras c " +
                "LEFT JOIN detalle_compra d ON c.id_compra = d.id_compra " +
                "LEFT JOIN productos p ON d.id_producto = p.id_producto " +
                "WHERE c.id_usuario = ? " +
                "ORDER BY c.fecha DESC, d.id_detalle ASC"
            );

            pt.setInt(1, idUsuario);

            rs = pt.executeQuery();

            while (rs.next()) {

                int idCompra = rs.getInt("id_compra");

                Compra compra = mapaCompras.get(idCompra);

                if (compra == null) {

                    compra = new Compra();

                    compra.id_compra = idCompra;
                    compra.id_usuario = rs.getInt("id_usuario");
                    compra.fecha = rs.getString("fecha");
                    compra.total = rs.getDouble("total");
                    compra.estado = rs.getString("estado");

                    compra.detalles = new ArrayList<>();

                    mapaCompras.put(idCompra, compra);
                    compras.add(compra);
                }

                int idProducto = rs.getInt("id_producto");

                if (!rs.wasNull()) {

                    Producto producto = new Producto();

                    producto.id_producto = idProducto;
                    producto.nombre = rs.getString("nombre_producto");
                    producto.imagen = rs.getString("imagen_producto");
                    producto.cantidad = rs.getInt("cantidad");
                    producto.precio = rs.getDouble("precio");

                    compra.detalles.add(producto);
                }
            }

        } catch (Exception e) {
            System.out.println(
                "Error al listar compras del usuario: " + e.getMessage()
            );
        } finally {
            cerrarRecursos();
        }

        return compras;
    }

    // REGISTRAR COMPRA SIMPLE
    public boolean Insertar(int id_usuario, double total) {

        boolean estado = false;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "INSERT INTO compras (id_usuario, total) VALUES (?, ?)"
            );

            pt.setInt(1, id_usuario);
            pt.setDouble(2, total);

            estado = pt.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error al registrar compra: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }

        return estado;
    }

    // REGISTRAR COMPRA COMPLETA
    public boolean RegistrarCompra(int id_usuario, ArrayList<Producto> carrito) {

        boolean resultado = false;

        HashMap<Integer, Double> precios = new HashMap<>();

        try {

            if (carrito == null || carrito.isEmpty()) {
                return false;
            }

            cn = ConexionBD.getConexionBD();
            cn.setAutoCommit(false);

            double total = 0;

            // VERIFICAR STOCK Y OBTENER PRECIOS ACTUALES
            for (Producto p : carrito) {

                if (p.cantidad <= 0) {
                    throw new SQLException("Cantidad de producto no válida");
                }

                pt = cn.prepareStatement(
                    "SELECT precio, stock FROM productos " +
                    "WHERE id_producto = ? FOR UPDATE"
                );

                pt.setInt(1, p.id_producto);

                rs = pt.executeQuery();

                if (!rs.next()) {
                    throw new SQLException("Producto no encontrado");
                }

                double precioActual = rs.getDouble("precio");
                int stockActual = rs.getInt("stock");

                rs.close();
                rs = null;

                pt.close();
                pt = null;

                if (stockActual < p.cantidad) {
                    throw new SQLException(
                        "Stock insuficiente para el producto: " + p.nombre
                    );
                }

                precios.put(p.id_producto, precioActual);

                total += precioActual * p.cantidad;
            }

            // REGISTRAR COMPRA
            pt = cn.prepareStatement(
                "INSERT INTO compras (id_usuario, total) VALUES (?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );

            pt.setInt(1, id_usuario);
            pt.setDouble(2, total);

            pt.executeUpdate();

            rs = pt.getGeneratedKeys();

            int idCompra = 0;

            if (rs.next()) {
                idCompra = rs.getInt(1);
            }

            rs.close();
            rs = null;

            pt.close();
            pt = null;

            if (idCompra == 0) {
                throw new SQLException("No se pudo obtener el código de compra");
            }

            // REGISTRAR DETALLES, DESCONTAR LOTES Y ACTUALIZAR STOCK
            for (Producto p : carrito) {

                double precioActual = precios.get(p.id_producto);

                // REGISTRAR DETALLE DE LA COMPRA
                pt = cn.prepareStatement(
                    "INSERT INTO detalle_compra " +
                    "(id_compra, id_producto, cantidad, precio) " +
                    "VALUES (?, ?, ?, ?)"
                );

                pt.setInt(1, idCompra);
                pt.setInt(2, p.id_producto);
                pt.setInt(3, p.cantidad);
                pt.setDouble(4, precioActual);

                pt.executeUpdate();

                pt.close();
                pt = null;

                // DESCONTAR LOS LOTES MÁS PRÓXIMOS A VENCER
                descontarLotes(p.id_producto, p.cantidad);

                // ACTUALIZAR STOCK GENERAL
                pt = cn.prepareStatement(
                    "UPDATE productos SET stock = stock - ? " +
                    "WHERE id_producto = ? AND stock >= ?"
                );

                pt.setInt(1, p.cantidad);
                pt.setInt(2, p.id_producto);
                pt.setInt(3, p.cantidad);

                int actualizado = pt.executeUpdate();

                pt.close();
                pt = null;

                if (actualizado == 0) {
                    throw new SQLException("No se pudo actualizar el stock");
                }
            }

            cn.commit();

            resultado = true;

        } catch (Exception e) {

            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception ex) {
                System.out.println("Error al cancelar compra: " + ex.getMessage());
            }

            System.out.println(
                "Error al registrar compra completa: " + e.getMessage()
            );

        } finally {

            try {
                if (rs != null) rs.close();
                if (pt != null) pt.close();

                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }

            } catch (Exception e) {
                System.out.println("Error al cerrar conexión: " + e.getMessage());
            }

            rs = null;
            pt = null;
            cn = null;
        }

        return resultado;
    }

    // DESCONTAR PRODUCTOS DE LOS LOTES SEGÚN SU FECHA DE VENCIMIENTO (FEFO)
    private void descontarLotes(int idProducto, int cantidad) throws SQLException {

        int pendiente = cantidad;

        PreparedStatement consulta = null;
        PreparedStatement actualizar = null;
        ResultSet resultadoConsulta = null;

        try {

            consulta = cn.prepareStatement(
                "SELECT lp.id_lote, lp.cantidad_disponible " +
                "FROM lotes_producto lp " +
                "INNER JOIN detalle_orden_compra doc " +
                "ON lp.id_detalle_orden = doc.id_detalle_orden " +
                "WHERE doc.id_producto = ? " +
                "AND lp.cantidad_disponible > 0 " +
                "ORDER BY " +
                "(doc.fecha_vencimiento IS NULL) ASC, " +
                "doc.fecha_vencimiento ASC, " +
                "lp.fecha_ingreso ASC, " +
                "lp.id_lote ASC " +
                "FOR UPDATE"
            );

            consulta.setInt(1, idProducto);

            resultadoConsulta = consulta.executeQuery();

            while (resultadoConsulta.next() && pendiente > 0) {

                int idLote = resultadoConsulta.getInt("id_lote");
                int disponible = resultadoConsulta.getInt("cantidad_disponible");

                int descontar = Math.min(pendiente, disponible);

                actualizar = cn.prepareStatement(
                    "UPDATE lotes_producto " +
                    "SET cantidad_disponible = cantidad_disponible - ? " +
                    "WHERE id_lote = ? AND cantidad_disponible >= ?"
                );

                actualizar.setInt(1, descontar);
                actualizar.setInt(2, idLote);
                actualizar.setInt(3, descontar);

                int filas = actualizar.executeUpdate();

                actualizar.close();
                actualizar = null;

                if (filas == 0) {
                    throw new SQLException(
                        "No se pudo descontar la cantidad del lote"
                    );
                }

                pendiente -= descontar;
            }

        } finally {

            if (resultadoConsulta != null) {
                resultadoConsulta.close();
            }

            if (consulta != null) {
                consulta.close();
            }

            if (actualizar != null) {
                actualizar.close();
            }
        }
    }

    // OBTENER ID DE LA ÚLTIMA COMPRA
    public int ObtenerUltimaCompra() {

        int id = 0;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT MAX(id_compra) AS id FROM compras"
            );

            rs = pt.executeQuery();

            if (rs.next()) {
                id = rs.getInt("id");
            }

        } catch (Exception e) {
            System.out.println("Error al obtener compra: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }

        return id;
    }

    // CONTAR COMPRAS
    public int TotalCompras() {

        int cantidad = 0;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT COUNT(*) AS total FROM compras"
            );

            rs = pt.executeQuery();

            if (rs.next()) {
                cantidad = rs.getInt("total");
            }

        } catch (Exception e) {
            System.out.println("Error al contar compras: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }

        return cantidad;
    }

    // OBTENER INGRESOS TOTALES
    public double TotalIngresos() {

        double ingresos = 0;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT SUM(total) AS ingresos FROM compras"
            );

            rs = pt.executeQuery();

            if (rs.next()) {
                ingresos = rs.getDouble("ingresos");
            }

        } catch (Exception e) {
            System.out.println("Error al obtener ingresos: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }

        return ingresos;
    }

    // CONTAR COMPRAS PENDIENTES
    public int ComprasPendientes() {

        int cantidad = 0;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT COUNT(*) AS total FROM compras WHERE estado = 'Pendiente'"
            );

            rs = pt.executeQuery();

            if (rs.next()) {
                cantidad = rs.getInt("total");
            }

        } catch (Exception e) {
            System.out.println("Error al contar compras pendientes: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }

        return cantidad;
    }

    // CERRAR RECURSOS
    private void cerrarRecursos() {

        try {
            if (rs != null) rs.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        try {
            if (pt != null) pt.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        try {
            if (cn != null) cn.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        rs = null;
        pt = null;
        cn = null;
    }
}
