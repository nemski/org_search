defmodule OrgSearch.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that generate a list of repositories
  that match a search string
  """

  def main(argv) do
    argv
      |> parse_args
      |> process
      |> print
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it should be a github user or organisation and search string.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help  ])

    case parse do

      { [ help: true ], _, _ }
        -> :help

      { _, [ org, search ], _ }
        -> { org, search }

      _ -> :help

    end
  end

  def process(:help) do
    IO.puts """
    usage: org_search <user> <search string>
    """
    System.halt(0)
  end

  def process({org, search}) do
    OrgSearch.Github.fetch(org, search)
  end

  def print({:ok, result}) do
    {_, items} = List.keyfind(result, "items", 0)
    repo_names = for item <- items do
      {_, repo} = List.keyfind(item, "repository", 0)
      {_, repo_name} = List.keyfind(repo, "name", 0)
      repo_name
    end |> Enum.uniq

    for repo_name <- repo_names, do: IO.puts repo_name
  end

  def print({:error, reason}), do: IO.puts "Failed to fetch results: #{reason}"
end
