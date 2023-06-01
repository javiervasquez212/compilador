package com.compiler;

import java.io.File;
import java.io.StringReader;
import java.nio.file.Files;
import java.util.Scanner;
import java.util.concurrent.Callable;

import picocli.CommandLine;

import static picocli.CommandLine.*;

@Command(name = "compilador", mixinStandardHelpOptions = true, version = "0.0.1",
description = "Analizador lexico, semantico y sintactico")



public class App implements Callable<Integer>
{
    @Option(names = {"-f", "--file"},description = "File to read", required = false)
    File file;

    @Override
    public Integer call() throws Exception{

        if (file != null) {
        Lexer lexer = new Lexer(Files.newBufferedReader(file.toPath()));
        Parser p = new Parser(lexer);
        System.out.println(p.parse().value);
        }else{
            Scanner scanner = new Scanner(System.in);
            System.out.println("");
            do {
                System.out.println("ingrese la expresion: ");
                String input = scanner.nextLine();
                if (input.equals("exit")) {
                    break;
                }
                Lexer lexer = new Lexer(new StringReader(input));
                Parser p = new Parser(lexer);
                System.out.println(p.parse().value);

            } while (true);
            return(0);
        }



        return null;
    }
    public static void main( String[] args )
    {
        int exitCode = new CommandLine(new App()).execute(args);
        System.exit(exitCode);
    }
}
