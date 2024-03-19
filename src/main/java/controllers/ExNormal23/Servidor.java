package controllers.ExNormal23;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Servidor {
    List<Mensagem> caixaIn; // INBOX
    List<Mensagem> caixaOut; // OUTBOX

    public List<Mensagem> getCaixaIn() {
        return caixaIn;
    }

    public List<Mensagem> getCaixaOut() {
        return caixaOut;
    }

    // Implement a method that returns a Map
    // with the number of sent messages per user to each user
    public Map<String, Map<String, Integer>> numberOfSentMessagesPerUserToEachUser() {
        Map<String, Map<String, Integer>> result = new HashMap<>();

        // Cada mensagem na Outbox, terá um remetente e a respetiva lista de destinatários
        for (Mensagem mensagem : caixaOut) {
            String remetente = mensagem.getRemetente();
            Set<String> destinatarios = mensagem.getLista_destinatarios();

            Map<String, Integer> map = result.get(remetente);
            for (String destinatario : destinatarios) {
                map.put(destinatario, map.getOrDefault(destinatario, 0) + 1);
            }
        }

        return result;
    }
}