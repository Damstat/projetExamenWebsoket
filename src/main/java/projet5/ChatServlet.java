package projet5;

import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/chat")
public class ChatServlet {

    private static Set<Session> userSessions = Collections.newSetFromMap(new ConcurrentHashMap<Session, Boolean>());

    @OnOpen
    public void onOpen(Session curSession) {
        userSessions.add(curSession);
        System.out.println("Nouvelle connexion : " + curSession.getId());
    }

    @OnClose
    public void onClose(Session curSession) {
        userSessions.remove(curSession);
        System.out.println("Connexion fermée : " + curSession.getId());
    }

    @OnMessage
    public void onMessage(String message, Session userSession) {
        System.out.println("Message reçu de " + userSession.getId() + " : " + message);
        for (Session ses : userSessions) {
            ses.getAsyncRemote().sendText(message);
        }
    }
}