import {Socket} from "phoenix";

class Chat {
    static init(socket) {
        var $messages = $("#messages");
        var $input = $("#message-input");

        var addMessage = (msg) => {
            $messages.append(this.messageTemplate(msg));
        };

        socket.onOpen( ev => console.log("OPEN", ev) );
        socket.onError( ev => console.log("ERROR", ev) );
        socket.onClose( ev => console.log("CLOSE", ev));

        // --- JOIN ---

        // chat:lobbyというトピックのチャネル
        var chan = socket.channel("room:chat", {});

        // チャネルに接続(join)
        chan.join()
            .receive("ignore", () => console.log("auth error"))
            .receive("ok", (messages) => {
                messages.forEach(msg => $messages.append(this.messageTemplate(msg)));
                scrollTo(0, document.body.scrollHeight);
                console.log("join ok");
            })
            .receive("timeout", () => console.log("Connection interruption"));
        chan.onError(e => console.log("something went wrong", e));
        chan.onClose(e => console.log("channel closed", e));

        // --- INPUT ---

        $input.off("keypress").on("keypress", e => {
            if (e.keyCode == 13) {
                // new_msgという種類のメッセージ(userとbodyのJSON)をチャネルに送信
                chan.push("chat", {body: $input.val()});
                $input.val("");
            }
        });

        // --- REPLY ---

        // チャネルからnew_msgという種類のメッセージを受信した時の処理
        chan.on("chat", msg => {
            addMessage(msg);
            scrollTo(0, document.body.scrollHeight);
        });
    }

    // --- UTILS ---

    static sanitize(html){ return $("<div/>").text(html).html(); }

    static messageTemplate(msg){
        let body = this.sanitize(msg.body);
        return(`<p>${body}</p>`);
    }
}

export default Chat;
