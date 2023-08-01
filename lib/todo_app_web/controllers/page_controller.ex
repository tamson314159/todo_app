defmodule TodoAppWeb.PageController do
  use TodoAppWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    IO.inspect(conn, label: "conn")
    render(conn, :home, layout: false)
  end
end
