package fr.esiee.eisc.metacommand;

public interface Metacommand {
        void execute(String arg);
        void getDetailedHelp();
        void getShortHelp();

}
