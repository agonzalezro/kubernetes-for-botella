defmodule Mix.Tasks.Bot.Run do
  use Mix.Task

  @shortdoc "Run the bot and wait for an input line"

  def run(_) do
    HTTPoison.start
    IO.gets("") |> Bot.parse |> IO.puts
  end
end
