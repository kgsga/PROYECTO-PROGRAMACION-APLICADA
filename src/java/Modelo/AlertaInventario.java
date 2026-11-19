
package Modelo;

import java.sql.*;
import Util.ConexionBD;
import java.util.ArrayList;

public class AlertaInventario {

    public int id_producto;
    public String nombre;
    public int stock;
    public int stock_minimo;

    public int id_lote;
    public int cantidad_disponible;
    public Date fecha_vencimiento;

    // PRODUCTOS CON STOCK BAJO
    public ArrayList<AlertaInventario> ListarStockBajo() {

        ArrayList<AlertaInventario> lista = new ArrayList<>();

        String sql = "SELECT id_producto, nombre, stock, stock_minimo "
                   + "FROM productos "
                   + "WHERE stock <= stock_minimo "
                   + "ORDER BY stock ASC";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                AlertaInventario alerta = new AlertaInventario();

                alerta.id_producto = rs.getInt("id_producto");
                alerta.nombre = rs.getString("nombre");
                alerta.stock = rs.getInt("stock");
                alerta.stock_minimo = rs.getInt("stock_minimo");

                lista.add(alerta);
            }

        } catch (Exception e) {
            System.out.println("Error al listar productos con stock bajo: "
                    + e.getMessage());
        }

        return lista;
    }

    // LOTES DE PRODUCTOS VENCIDOS
    public ArrayList<AlertaInventario> ListarLotesVencidos() {

        ArrayList<AlertaInventario> lista = new ArrayList<>();

        String sql = "SELECT lp.id_lote, p.id_producto, p.nombre, "
                   + "lp.cantidad_disponible, doc.fecha_vencimiento "
                   + "FROM lotes_producto lp "
                   + "INNER JOIN detalle_orden_compra doc "
                   + "ON lp.id_detalle_orden = doc.id_detalle_orden "
                   + "INNER JOIN productos p "
                   + "ON doc.id_producto = p.id_producto "
                   + "WHERE lp.cantidad_disponible > 0 "
                   + "AND doc.fecha_vencimiento < CURDATE() "
                   + "ORDER BY doc.fecha_vencimiento ASC";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                AlertaInventario alerta = new AlertaInventario();

                alerta.id_lote = rs.getInt("id_lote");
                alerta.id_producto = rs.getInt("id_producto");
                alerta.nombre = rs.getString("nombre");
                alerta.cantidad_disponible =
                        rs.getInt("cantidad_disponible");
                alerta.fecha_vencimiento =
                        rs.getDate("fecha_vencimiento");

                lista.add(alerta);
            }

        } catch (Exception e) {
            System.out.println("Error al listar lotes vencidos: "
                    + e.getMessage());
        }

        return lista;
    }

    // LOTES PROXIMOS A VENCER (SIGUIENTES 30 DIAS)
    public ArrayList<AlertaInventario> ListarLotesProximosVencer() {

        ArrayList<AlertaInventario> lista = new ArrayList<>();

        String sql = "SELECT lp.id_lote, p.id_producto, p.nombre, "
                   + "lp.cantidad_disponible, doc.fecha_vencimiento "
                   + "FROM lotes_producto lp "
                   + "INNER JOIN detalle_orden_compra doc "
                   + "ON lp.id_detalle_orden = doc.id_detalle_orden "
                   + "INNER JOIN productos p "
                   + "ON doc.id_producto = p.id_producto "
                   + "WHERE lp.cantidad_disponible > 0 "
                   + "AND doc.fecha_vencimiento >= CURDATE() "
                   + "AND doc.fecha_vencimiento <= "
                   + "DATE_ADD(CURDATE(), INTERVAL 30 DAY) "
                   + "ORDER BY doc.fecha_vencimiento ASC";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                AlertaInventario alerta = new AlertaInventario();

                alerta.id_lote = rs.getInt("id_lote");
                alerta.id_producto = rs.getInt("id_producto");
                alerta.nombre = rs.getString("nombre");
                alerta.cantidad_disponible =
                        rs.getInt("cantidad_disponible");
                alerta.fecha_vencimiento =
                        rs.getDate("fecha_vencimiento");

                lista.add(alerta);
            }

        } catch (Exception e) {
            System.out.println("Error al listar lotes próximos a vencer: "
                    + e.getMessage());
        }

        return lista;
    }
}
