package fr.esiee.eisc.metacommand;

import fr.esiee.eisc.Repl;

public class Quit implements Metacommand {
    private final Repl repl;
    String arg = null;

    @Override
    public void execute(String arg) {
        repl.end();
    }

    public Quit(Repl var_Repl){
        repl = var_Repl;
    }
}