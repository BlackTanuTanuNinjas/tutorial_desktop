defmodule TutorialDesktop do
  use Application
  @env Mix.env()
  def config_dir() do
    case(@env) do
      :test ->
        "tmp"

      _ ->
        {path, _} =
          Code.eval_string("Path.join([Desktop.OS.home(), dir, app])",
            dir: ".config",
            app: "tutorial_desktop"
          )

        path
    end
  end

  @app Mix.Project.config()[:app]
  def start(:normal, []) do
    File.mkdir_p!(config_dir())

    :session = :ets.new(:session, [:named_table, :public, read_concurrency: true])

    children = [
      {Phoenix.PubSub, name: TutorialDesktop.PubSub},
      {Finch, name: TutorialDesktop.Finch},
      TutorialDesktopWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TutorialDesktop.Supervisor]
    {:ok, sup} = Supervisor.start_link(children, opts)

    {:ok, {_ip, port}} = Bandit.PhoenixAdapter.server_info(TutorialDesktopWeb.Endpoint, :http)

    {:ok, _} =
      Supervisor.start_child(sup, {
        Desktop.Window,
        [
          app: @app,
          id: TutorialDesktopWindow,
          title: "tutorial_desktop",
          size: {400, 800},
          url: "http://localhost:#{port}"
        ]
      })
  end

  def config_change(changed, _new, removed) do
    TutorialDesktopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
