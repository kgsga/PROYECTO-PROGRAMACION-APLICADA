
package Modelo;

import java.sql.*;
import Util.ConexionBD;
import java.util.ArrayList;

public class Usuario {

    public int id_usuario;
    public String nombre;
    public String apellido;
    public String dni;
    public String celular;
    public String correo;
    public String contraseña;

    Connection cn = null;
    PreparedStatement pt = null;
    ResultSet rs = null;

    ArrayList<Usuario> lista;

    // LISTAR USUARIOS
    public ArrayList<Usuario> ListarUsuario() {

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement("SELECT * FROM usuarios");
            rs = pt.executeQuery();

            lista = new ArrayList<>();

            while (rs.next()) {

                Usuario objUsuario = new Usuario();

                objUsuario.id_usuario = rs.getInt("id_usuario");
                objUsuario.nombre = rs.getString("nombre");
                objUsuario.apellido = rs.getString("apellido");
                objUsuario.dni = rs.getString("dni");
                objUsuario.celular = rs.getString("celular");
                objUsuario.correo = rs.getString("correo");
                objUsuario.contraseña = rs.getString("contraseña");

                lista.add(objUsuario);
            }

            rs.close();
            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
        }

        return lista;
    }

    // REGISTRAR USUARIO
    public boolean Insertar(String nombre, String apellido, String dni,
                            String celular, String correo, String contraseña) {

        boolean estado = false;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "INSERT INTO usuarios (nombre, apellido, dni, celular, correo, contraseña) VALUES (?, ?, ?, ?, ?, ?)"
            );

            pt.setString(1, nombre);
            pt.setString(2, apellido);
            pt.setString(3, dni);
            pt.setString(4, celular);
            pt.setString(5, correo);
            pt.setString(6, contraseña);

            estado = pt.executeUpdate() > 0;

            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al insertar usuario: " + e.getMessage());
        }

        return estado;
    }

    // ELIMINAR USUARIO
    public int eliminar(int id) {

        int estado = 0;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "DELETE FROM usuarios WHERE id_usuario = ?"
            );

            pt.setInt(1, id);

            estado = pt.executeUpdate();

            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al eliminar usuario: " + e.getMessage());
        }

        return estado;
    }

    // INICIAR SESION
    public boolean IniciarSesion(String correo, String contraseña) {

        boolean estado = false;

        try {
            cn = ConexionBD.getConexionBD();

            pt = cn.prepareStatement(
                "SELECT * FROM usuarios WHERE correo = ? AND contraseña = ?"
            );

            pt.setString(1, correo);
            pt.setString(2, contraseña);

            rs = pt.executeQuery();

            if (rs.next()) {

                id_usuario = rs.getInt("id_usuario");
                nombre = rs.getString("nombre");
                apellido = rs.getString("apellido");
                dni = rs.getString("dni");
                celular = rs.getString("celular");
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

    // ACTUALIZAR DATOS DEL USUARIO
    public boolean ActualizarDatos(int id, String nombre, String apellido,
                                   String dni, String celular, String correo,
                                   String contraseña) {

        boolean estado = false;

        try {
            cn = ConexionBD.getConexionBD();

            if (contraseña == null || contraseña.trim().isEmpty()) {

                pt = cn.prepareStatement(
                    "UPDATE usuarios SET nombre = ?, apellido = ?, dni = ?, celular = ?, correo = ? WHERE id_usuario = ?"
                );

                pt.setString(1, nombre);
                pt.setString(2, apellido);
                pt.setString(3, dni);
                pt.setString(4, celular);
                pt.setString(5, correo);
                pt.setInt(6, id);

            } else {

                pt = cn.prepareStatement(
                    "UPDATE usuarios SET nombre = ?, apellido = ?, dni = ?, celular = ?, correo = ?, contraseña = ? WHERE id_usuario = ?"
                );

                pt.setString(1, nombre);
                pt.setString(2, apellido);
                pt.setString(3, dni);
                pt.setString(4, celular);
                pt.setString(5, correo);
                pt.setString(6, contraseña);
                pt.setInt(7, id);
            }

            estado = pt.executeUpdate() > 0;

            pt.close();
            cn.close();

        } catch (Exception e) {
            System.out.println("Error al actualizar usuario: " + e.getMessage());
        }

        return estado;
    }
}
