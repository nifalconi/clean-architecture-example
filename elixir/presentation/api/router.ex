defmodule Presentation.Api.Router do
  @moduledoc """
  HTTP router for the API.

  Thin by design: it only translates between HTTP and the endpoint's
  `handle/1` + `format_response/1` functions, and owns no business logic.
  """

  use Plug.Router

  alias Presentation.Api.GetTaskEndpoint

  plug(:match)
  plug(:dispatch)

  get "/api/tasks/:id" do
    {status, headers, body} =
      %{"id" => id}
      |> GetTaskEndpoint.handle()
      |> GetTaskEndpoint.format_response()

    conn
    |> merge_resp_headers(headers)
    |> send_resp(status, body)
  end

  match _ do
    body = Jason.encode!(%{success: false, error: "Route not found"})

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(404, body)
  end
end
