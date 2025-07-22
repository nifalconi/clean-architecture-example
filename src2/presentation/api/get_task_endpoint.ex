defmodule Presentation.Api.GetTaskEndpoint do
  @moduledoc """
  HTTP endpoint for getting a task by ID.

  This module handles HTTP requests for task retrieval,
  following the Clean Architecture principles by depending on use cases.
  """

  alias Domain.UseCases.GetTask
  alias Data.Repositories.EctoTaskRepository

  @doc """
  Handles GET request for a task by ID.

  ## Parameters

    - params: Map containing the request parameters

  ## Returns

    - `{:ok, response}` - Success response with task data
    - `{:error, status, message}` - Error response

  ## Examples

      iex> Presentation.Api.GetTaskEndpoint.handle(%{"id" => "task-123"})
      {:ok, %{success: true, data: %{id: "task-123", name: "Learn Elixir", ...}}}
  """
  @spec handle(map()) :: {:ok, map()} | {:error, integer(), String.t()}
  def handle(%{"id" => id} = _params) when is_binary(id) do
    case validate_request(%{"id" => id}) do
      {:ok, validated_params} ->
        execute_use_case(validated_params)

      {:error, reason} ->
        {:error, 400, "Validation error: #{reason}"}
    end
  end

  def handle(_params) do
    {:error, 400, "Missing required parameter: id"}
  end

  # Private functions

  defp validate_request(%{"id" => id}) when is_binary(id) and byte_size(id) > 0 do
    {:ok, %{id: id}}
  end

  defp validate_request(_) do
    {:error, "ID must be a non-empty string"}
  end

  defp execute_use_case(%{id: id}) do
    case GetTask.execute(EctoTaskRepository, id) do
      {:ok, task} ->
        {:ok, %{
          success: true,
          data: %{
            id: task.id,
            name: task.name,
            date: DateTime.to_iso8601(task.date)
          }
        }}

      {:error, :not_found} ->
        {:error, 404, "Task with id: #{id} not found"}

      {:error, :invalid_id} ->
        {:error, 400, "Invalid task ID"}

      {:error, reason} ->
        {:error, 500, "Internal server error: #{inspect(reason)}"}
    end
  end

  @doc """
  Formats the response for HTTP.

  ## Parameters

    - result: The result from handle/1

  ## Returns

    - `{status_code, headers, body}` - HTTP response tuple
  """
  @spec format_response({:ok, map()} | {:error, integer(), String.t()}) :: {integer(), list(), String.t()}
  def format_response({:ok, response}) do
    {200, [{"content-type", "application/json"}], Jason.encode!(response)}
  end

  def format_response({:error, status, message}) do
    response = %{success: false, error: message}
    {status, [{"content-type", "application/json"}], Jason.encode!(response)}
  end
end
