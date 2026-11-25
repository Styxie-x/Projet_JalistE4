package fr.esiee.eisc;

import fr.esiee.eisc.metacommand.Help;
import fr.esiee.eisc.metacommand.Metacommand;
import fr.esiee.eisc.metacommand.Quit;

import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Repl {
    private boolean shell_status = false;
    private String input;
    private Scanner scanner;
    private final Map<String, Metacommand> metacommand = new HashMap<>();




    public Repl() {
            metacommand.put("/quit", new Quit(this));
            metacommand.put("/help", new Help(metacommand));
    }

    public void start(){
        shell_status = true;
        System.out.println("==========================================");
        System.out.println("   JaList REPL v1.0 - List & String Shell ");
        System.out.println("   Commands: /help  |  Exit: /quit        ");
        System.out.println("==========================================");

        scanner = new Scanner(System.in);
        while(shell_status){
            if (read()) {
                evaluate(input);
                print();
            }
        }
    }

    public boolean read(){
        System.out.print(">");
        if(scanner.hasNextLine()) {
            input = scanner.nextLine();
            return true;
        }else{
            end();
            return false;
        }
    }
    public void evaluate(String input) {
        if(input.trim().startsWith("/"))
        {
            String[] parts = input.trim().split("\\s+", 2);

            Metacommand mc = metacommand.get(parts[0]);
            if((parts.length == 1)){
                if (mc != null) {
                    mc.execute(null);
                }
            } else {
                if (mc != null) {
                    mc.execute(parts[1]);
                }
            }
        } else if (input.contains("$")) {

            
        }

    }
    public void print(){
        System.out.println();
    }

    public void end(){
        scanner.close();
        shell_status = false;

    }

}
