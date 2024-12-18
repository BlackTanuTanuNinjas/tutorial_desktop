defmodule TutorialDesktopWeb.SampleLive do
  use TutorialDesktopWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
