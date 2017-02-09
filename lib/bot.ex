defmodule Bot do
  def get_handler(body) do
    cond do
      ~r/get pods/ |> Regex.match?(body) ->
        {:ok, &Handler.get_pods/0}
      ~r/get services/ |> Regex.match?(body) ->
        {:ok, &Handler.get_services/0}
      ~r/get events/ |> Regex.match?(body) ->
        {:ok, &Handler.get_events/0}
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
    |> Enum.map(&(get_in(&1, ["metadata", "name"])))
    |> Enum.join(", ")
    "Your running pods are: #{pods}"
  end

  def get_services do
    services = @kubernetes_client.services
    |> Poison.decode!
    |> Map.get("items")
    |> Enum.map(&(get_in(&1, ["metadata", "name"])))
    |> Enum.join(", ")
    "Your running services are: #{services}"
  end

  def get_events do
    events = @kubernetes_client.events
    |> Poison.decode!
    |> Map.get("items")
    |> Enum.map(&(Map.get(&1, "message")))
    |> Enum.take(-10)
    ["Last 10 events: " | events] |> Enum.join("\n")
  end

  def ping do
    "pong"
  end

  def nop do
  end
end

defmodule Kubernetes do
  def headers do
    token = Application.get_env(:bot, :token)
    ["Authorization": "Bearer #{token}"]
  end

  def get(resource) do
    apiserver = Application.get_env(:bot, :apiserver)
    {:ok, response} = HTTPoison.get("#{apiserver}/api/v1/#{resource}", headers(), hackney: [:insecure])
    response.body
  end

  def pods do
    get("pods")
  end

  def services do
    get("services")
  end

  def events do
    get("events")
  end
end

# TODO: move this to test/
defmodule Kubernetes.Sandbox do
  def from_fixture(fixture) do
    {:ok, payload} = File.read("test/fixtures/#{fixture}.json")
    payload
  end

  def pods do
    from_fixture("pods")
  end

  def services do
    from_fixture("services")
  end

  def events do
    from_fixture("events")
  end
end
