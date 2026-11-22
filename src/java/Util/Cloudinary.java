package Util;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import java.util.regex.*;

public class Cloudinary{

    private static final String CLOUD_NAME =
            System.getenv("CLOUDINARY_CLOUD_NAME");

    private static final String API_KEY =
            System.getenv("CLOUDINARY_API_KEY");

    private static final String API_SECRET =
            System.getenv("CLOUDINARY_API_SECRET");

    private static final String FOLDER = "productos";

    // SUBIR IMAGEN
    public static Map<String, String> subirImagen(InputStream archivo)
            throws Exception {

        comprobarConfiguracion();

        long timestamp = System.currentTimeMillis() / 1000;

        Map<String, String> parametros = new TreeMap<>();
        parametros.put("folder", FOLDER);
        parametros.put("timestamp", String.valueOf(timestamp));

        String firma = generarFirma(parametros);

        String boundary = "----CloudinaryBoundary" + UUID.randomUUID();

        URL url = new URL(
            "https://api.cloudinary.com/v1_1/"
            + CLOUD_NAME + "/image/upload"
        );

        HttpURLConnection conexion =
                (HttpURLConnection) url.openConnection();

        conexion.setRequestMethod("POST");
        conexion.setDoOutput(true);
        conexion.setRequestProperty(
                "Content-Type",
                "multipart/form-data; boundary=" + boundary
        );

        try (OutputStream salida = conexion.getOutputStream()) {

            escribirCampo(salida, boundary, "api_key", API_KEY);
            escribirCampo(salida, boundary, "timestamp",
                    String.valueOf(timestamp));
            escribirCampo(salida, boundary, "folder", FOLDER);
            escribirCampo(salida, boundary, "signature", firma);

            salida.write(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
            salida.write(("Content-Disposition: form-data; name=\"file\"; filename=\"imagen\"\r\n")
                    .getBytes(StandardCharsets.UTF_8));
            salida.write(("Content-Type: application/octet-stream\r\n\r\n")
                    .getBytes(StandardCharsets.UTF_8));

            byte[] buffer = new byte[8192];
            int bytesLeidos;

            while ((bytesLeidos = archivo.read(buffer)) != -1) {
                salida.write(buffer, 0, bytesLeidos);
            }

            salida.write(("\r\n--" + boundary + "--\r\n")
                    .getBytes(StandardCharsets.UTF_8));
        }

        int codigo = conexion.getResponseCode();

        InputStream respuesta = codigo >= 200 && codigo < 300
                ? conexion.getInputStream()
                : conexion.getErrorStream();

        String json;

        try (BufferedReader lector = new BufferedReader(
                new InputStreamReader(respuesta, StandardCharsets.UTF_8))) {

            StringBuilder contenido = new StringBuilder();
            String linea;

            while ((linea = lector.readLine()) != null) {
                contenido.append(linea);
            }

            json = contenido.toString();
        }

        conexion.disconnect();

        if (codigo < 200 || codigo >= 300) {
            throw new Exception("Error al subir imagen: " + json);
        }

        String secureUrl = extraer(json, "secure_url");
        String publicId = extraer(json, "public_id");

        if (secureUrl == null || publicId == null) {
            throw new Exception("Cloudinary no devolvió los datos de la imagen.");
        }

        Map<String, String> resultado = new HashMap<>();
        resultado.put("url", secureUrl);
        resultado.put("public_id", publicId);

        return resultado;
    }

    // ELIMINAR IMAGEN
    public static boolean eliminarImagen(String publicId)
            throws Exception {

        if (publicId == null || publicId.trim().isEmpty()) {
            return true;
        }

        comprobarConfiguracion();

        long timestamp = System.currentTimeMillis() / 1000;

        Map<String, String> parametros = new TreeMap<>();
        parametros.put("public_id", publicId);
        parametros.put("timestamp", String.valueOf(timestamp));

        String firma = generarFirma(parametros);

        String boundary = "----CloudinaryBoundary" + UUID.randomUUID();

        URL url = new URL(
            "https://api.cloudinary.com/v1_1/"
            + CLOUD_NAME + "/image/destroy"
        );

        HttpURLConnection conexion =
                (HttpURLConnection) url.openConnection();

        conexion.setRequestMethod("POST");
        conexion.setDoOutput(true);
        conexion.setRequestProperty(
                "Content-Type",
                "multipart/form-data; boundary=" + boundary
        );

        try (OutputStream salida = conexion.getOutputStream()) {

            escribirCampo(salida, boundary, "api_key", API_KEY);
            escribirCampo(salida, boundary, "timestamp",
                    String.valueOf(timestamp));
            escribirCampo(salida, boundary, "public_id", publicId);
            escribirCampo(salida, boundary, "signature", firma);

            salida.write(("--" + boundary + "--\r\n")
                    .getBytes(StandardCharsets.UTF_8));
        }

        int codigo = conexion.getResponseCode();

        InputStream respuesta = codigo >= 200 && codigo < 300
                ? conexion.getInputStream()
                : conexion.getErrorStream();

        String json;

        try (BufferedReader lector = new BufferedReader(
                new InputStreamReader(respuesta, StandardCharsets.UTF_8))) {

            StringBuilder contenido = new StringBuilder();
            String linea;

            while ((linea = lector.readLine()) != null) {
                contenido.append(linea);
            }

            json = contenido.toString();
        }

        conexion.disconnect();

        if (codigo < 200 || codigo >= 300) {
            throw new Exception("Error al eliminar imagen: " + json);
        }

        return json.contains("\"result\":\"ok\"")
                || json.contains("\"result\":\"not found\"");
    }

    // GENERAR FIRMA SHA-1
    private static String generarFirma(Map<String, String> parametros)
            throws Exception {

        StringBuilder cadena = new StringBuilder();

        for (Map.Entry<String, String> entrada : parametros.entrySet()) {

            if (cadena.length() > 0) {
                cadena.append("&");
            }

            cadena.append(entrada.getKey())
                  .append("=")
                  .append(entrada.getValue());
        }

        cadena.append(API_SECRET);

        MessageDigest md = MessageDigest.getInstance("SHA-1");

        byte[] hash = md.digest(
                cadena.toString().getBytes(StandardCharsets.UTF_8)
        );

        StringBuilder resultado = new StringBuilder();

        for (byte b : hash) {
            resultado.append(String.format("%02x", b));
        }

        return resultado.toString();
    }

    // ESCRIBIR CAMPO MULTIPART
    private static void escribirCampo(
            OutputStream salida,
            String boundary,
            String nombre,
            String valor) throws IOException {

        salida.write(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        salida.write(("Content-Disposition: form-data; name=\"" + nombre + "\"\r\n\r\n")
                .getBytes(StandardCharsets.UTF_8));
        salida.write(valor.getBytes(StandardCharsets.UTF_8));
        salida.write("\r\n".getBytes(StandardCharsets.UTF_8));
    }

    // EXTRAER VALORES DEL JSON
    private static String extraer(String json, String campo) {

        Pattern patron = Pattern.compile(
                "\"" + campo + "\"\\s*:\\s*\"((?:\\\\.|[^\"])*)\""
        );

        Matcher matcher = patron.matcher(json);

        if (matcher.find()) {
            return matcher.group(1);
        }

        return null;
    }

    // COMPROBAR CONFIGURACIÓN
    private static void comprobarConfiguracion() {

        if (CLOUD_NAME == null || CLOUD_NAME.trim().isEmpty()
                || API_KEY == null || API_KEY.trim().isEmpty()
                || API_SECRET == null || API_SECRET.trim().isEmpty()) {

            throw new IllegalStateException(
                    "Faltan las variables de entorno de Cloudinary."
            );
        }
    }
}