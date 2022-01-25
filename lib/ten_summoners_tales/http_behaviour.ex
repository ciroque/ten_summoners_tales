defmodule TenSummonersTales.HttpBehaviour do
  @moduledoc """
    This is actually quite icky, depending on this to mimic the HTTPoison definitions found here:

    https://github.com/edgurgel/httpoison/blob/2fd87f0826b86e8a64eff3ece3a50a1cf89a021c/lib/httpoison/base.ex

    TODO: Find a better way to create an abstraction over the HTTPoison library for mocking
  """

  @typep url     :: binary()
  @typep headers :: [{atom, binary}] | [{binary, binary}] | %{binary => binary}

  @callback get(url, headers) :: Response.t() | AsyncResponse.t()
end
