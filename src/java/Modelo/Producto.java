package Modelo;

import java.sql.*;
import Util.ConexionBD;
import java.util.ArrayList;

public class Producto {

    public int id_producto;
    public String nombre;
    public String descripcion;
    public double precio;
    public int stock;
    public String imagen;
    public int cantidad;

    public int id_categoria;
    public String nombre_categoria;

    // LISTAR PRODUCTOS
    public ArrayList<Producto> ListarProducto() {

        ArrayList<Producto> lista = new ArrayList<>();

        String sql = "SELECT p.*, c.nombre AS nombre_categoria "
                   + "FROM productos p "
                   + "LEFT JOIN categorias c "
                   + "ON p.id_categoria = c.id_categoria "
                   + "ORDER BY p.id_producto";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                Producto objProducto = new Producto();

                objProducto.id_producto = rs.getInt("id_producto");
                objProducto.nombre = rs.getString("nombre");
                objProducto.descripcion = rs.getString("descripcion");
                objProducto.precio = rs.getDouble("precio");
                objProducto.stock = rs.getInt("stock");
                objProducto.imagen = rs.getString("imagen");
                objProducto.id_categoria = rs.getInt("id_categoria");
                objProducto.nombre_categoria = rs.getString("nombre_categoria");

                lista.add(objProducto);
            }

        } catch (Exception e) {
            System.out.println("Error al listar productos: " + e.getMessage());
        }

        return lista;
    }

    // AGREGAR PRODUCTO
    public boolean Insertar(String nombre, String descripcion,
                            double precio, int stock, String imagen,
                            int id_categoria) {

        String sql = "INSERT INTO productos "
                   + "(nombre, descripcion, precio, stock, imagen, id_categoria) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql)) {

            pt.setString(1, nombre);
            pt.setString(2, descripcion);
            pt.setDouble(3, precio);
            pt.setInt(4, stock);
            pt.setString(5, imagen);
            pt.setInt(6, id_categoria);

            return pt.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error al insertar producto: " + e.getMessage());
            return false;
        }
    }

    // MODIFICAR PRODUCTO
    public boolean Modificar(int id, String nombre, String descripcion,
                             double precio, int stock, String imagen,
                             int id_categoria) {

        String sql = "UPDATE productos SET nombre=?, descripcion=?, "
                   + "precio=?, stock=?, imagen=?, id_categoria=? "
                   + "WHERE id_producto=?";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql)) {

            pt.setString(1, nombre);
            pt.setString(2, descripcion);
            pt.setDouble(3, precio);
            pt.setInt(4, stock);
            pt.setString(5, imagen);
            pt.setInt(6, id_categoria);
            pt.setInt(7, id);

            return pt.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error al modificar producto: " + e.getMessage());
            return false;
        }
    }

    // ELIMINAR PRODUCTO
    public int eliminar(int id) {

        String sql = "DELETE FROM productos WHERE id_producto = ?";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql)) {

            pt.setInt(1, id);

            return pt.executeUpdate();

        } catch (Exception e) {
            System.out.println("Error al eliminar producto: " + e.getMessage());
            return 0;
        }
    }
}