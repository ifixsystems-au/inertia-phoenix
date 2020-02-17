defmodule Inertia.Renderer do
  @moduledoc """
  """
  import Phoenix.Controller
  import Plug.Conn
  import Inertia

  def inertia(conn, component, props \\ []) do
    page = %{
      "component" => component,
      "props" => props,
      "url" => conn.request_path,
      "version" => asset_version()
    }
    case get_req_header(conn, "x-inertia") do
      ["true"] -> 
        conn
        |> put_resp_header("x-inertia", "true")
        |> put_resp_header("vary", "Accept")
        |> json(page)
      _ ->
        render(conn, "app.html", %{page: Jason.encode!(page)})
    end
  end
end
