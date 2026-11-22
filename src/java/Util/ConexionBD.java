
package Util;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionBD {

    public static Connection getConexionBD() {

        Connection cn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Datos de conexión
            String host = System.getenv("DB_HOST");
            String puerto = System.getenv("DB_PORT");
            String bd = System.getenv("DB_NAME");
            String usuario = System.getenv("DB_USER");
            String clave = System.getenv("DB_PASSWORD");

            String url;

            if (host == null || host.isEmpty()) {

                // Conexión local: XAMPP
                url = "jdbc:mysql://localhost:3306/bdtienda";
                usuario = "root";
                clave = "";

            } else {

                // Conexión en la nube: TiDB Cloud
                if (puerto == null || puerto.isEmpty()) {
                    puerto = "4000";
                }

                if (bd == null || bd.isEmpty()) {
                    bd = "bdtienda";
                }

                url = "jdbc:mysql://" + host + ":" + puerto + "/" + bd
                        + "?sslMode=VERIFY_IDENTITY";
            }

            cn = DriverManager.getConnection(url, usuario, clave);

            System.out.println("¡Conexión exitosa!");

        } catch (Exception e) {
            System.out.println("Error de conexión: " + e.getMessage());
            e.printStackTrace();
        }

        return cn;
    }

    public static void main(String[] args) {
        getConexionBD();
    }
}
