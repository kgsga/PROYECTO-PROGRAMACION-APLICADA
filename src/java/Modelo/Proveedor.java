
package Modelo;

import java.sql.*;
import java.util.ArrayList;
import Util.ConexionBD;

public class Proveedor {

    public int id_proveedor;
    public String nombre;
    public String ruc;
    public String telefono;
    public String correo;
    public String direccion;

    // Productos que ofrece el proveedor
    public ArrayList<String> productos = new ArrayList<>();

    // LISTAR PROVEEDORES Y SUS PRODUCTOS
    public ArrayList<Proveedor> Listar() {

        ArrayList<Proveedor> lista = new ArrayList<>();

        String sqlProveedores =
            "SELECT * FROM proveedores ORDER BY id_proveedor DESC";

        String sqlProductos =
            "SELECT p.nombre FROM proveedor_producto pp " +
            "INNER JOIN productos p ON pp.id_producto = p.id_producto " +
            "WHERE pp.id_proveedor = ? ORDER BY p.nombre";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sqlProveedores);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                Proveedor p = new Proveedor();

                p.id_proveedor = rs.getInt("id_proveedor");
                p.nombre = rs.getString("nombre");
                p.ruc = rs.getString("ruc");
                p.telefono = rs.getString("telefono");
                p.correo = rs.getString("correo");
                p.direccion = rs.getString("direccion");

                // Obtener los productos de este proveedor
                try (PreparedStatement ptProductos =
                        cn.prepareStatement(sqlProductos)) {

                    ptProductos.setInt(1, p.id_proveedor);

                    try (ResultSet rsProductos = ptProductos.executeQuery()) {

                        while (rsProductos.next()) {
                            p.productos.add(rsProductos.getString("nombre"));
                        }
                    }
                }

                lista.add(p);
            }

        } catch (Exception e) {
            System.out.println("Error al listar proveedores: " + e.getMessage());
        }

        return lista;
    }

    // REGISTRAR PROVEEDOR
    public boolean Registrar() {
        return Registrar(null);
    }

    // REGISTRAR PROVEEDOR Y ASIGNAR PRODUCTOS
    public boolean Registrar(String[] idsProductos) {

        String sql =
            "INSERT INTO proveedores " +
            "(nombre, ruc, telefono, correo, direccion) " +
            "VALUES (?, ?, ?, ?, ?)";

        Connection cn = null;

        try {

            cn = ConexionBD.getConexionBD();
            cn.setAutoCommit(false);

            int idNuevo;

            try (PreparedStatement pt = cn.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS)) {

                pt.setString(1, nombre);
                pt.setString(2, ruc);
                pt.setString(3, telefono);
                pt.setString(4, correo);
                pt.setString(5, direccion);

                pt.executeUpdate();

                try (ResultSet rs = pt.getGeneratedKeys()) {

                    if (!rs.next()) {
                        cn.rollback();
                        return false;
                    }

                    idNuevo = rs.getInt(1);
                }
            }

            guardarProductos(cn, idNuevo, idsProductos);

            cn.commit();
            return true;

        } catch (Exception e) {

            System.out.println("Error al registrar proveedor: " + e.getMessage());

            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
            }

            return false;

        } finally {

            try {
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // MODIFICAR PROVEEDOR
    public boolean Modificar() {
        return Modificar(null);
    }

    // MODIFICAR PROVEEDOR Y ACTUALIZAR SUS PRODUCTOS
    public boolean Modificar(String[] idsProductos) {

        String sql =
            "UPDATE proveedores SET nombre=?, ruc=?, telefono=?, " +
            "correo=?, direccion=? WHERE id_proveedor=?";

        Connection cn = null;

        try {

            cn = ConexionBD.getConexionBD();
            cn.setAutoCommit(false);

            int filas;

            try (PreparedStatement pt = cn.prepareStatement(sql)) {

                pt.setString(1, nombre);
                pt.setString(2, ruc);
                pt.setString(3, telefono);
                pt.setString(4, correo);
                pt.setString(5, direccion);
                pt.setInt(6, id_proveedor);

                filas = pt.executeUpdate();
            }

            if (filas == 0) {
                cn.rollback();
                return false;
            }

            // Reemplazar las relaciones anteriores por las nuevas
            try (PreparedStatement pt = cn.prepareStatement(
                    "DELETE FROM proveedor_producto WHERE id_proveedor=?")) {

                pt.setInt(1, id_proveedor);
                pt.executeUpdate();
            }

            guardarProductos(cn, id_proveedor, idsProductos);

            cn.commit();
            return true;

        } catch (Exception e) {

            System.out.println("Error al modificar proveedor: " + e.getMessage());

            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
            }

            return false;

        } finally {

            try {
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // GUARDAR LOS PRODUCTOS ASIGNADOS A UN PROVEEDOR
    private void guardarProductos(
            Connection cn,
            int idProveedor,
            String[] idsProductos) throws SQLException {

        if (idsProductos == null || idsProductos.length == 0) {
            return;
        }

        String sql =
            "INSERT INTO proveedor_producto (id_proveedor, id_producto) " +
            "VALUES (?, ?)";

        try (PreparedStatement pt = cn.prepareStatement(sql)) {

            for (String id : idsProductos) {

                if (id == null || id.trim().isEmpty()) {
                    continue;
                }

                int idProducto = Integer.parseInt(id);

                pt.setInt(1, idProveedor);
                pt.setInt(2, idProducto);
                pt.addBatch();
            }

            pt.executeBatch();
        }
    }

    // ELIMINAR PROVEEDOR
    public boolean Eliminar(int id) {

        boolean resultado = false;

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(
                "DELETE FROM proveedores WHERE id_proveedor=?")) {

            pt.setInt(1, id);

            resultado = pt.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {

            System.out.println(
                "No se puede eliminar el proveedor porque tiene órdenes registradas."
            );

        } catch (Exception e) {

            System.out.println("Error al eliminar proveedor: " + e.getMessage());
        }

        return resultado;
    }
}
