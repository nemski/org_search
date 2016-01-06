defmodule OrgSearch.Github do
  @github_url Application.get_env(:org_search, :github_url)
  @auth_token Application.get_env(:org_search, :api_token)

  def fetch(org, search_term) do
    issues_url(org, search_term)
      |> HTTPoison.get(headers(@auth_token))
      |> handle_response
  end

  def issues_url(org, search_term) do
    "#{@github_url}/search/code?q=#{search_term}+user:#{org}"
  end

  def headers(nil), do: [user_agent]

  def headers(auth_token) do
    [ user_agent, auth_header(auth_token) ]
  end

  def auth_header(auth_token) do
    {"Authorization", "token #{auth_token}"}
  end

  def user_agent do
    {"User-agent", "Elixir"}
  end

  def handle_response({result, %HTTPoison.Response{status_code: ___, body: body}}) do
    { result, :jsx.decode(body) }
  end
end