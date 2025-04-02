<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat en Temps Réel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #f4f4f9;
        }
        h1 {
            color: #333;
        }
        .chat-container {
            width: 400px;
            height: 500px;
            border: 1px solid #ccc;
            background-color: #fff;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        #chat {
            flex: 1;
            padding: 10px;
            overflow-y: auto;
            border-bottom: 1px solid #ccc;
        }
        #msg {
            width: calc(100% - 20px);
            padding: 10px;
            border: none;
            border-top: 1px solid #ccc;
            outline: none;
        }
        button {
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #218838;
        }
        .logout-button {
            background-color: #dc3545;
        }
        .logout-button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <h1>Chat en Temps Réel - Bienvenue, ${sessionScope.username}</h1>
    <div class="chat-container">
        <div id="chat"></div>
        <input type="text" id="msg" placeholder="Tapez votre message ici..." />
        <button onclick="sendMsg()">Envoyer</button>
        <button class="logout-button" onclick="window.location.href='logout.jsp'">Déconnexion</button>
    </div>

    <script type="text/javascript">
        var wsUrl = (window.location.protocol === 'http:') ? 'ws://' : 'wss://';
        var ws = new WebSocket(wsUrl + window.location.host + "/projet5/chat");

        ws.onopen = function(event) {
            console.log("Connexion WebSocket établie.");
        };

        ws.onmessage = function(event) {
            console.log("Message reçu : ", event.data);
            var chatDiv = document.getElementById("chat");
            chatDiv.innerHTML += "<p>" + event.data + "</p>";
            chatDiv.scrollTop = chatDiv.scrollHeight;
        };

        ws.onerror = function(event) {
            console.error("Erreur WebSocket : ", event);
        };

        ws.onclose = function(event) {
            console.log("Connexion WebSocket fermée.");
        };

        function sendMsg() {
            var msgInput = document.getElementById("msg");
            var message = msgInput.value.trim();
            if (message) {
                console.log("Envoi du message : ", message);
                ws.send(message);
                msgInput.value = "";
            }
        }

        document.getElementById("msg").addEventListener("keyup", function(event) {
            if (event.key === "Enter") {
                sendMsg();
            }
        });
    </script>
</body>
</html>