defmodule Inertia.Plugs.AssetsCheck do
  import Plug.Conn
  import Inertia

  def init(default), do: default
  
  def call(conn, _default) do
    # if a get request, an inertia request, and asset version doesn't match, send a 409 conflict
    if conn.method == "GET" and get_req_header(conn, "x-inertia") == ["true"] and get_req_header(conn, "x-inertia-version") != [asset_version()] do
      conn
      |> put_resp_header("x-inertia", "true")
      |> put_resp_header("x-inertia-location", request_url(conn))
      |> put_resp_content_type("text/html")
      |> send_resp(:conflict, "")
      |> halt()
    else
      conn
    end
  end
end
