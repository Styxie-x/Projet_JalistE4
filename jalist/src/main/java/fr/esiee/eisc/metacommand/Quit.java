// use : /quit

package fr.esiee.eisc.metacommand;

import fr.esiee.eisc.Repl;

public class Quit implements Metacommand {
    private final Repl repl;

    @Override
    public void execute(String arg) {
        repl.end();
    }

    @Override
    public void getDetailedHelp() {    }

    @Override
    public void getShortHelp() {
        System.out.println("/quit : Quit REPL terminal");
    }

    public Quit(Repl var_Repl){
        repl = var_Repl;
    }


}