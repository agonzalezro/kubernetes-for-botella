defmodule BotTest do
  use ExUnit.Case
  doctest Bot

  test "it understands when it's asked about pods" do
    assert {:ok, &Handler.get_pods/0} == Bot.get_handler("get pods")
  end

  test "it understands when it's asked about services" do
    assert {:ok, &Handler.get_services/0} == Bot.get_handler("get services")
  end

  test "it understands when it's asked about events" do
    assert {:ok, &Handler.get_events/0} == Bot.get_handler("get events")
  end

  test "it doesn't understand some random phrase" do
    assert {:nothandled, &Handler.nop/0} == Bot.get_handler("some random stuff")
  end

  test "it calls the functions that understand" do
    {:ok, payload} = File.read("test/fixtures/botella.json")
    assert Bot.parse(payload) == "pong"
  end
end

defmodule HandlerTest do
  use ExUnit.Case

  test "it returns a list of pods" do
    assert Handler.get_pods == "Your running pods are: hello-minikube-3015430129-hhmmm, kube-addon-manager-minikube, kube-dns-v20-df1rz, kubernetes-dashboard-hzqh3"
  end

  test "it returns a list of services" do
    assert Handler.get_services == "Your running services are: kubernetes, nginx-ingress"
  end

  test "it returns the list of messages of the latest 10 events" do
    assert length(String.split(Handler.get_events, "\n")) == 11
  end
end
