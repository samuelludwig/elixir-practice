defmodule Chatter.Roomchannel do
  use ChatterWeb, :channel
  alias Chatter.Presence

  def join("room:lobby", _, socket) do
    send self(), :after_join
    {:ok, socket}
  end
end
