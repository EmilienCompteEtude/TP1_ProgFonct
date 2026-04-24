defmodule MiniDiscord.Salon do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, %{name: name, clients: []},
      name: via(name))
  end

  def rejoindre(salon, pid), do: GenServer.call(via(salon), {:rejoindre, pid})
  def quitter(salon, pid),   do: GenServer.call(via(salon), {:quitter, pid})
  def broadcast(salon, msg), do: GenServer.cast(via(salon), {:broadcast, msg})

  def lister do
    Registry.select(MiniDiscord.Registry, [{{:"$1", :_, :_}, [], [:"$1"]}])
  end

  def init(state), do: {:ok, state}

  def handle_call({:rejoindre, pid}, _from, state) do
    Process.monitor(pid)
    new_clients = Enum.uniq([pid | state.clients])
    {:reply, :ok, %{state | clients: new_clients}}
  end

  def handle_call({:quitter, pid}, _from, state) do
    new_clients = List.delete(state.clients, pid)
    {:reply, :ok, %{state | clients: new_clients}}
  end

  def handle_cast({:broadcast, msg}, state) do
    Enum.each(state.clients, fn pid ->
      send(pid, {:message, msg})
    end)

    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    new_clients = List.delete(state.clients, pid)
    {:noreply, %{state | clients: new_clients}}
  end

  defp via(name), do: {:via, Registry, {MiniDiscord.Registry, name}}
end