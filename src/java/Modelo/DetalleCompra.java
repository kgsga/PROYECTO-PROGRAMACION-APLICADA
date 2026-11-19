
package Modelo;

import java.sql.*;
import Util.ConexionBD;
import java.util.ArrayList;

public class DetalleCompra {

    public int id_detalle;
    public int id_compra;
    public int id_producto;
    public int cantidad;
    public double precio;

    // Datos adicionales del producto
    public String nombre_producto;
    public String imagen_producto;

    Connection cn = null;
    PreparedStatement pt = null;
    ResultSet rs = null;

    ArrayList<DetalleCompra> lista;

    // LISTAR DETALLES DE UNA COMPRA
    public ArrayList<DetalleCompra> ListarDetalleCompra(int id) {

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT dc.*, " +
                "p.nombre AS nombre_producto, " +
                "p.imagen AS imagen_producto " +
                "FROM detalle_compra dc " +
                "LEFT JOIN productos p ON dc.id_producto = p.id_producto " +
                "WHERE dc.id_compra = ?"
            );

            pt.setInt(1, id);

            rs = pt.executeQuery();

            lista = new ArrayList<DetalleCompra>();

            while (rs.next()) {

                DetalleCompra objDetalle = new DetalleCompra();

                objDetalle.id_detalle = rs.getInt("id_detalle");
                objDetalle.id_compra = rs.getInt("id_compra");
                objDetalle.id_producto = rs.getInt("id_producto");
                objDetalle.cantidad = rs.getInt("cantidad");
                objDetalle.precio = rs.getDouble("precio");

                objDetalle.nombre_producto = rs.getString("nombre_producto");
                objDetalle.imagen_producto = rs.getString("imagen_producto");

                lista.add(objDetalle);
            }

            rs.close();
            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al listar detalles: " + e.getMessage());
        }

        return lista;
    }

    // REGISTRAR DETALLE DE COMPRA
    public boolean Insertar(int id_compra, int id_producto,
                            int cantidad, double precio) {

        boolean estado = false;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "INSERT INTO detalle_compra " +
                "(id_compra, id_producto, cantidad, precio) " +
                "VALUES (?, ?, ?, ?)"
            );

            pt.setInt(1, id_compra);
            pt.setInt(2, id_producto);
            pt.setInt(3, cantidad);
            pt.setDouble(4, precio);

            estado = pt.executeUpdate() > 0;

            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al registrar detalle: " + e.getMessage());
        }

        return estado;
    }
}
