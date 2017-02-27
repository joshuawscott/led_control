defmodule Ui do
  use Application

  # FIXME: Needs to be in config.
  @pin_numbers [4,17,27,22,5,6,13,19,26,18,23,24,25,12,16,20,21]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    #FIXME: Config
    pins = @pin_numbers
    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Ui.Endpoint, []),
      # TODO: support input pins
      worker(Ui.Pins, [pins])
      # Start your own worker by calling: Ui.Worker.start_link(arg1, arg2, arg3)
      # worker(Ui.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ui.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Ui.Endpoint.config_change(changed, removed)
    :ok
  end
end
