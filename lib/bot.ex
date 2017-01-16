defmodule Bot do
  def get_handler(body) do
    cond do
      ~r/get pods/ |> Regex.match?(body) ->
        {:ok, &Handler.get_pods/0}
      ~r/ping$/ |> Regex.match?(body) ->
        {:ok, &Handler.ping/0}
      true ->
        {:nothandled, &Handler.nop/0}
    end
  end

  def parse(line) do
    case Poison.decode(line) do
      {:ok, payload} ->
        {_, f} = get_handler(payload |> Map.get("body"))
        f.()
      {:error, _} -> ""
    end
  end
end

defmodule Handler do
  @kubernetes_client Application.get_env(:bot, :kubernetes_client)

  def get_pods do
    pods = @kubernetes_client.pods
    |> Poison.decode!
    |> Map.get("items")
    |> Enum.map(fn i -> i |> Map.get("metadata") |> Map.get("name") end)
    |> Enum.join(", ")
    "Your running pods are: #{pods}"
  end

  def ping do
    "pong"
  end

  def nop do
  end
end

defmodule Kubernetes do
  @url "http://390483c3.ngrok.io"
  # @url "http://127.0.0.1:8001"

  def pods do
    HTTPotion.get("#{@url}/api/v1/pods").body
  end
end

defmodule Kubernetes.Sandbox do
  def pods do
    {:ok, payload} = File.read("test/fixtures/pods.json")
    payload
  end
end