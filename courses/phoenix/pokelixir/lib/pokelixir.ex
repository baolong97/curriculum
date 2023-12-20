defmodule Pokemon do
  @enforce_keys [
    :id,
    :name,
    :hp,
    :attack,
    :defense,
    :special_attack,
    :special_defense,
    :speed,
    :weight,
    :height,
    :types
  ]
  defstruct @enforce_keys
end

defmodule Pokelixir do
  @moduledoc """
  Documentation for `Pokelixir`.
  """

  def get(name) do
    request = Finch.build(:get, "https://pokeapi.co/api/v2/pokemon/#{name}")
    response = Finch.request!(request, MyFinch)
    data = Jason.decode!(response.body)|> Enum.map(fn {key,val} -> {String.to_atom(key),val} end)

    struct(Pokemon,data)

  end

  def all() do
    list_res = Finch.build(:get, "https://pokeapi.co/api/v2/pokemon?limit=10") |> Finch.request!( MyFinch)
    results = Jason.decode!(list_res.body)["results"]

    tasks = Enum.map(results, fn result ->
      Task.async(fn ->
        res = Finch.build(:get, result["url"]) |> Finch.request!( MyFinch)
        data = Jason.decode!(res.body)|> Enum.map(fn {key,val} -> {String.to_atom(key),val} end)
        struct(Pokemon,data)
      end)
    end)
    Task.await_many(tasks)
  end

end
