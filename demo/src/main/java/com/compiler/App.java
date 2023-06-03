package com.compiler;

import java.io.BufferedReader;
import java.io.FileReader;

public class App {
    public static void main(String[] args) {
        try {
            // Aquí asumimos que el archivo "prueba.txt" está en la misma carpeta que el archivo .java
            BufferedReader reader = new BufferedReader(new FileReader("prueba.txt"));
            Lexer lexer = new Lexer(reader);
            Parser p = new Parser(lexer);
            p.parse();
            System.out.println("Analisis realizado correctamente.");
        } catch(Exception e) {
            System.out.println("Ocurrió un error durante el análisis: " + e.getMessage());
        }
    }
}
