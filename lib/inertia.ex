defmodule Inertia do
  @moduledoc """
  Documentation for `Inertia`.
  """

  @doc """
  """
  def asset_version, do: Application.get_env(:inertia, :assets_version, "1")
end
