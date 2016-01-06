defmodule OrgSearch.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that generate a list of repositories
  that match a search string
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it should be a github organisation, token and search string.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help  ])

    case parse do

      { [ help: true ], _, _ }
        -> :help

      { _, [ org, token, search ], _ }
        -> { org, token, search }

      _ -> :help

    end
  end

  def process(:help) do
    IO.puts """
    usage: org_search <organisation> <github token> <search string>
    """
    System.halt(0)
  end

  def process({org, token, search}) do
    OrgSearch.Github.fetch(org, token, search)
  end
end