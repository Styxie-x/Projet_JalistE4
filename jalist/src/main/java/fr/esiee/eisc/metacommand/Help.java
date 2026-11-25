package fr.esiee.eisc.metacommand;
// /help : la méta-commande help affiche toutes les commandes et méta-commandes supportées avec pour chacune un court texte d’explication. Il est possible également de passer un argument à la méta-commande help pour avoir une explication plus détaillée sur une commande ou méta-commande.

import java.util.Map;

public class Help implements Metacommand {

    private final Map<String, Metacommand> mc;
    @Override
    public void execute(String arg) {
        if(arg == null || arg.isEmpty()){
            for(Metacommand cmd : mc.values()){
                cmd.getShortHelp();
            }
        } else {
            Metacommand cmd = mc.get(arg);
            if(cmd == null){
                System.out.println(" Unknow command");
            } else{
                cmd.getDetailedHelp();
            }

        }

    }

    @Override
    public void getDetailedHelp() {
        this.getShortHelp();
        System.out.println("    Usage : /help <command>: displays help of command");

    }

    @Override
    public void getShortHelp() {
        System.out.println("/help : display help of all available commands");
    }

    public Help(Map<String, Metacommand> arg_mc){
        mc = arg_mc;
    }

}