defmodule Stack do
  @moduledoc """
  iex> {:ok, pid} = Stack.start_link([])
  iex> :ok = Stack.push(pid, 1)
  iex> Stack.pop(pid)
  1
  iex> Stack.pop(pid)
  nil
  """

  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  def start_link(opts) do
    GenServer.start(__MODULE__,Keyword.get(opts,:state,[]))
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end


  @doc """
  Add element to stack

  ## Examples

      iex> {:ok,pid} = Stack.start_link([])
      iex> Stack.push(pid, 1)
      :ok

  """
  def push(stack_pid, element) do
    GenServer.cast(stack_pid, {:push, element})
  end

  @impl true
  def handle_call(:pop, _from, state) do
    case state do
      [head | tail] -> {:reply, head, tail}
      [] -> {:reply, nil, []}
    end
  end

  @impl true
  def handle_call(:get_stack, _from, state) do
     {:reply, state, state}
  end

  @doc """
  Remove element from the stack

  ## Examples

      iex> {:ok,pid} = Stack.start_link([])
      iex> :ok = Stack.push(pid, 1)
      iex> Stack.pop(pid)
      1

  """
  def pop(stack_pid) do
    GenServer.call(stack_pid, :pop)
  end

  def get_stack(stack_pid) do
    GenServer.call(stack_pid, :get_stack)
  end
end
