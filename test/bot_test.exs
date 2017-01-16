defmodule BotTest do
  use ExUnit.Case
  doctest Bot

  test "it understand when it's asked about pods" do
    assert {:ok, &Handler.get_pods/0} == Bot.get_handler("get pods")
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
end
