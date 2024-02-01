defmodule LiveViewCounterWeb.MathGameLive do
  use LiveViewCounterWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok,
     assign(
       socket,
       %{
         timer: 3,
         score: 0,
         question: gen_question(),
         form: to_form(%{"submit_answer" => nil})
       }
     ), layout: false}
  end

  def render(assigns) do
    ~H"""
    <h1>Math Game</h1>

    <p>Score: <%= @score %></p>

    <.simple_form
      class="flex"
      id="answer-form"
      for={@form}
      phx-change="change"
      phx-submit="submit_answer"
    >
      <div>Question <%= @question[:question] %> (<%= @timer %>s)</div>
      <.input type="number" field={@form[:answer]} label="Your answer: " />
      <:actions>
        <.button>Enter</.button>
      </:actions>
    </.simple_form>
    """
  end

  def handle_info(:tick, socket) do
    if socket.assigns.timer - 1 >= 0 do
      {:noreply, assign(socket, timer: socket.assigns.timer - 1)}
    else
      {:noreply, assign(socket, timer: 3, question: gen_question())}
    end
  end

  def handle_event("change", params, socket) do
    socket =
      case Integer.parse(params["answer"]) do
        :error ->
          assign(socket,
            form: to_form(params, errors: [answer: {"Must be a valid integer", []}])
          )

        _ ->
          assign(socket, form: to_form(params))
      end

    {:noreply, socket}
  end

  def handle_event("submit_answer", params, socket) do
    socket =
      case Integer.parse(params["answer"]) do
        :error ->
          assign(socket,
            form: to_form(params, errors: [answer: {"Must be a valid integer", []}])
          )

        {int, _rest} ->
          if int == socket.assigns.question.answer do
            assign(socket, %{score: socket.assigns.score + 1, timer: 3, question: gen_question()})
          else
            assign(socket, %{score: socket.assigns.score - 1, timer: 3, question: gen_question()})
          end
      end

    {:noreply, socket}
  end

  defp gen_question() do
    a = Enum.random(1..10)
    b = Enum.random(1..10)

    %{
      question: "#{a} + #{b}",
      answer: a + b
    }
  end
end
