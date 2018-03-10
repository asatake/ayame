defmodule AyameWeb.RoomChannel do
  use AyameWeb, :channel

  def join("room:chat", payload, socket) do
    Process.flag(:trap_exit, true)
    {:ok, load_messages(), socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("chat", payload, socket) do
    save_message(payload)
    broadcast! socket, "chat", %{"body" => payload["body"] <> "(#{length :ets.lookup_element(Ayame.PubSub.Local0, "room:chat", 2)})"}
    {:reply, {:ok, payload}, socket}
  end

  def load_messages() do
    Agent.get(Ayame.History, fn messages -> Enum.reverse(messages) end)
  end

  def save_message(message) do
    Agent.update(Ayame.History, fn messages -> [message | messages] end)
  end

end
