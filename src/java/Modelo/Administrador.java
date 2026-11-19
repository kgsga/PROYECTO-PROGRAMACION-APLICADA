
package Modelo;

import java.sql.*;
import Util.ConexionBD;

public class Administrador {

    public int id_admin;
    public String nombre;
    public String apellido;
    public String correo;
    public String contraseña;

    Connection cn = null;
    PreparedStatement pt = null;
    ResultSet rs = null;

    public boolean IniciarSesion(String correo, String contraseña) {

        boolean estado = false;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT * FROM administradores WHERE correo = ? AND contraseña = ?"
            );

            pt.setString(1, correo);
            pt.setString(2, contraseña);

            rs = pt.executeQuery();

            if (rs.next()) {
                id_admin = rs.getInt("id_admin");
                nombre = rs.getString("nombre");
                apellido = rs.getString("apellido");
                this.correo = rs.getString("correo");
                this.contraseña = rs.getString("contraseña");

                estado = true;
            }

            rs.close();
            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al iniciar sesión: " + e.getMessage());
        }

        return estado;
    }
}
