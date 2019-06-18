defmodule Auction do
  alias Auction.{FakeRepo, Item}

  @repo FakeRepo

  def list_items do
	@repo.all(Item)
  end

  def get_item(id) do
	@repo.get!(Item, id)
  end

  def get_item_by(attrs) do
	@repo.get_by(Items, attrs)
  end
end

defmodule Auction.Item do
  defstruct [:id, :title, :description, :ends_at]
end

defmodule Auction.FakeRepo do
  alias Auction.Item

  @items [
  	%Item{
  	  id: 1,
  	  title: "My first item",
  	  description: "A proper good item",
  	  ends_at: ~N[2020-01-01 00:00:00]
  	},
  	%Item{
  	  id: 2,
  	  title: "Consider Phlebas",
  	  description: "God I hope amazon doesn't fuck the cake on this one",
  	  ends_at: ~N[2018-10-15 18:35:21]
  	},
  	%Item{
  	  id: 3,
  	  title: "Bionicle 2: Ledgends of Mata Nui Soundtrack",
  	  description: "Absolute bangers",
  	  ends_at: ~N[2038-01-01 00:00:00]
  	}
  ]

  def all(Item), do: @items

  def get!(Item, id) do
	Enum.find(@items, fn(item) -> item.id === id end)
  end

  def get_by(Item, attrs) do
	Enum.find(@items, fn(item) -> 
	  Enum.all?(Map.keys(attrs), fn(key) -> 
	    Map.get(item, key) === attrs[key]
	  end)
	end) 
  end
end