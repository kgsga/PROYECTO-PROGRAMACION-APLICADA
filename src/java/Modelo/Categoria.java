package Modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import Util.ConexionBD;

public class Categoria {

    public int id_categoria;
    public String nombre;

    // LISTAR CATEGORÍAS
    public ArrayList<Categoria> ListarCategorias() {

        ArrayList<Categoria> lista = new ArrayList<>();

        String sql = "SELECT id_categoria, nombre "
                   + "FROM categorias "
                   + "ORDER BY id_categoria";

        try (Connection cn = ConexionBD.getConexionBD();
             PreparedStatement pt = cn.prepareStatement(sql);
             ResultSet rs = pt.executeQuery()) {

            while (rs.next()) {

                Categoria cat = new Categoria();

                cat.id_categoria = rs.getInt("id_categoria");
                cat.nombre = rs.getString("nombre");

                lista.add(cat);
            }

        } catch (Exception e) {
            System.out.println("Error al listar categorías: " + e.getMessage());
        }

        return lista;
    }
}