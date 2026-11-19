
package Modelo;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import Util.ConexionBD;

public class OrdenCompra {

    public int id_orden;
    public int id_proveedor;
    public String nombre_proveedor;
    public Timestamp fecha;
    public BigDecimal total;
    public String estado;

    public ArrayList<Detalle> detalles = new ArrayList<>();

    // CLASE INTERNA PARA LOS PRODUCTOS DE CADA ORDEN
    public static class Detalle {

        public int id_detalle_orden;
        public int id_orden;
        public int id_producto;
        public String nombre_producto;
        public int cantidad;
        public BigDecimal precio;
        public Date fecha_vencimiento;

        public BigDecimal getSubtotal() {
            if (precio == null) {
                return BigDecimal.ZERO;
            }

            return precio.multiply(BigDecimal.valueOf(cantidad));
        }
    }

    // LISTAR TODAS LAS ÓRDENES DE COMPRA
    public ArrayList<OrdenCompra> Listar() {

        ArrayList<OrdenCompra> lista = new ArrayList<>();

        String sql =
            "SELECT o.*, p.nombre AS nombre_proveedor " +
            "FROM ordenes_compra o " +
            "INNER JOIN proveedores p ON o.id_proveedor = p.id_proveedor " +
            "ORDER BY o.id_orden DESC";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                OrdenCompra orden = new OrdenCompra();

                orden.id_orden = rs.getInt("id_orden");
                orden.id_proveedor = rs.getInt("id_proveedor");
                orden.nombre_proveedor = rs.getString("nombre_proveedor");
                orden.fecha = rs.getTimestamp("fecha");
                orden.total = rs.getBigDecimal("total");
                orden.estado = rs.getString("estado");

                lista.add(orden);
            }

        } catch (Exception e) {
            System.out.println("Error al listar órdenes: " + e.getMessage());
        }

        return lista;
    }

    // OBTENER LOS DETALLES DE UNA ORDEN
    public ArrayList<Detalle> ObtenerDetalles(int idOrden) {

        ArrayList<Detalle> lista = new ArrayList<>();

        String sql =
            "SELECT d.*, p.nombre AS nombre_producto " +
            "FROM detalle_orden_compra d " +
            "INNER JOIN productos p ON d.id_producto = p.id_producto " +
            "WHERE d.id_orden = ? " +
            "ORDER BY p.nombre";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql)) {

            pt.setInt(1, idOrden);

            try (ResultSet rs = pt.executeQuery()) {

                while (rs.next()) {

                    Detalle detalle = new Detalle();

                    detalle.id_detalle_orden =
                        rs.getInt("id_detalle_orden");

                    detalle.id_orden =
                        rs.getInt("id_orden");

                    detalle.id_producto =
                        rs.getInt("id_producto");

                    detalle.nombre_producto =
                        rs.getString("nombre_producto");

                    detalle.cantidad =
                        rs.getInt("cantidad");

                    detalle.precio =
                        rs.getBigDecimal("precio");

                    detalle.fecha_vencimiento =
                        rs.getDate("fecha_vencimiento");

                    lista.add(detalle);
                }
            }

        } catch (Exception e) {
            System.out.println("Error al obtener detalles: " + e.getMessage());
        }

        return lista;
    }

    // REGISTRAR UNA ORDEN DE COMPRA
    public boolean Registrar(
            int idProveedor,
            ArrayList<Detalle> productos) {

        if (idProveedor <= 0 || productos == null || productos.isEmpty()) {
            return false;
        }

        Connection cn = null;

        String sqlOrden =
            "INSERT INTO ordenes_compra " +
            "(id_proveedor, total, estado) " +
            "VALUES (?, ?, ?)";

        String sqlDetalle =
            "INSERT INTO detalle_orden_compra " +
            "(id_orden, id_producto, cantidad, precio, fecha_vencimiento) " +
            "VALUES (?, ?, ?, ?, ?)";

        try {

            cn = ConexionBD.getConexionBD();
            cn.setAutoCommit(false);

            BigDecimal totalCalculado = BigDecimal.ZERO;

            // COMPROBAR QUE EL PROVEEDOR EXISTA
            try (PreparedStatement pt = cn.prepareStatement(
                    "SELECT id_proveedor FROM proveedores WHERE id_proveedor = ?")) {

                pt.setInt(1, idProveedor);

                try (ResultSet rs = pt.executeQuery()) {
                    if (!rs.next()) {
                        cn.rollback();
                        return false;
                    }
                }
            }

            // CALCULAR EL TOTAL Y VALIDAR LOS PRODUCTOS
            String sqlValidar =
                "SELECT id_producto FROM proveedor_producto " +
                "WHERE id_proveedor = ? AND id_producto = ?";

            try (PreparedStatement ptValidar = cn.prepareStatement(sqlValidar)) {

                for (Detalle d : productos) {

                    if (d == null || d.id_producto <= 0 ||
                        d.cantidad <= 0 || d.precio == null ||
                        d.precio.compareTo(BigDecimal.ZERO) < 0) {

                        cn.rollback();
                        return false;
                    }

                    ptValidar.setInt(1, idProveedor);
                    ptValidar.setInt(2, d.id_producto);

                    try (ResultSet rs = ptValidar.executeQuery()) {

                        if (!rs.next()) {
                            cn.rollback();
                            return false;
                        }
                    }

                    totalCalculado = totalCalculado.add(
                        d.precio.multiply(BigDecimal.valueOf(d.cantidad))
                    );
                }
            }

            // REGISTRAR LA CABECERA DE LA ORDEN
            int idNuevaOrden;

            try (PreparedStatement pt = cn.prepareStatement(
                    sqlOrden, Statement.RETURN_GENERATED_KEYS)) {

                pt.setInt(1, idProveedor);
                pt.setBigDecimal(2, totalCalculado);
                pt.setString(3, "Pendiente");

                pt.executeUpdate();

                try (ResultSet rs = pt.getGeneratedKeys()) {

                    if (!rs.next()) {
                        cn.rollback();
                        return false;
                    }

                    idNuevaOrden = rs.getInt(1);
                }
            }

            // REGISTRAR LOS PRODUCTOS DE LA ORDEN
            try (PreparedStatement pt = cn.prepareStatement(sqlDetalle)) {

                for (Detalle d : productos) {

                    pt.setInt(1, idNuevaOrden);
                    pt.setInt(2, d.id_producto);
                    pt.setInt(3, d.cantidad);
                    pt.setBigDecimal(4, d.precio);

                    if (d.fecha_vencimiento != null) {
                        pt.setDate(5, d.fecha_vencimiento);
                    } else {
                        pt.setNull(5, Types.DATE);
                    }

                    pt.addBatch();
                }

                pt.executeBatch();
            }

            cn.commit();
            return true;

        } catch (Exception e) {

            System.out.println("Error al registrar orden: " + e.getMessage());

            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception ex) {
                System.out.println("Error al revertir: " + ex.getMessage());
            }

            return false;

        } finally {

            try {
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
            } catch (Exception e) {
                System.out.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
    }

    // ACTUALIZAR EL ESTADO DE UNA ORDEN
    public boolean ActualizarEstado(int idOrden, String nuevoEstado) {

        String[] estadosPermitidos = {
            "Pendiente",
            "Enviada",
            "Recibida",
            "Cancelada"
        };

        boolean estadoValido = false;

        if (nuevoEstado == null) {
            return false;
        }

        for (String estadoPermitido : estadosPermitidos) {
            if (estadoPermitido.equals(nuevoEstado)) {
                estadoValido = true;
                break;
            }
        }

        if (!estadoValido || idOrden <= 0) {
            return false;
        }

        Connection cn = null;

        try {

            cn = ConexionBD.getConexionBD();
            cn.setAutoCommit(false);

            String estadoActual;

            // BLOQUEAR LA ORDEN MIENTRAS SE ACTUALIZA
            try (PreparedStatement pt = cn.prepareStatement(
                    "SELECT estado FROM ordenes_compra " +
                    "WHERE id_orden = ? FOR UPDATE")) {

                pt.setInt(1, idOrden);

                try (ResultSet rs = pt.executeQuery()) {

                    if (!rs.next()) {
                        cn.rollback();
                        return false;
                    }

                    estadoActual = rs.getString("estado");
                }
            }

            // EVITAR RECIBIR UNA ORDEN DOS VECES
            if ("Recibida".equalsIgnoreCase(estadoActual)) {
                cn.rollback();
                return false;
            }

            // NO PERMITIR CAMBIAR UNA ORDEN CANCELADA
            if ("Cancelada".equalsIgnoreCase(estadoActual)) {
                cn.rollback();
                return false;
            }

            // SI SE RECIBE, REGISTRAR LOS LOTES Y AUMENTAR EL STOCK
            if ("Recibida".equals(nuevoEstado)) {

                // COMPROBAR QUE LA ORDEN TENGA PRODUCTOS
                try (PreparedStatement pt = cn.prepareStatement(
                        "SELECT COUNT(*) FROM detalle_orden_compra " +
                        "WHERE id_orden = ?")) {

                    pt.setInt(1, idOrden);

                    try (ResultSet rs = pt.executeQuery()) {

                        if (rs.next() && rs.getInt(1) == 0) {
                            cn.rollback();
                            return false;
                        }
                    }
                }

                // CREAR UN LOTE POR CADA DETALLE DE LA ORDEN
                // La cantidad disponible inicia igual a la cantidad recibida.
                String sqlLotes =
                    "INSERT INTO lotes_producto " +
                    "(id_detalle_orden, cantidad, cantidad_disponible) " +
                    "SELECT id_detalle_orden, cantidad, cantidad " +
                    "FROM detalle_orden_compra " +
                    "WHERE id_orden = ?";

                try (PreparedStatement pt = cn.prepareStatement(sqlLotes)) {

                    pt.setInt(1, idOrden);

                    int lotesCreados = pt.executeUpdate();

                    if (lotesCreados == 0) {
                        cn.rollback();
                        return false;
                    }
                }

                // AUMENTAR EL STOCK DE CADA PRODUCTO
                String sqlStock =
                    "UPDATE productos p " +
                    "INNER JOIN (" +
                    "   SELECT id_producto, SUM(cantidad) AS cantidad_total " +
                    "   FROM detalle_orden_compra " +
                    "   WHERE id_orden = ? " +
                    "   GROUP BY id_producto " +
                    ") d ON p.id_producto = d.id_producto " +
                    "SET p.stock = p.stock + d.cantidad_total";

                try (PreparedStatement pt = cn.prepareStatement(sqlStock)) {

                    pt.setInt(1, idOrden);

                    int filas = pt.executeUpdate();

                    if (filas == 0) {
                        cn.rollback();
                        return false;
                    }
                }
            }

            // ACTUALIZAR EL ESTADO
            try (PreparedStatement pt = cn.prepareStatement(
                    "UPDATE ordenes_compra SET estado = ? WHERE id_orden = ?")) {

                pt.setString(1, nuevoEstado);
                pt.setInt(2, idOrden);

                if (pt.executeUpdate() == 0) {
                    cn.rollback();
                    return false;
                }
            }

            cn.commit();
            return true;

        } catch (Exception e) {

            System.out.println("Error al actualizar orden: " + e.getMessage());

            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception ex) {
                System.out.println("Error al revertir: " + ex.getMessage());
            }

            return false;

        } finally {

            try {
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
            } catch (Exception e) {
                System.out.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
    }
}
