package controllers.ExNormal23;

import java.util.Set;

public class Mensagem {
    String emailRemetente;
    Set<String> lst_destinatarios;
    String assunto;
    String texto;
    String getRemetente() {return emailRemetente;}
    Set<String> getLista_destinatarios() {return lst_destinatarios;}
}