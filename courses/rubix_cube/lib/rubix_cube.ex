defmodule RubixCube do
  @moduledoc """
  Documentation for `RubixCube`.
  """

  use GenServer

  @new_cube %{
    front_face: [[:red, :red, :red], [:red, :red, :red], [:red, :red, :red]],
    back_face: [
      [:orange, :orange, :orange],
      [:orange, :orange, :orange],
      [:orange, :orange, :orange]
    ],
    up_face: [
      [:yellow, :yellow, :yellow],
      [:yellow, :yellow, :yellow],
      [:yellow, :yellow, :yellow]
    ],
    down_face: [[:white, :white, :white], [:white, :white, :white], [:white, :white, :white]],
    left_face: [[:blue, :blue, :blue], [:blue, :blue, :blue], [:blue, :blue, :blue]],
    right_face: [[:green, :green, :green], [:green, :green, :green], [:green, :green, :green]]
  }

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, @new_cube}
  end

  def new() do
    GenServer.call(__MODULE__, :new)
  end

  @impl true
  def handle_call(:new, _from, _state) do
    {:reply, @new_cube, @new_cube}
  end

  def rotate_face(face, direction) do
    case direction do
      :clockwise ->
        face |> Enum.zip() |> Enum.map(fn ele -> ele |> Tuple.to_list() |> Enum.reverse() end)

      :counter_clockwise ->
        Enum.reverse(Enum.zip(face) |> Enum.map(fn ele -> ele |> Tuple.to_list() end))
    end
  end

  @doc false
  defp p_rotate_row(cube, row, direction) do
    case row do
      0 ->
        case direction do
          :left ->
            %{
              front_face: cube.front_face |> List.replace_at(0, cube.right_face |> Enum.at(0)),
              back_face: cube.back_face |> List.replace_at(0, cube.left_face |> Enum.at(0)),
              up_face: cube.up_face |> rotate_face(:clockwise),
              down_face: cube.down_face,
              left_face: cube.left_face |> List.replace_at(0, cube.front_face |> Enum.at(0)),
              right_face: cube.right_face |> List.replace_at(0, cube.back_face |> Enum.at(0))
            }

          :right ->
            %{
              front_face: cube.front_face |> List.replace_at(0, cube.left_face |> Enum.at(0)),
              back_face: cube.back_face |> List.replace_at(0, cube.right_face |> Enum.at(0)),
              up_face: cube.up_face |> rotate_face(:counter_clockwise),
              down_face: cube.down_face,
              left_face: cube.left_face |> List.replace_at(0, cube.back_face |> Enum.at(0)),
              right_face: cube.right_face |> List.replace_at(0, cube.front_face |> Enum.at(0))
            }
        end

      1 ->
        case direction do
          :left ->
            %{
              front_face: cube.front_face |> List.replace_at(1, cube.right_face |> Enum.at(1)),
              back_face: cube.back_face |> List.replace_at(1, cube.left_face |> Enum.at(1)),
              up_face: cube.up_face,
              down_face: cube.down_face,
              left_face: cube.left_face |> List.replace_at(1, cube.front_face |> Enum.at(1)),
              right_face: cube.right_face |> List.replace_at(1, cube.back_face |> Enum.at(1))
            }

          :right ->
            %{
              front_face: cube.front_face |> List.replace_at(1, cube.left_face |> Enum.at(1)),
              back_face: cube.back_face |> List.replace_at(1, cube.right_face |> Enum.at(1)),
              up_face: cube.up_face,
              down_face: cube.down_face,
              left_face: cube.left_face |> List.replace_at(1, cube.back_face |> Enum.at(1)),
              right_face: cube.right_face |> List.replace_at(1, cube.front_face |> Enum.at(1))
            }
        end

      2 ->
        case direction do
          :left ->
            %{
              front_face: cube.front_face |> List.replace_at(2, cube.right_face |> Enum.at(2)),
              back_face: cube.back_face |> List.replace_at(2, cube.left_face |> Enum.at(2)),
              up_face: cube.up_face,
              down_face: cube.down_face |> rotate_face(:counter_clockwise),
              left_face: cube.left_face |> List.replace_at(2, cube.front_face |> Enum.at(2)),
              right_face: cube.right_face |> List.replace_at(2, cube.back_face |> Enum.at(2))
            }

          :right ->
            %{
              front_face: cube.front_face |> List.replace_at(2, cube.left_face |> Enum.at(2)),
              back_face: cube.back_face |> List.replace_at(2, cube.right_face |> Enum.at(2)),
              up_face: cube.up_face,
              down_face: cube.down_face |> rotate_face(:clockwise),
              left_face: cube.left_face |> List.replace_at(2, cube.back_face |> Enum.at(2)),
              right_face: cube.right_face |> List.replace_at(2, cube.front_face |> Enum.at(2))
            }
        end
    end
  end

  @doc false
  def rotate_row(row, direction) do
    GenServer.call(__MODULE__, {:rotate_row, row, direction})
  end

  @impl true
  def handle_call({:rotate_row, row, direction}, _from, cube) do
    state = p_rotate_row(cube, row, direction)
    {:reply, state, state}
  end

  @doc false
  def rotate_cube(cube, direction) do
    case direction do
      :up ->
        %{
          front_face: cube.down_face,
          back_face: cube.up_face,
          up_face: cube.front_face,
          down_face: cube.back_face,
          left_face: cube.left_face |> rotate_face(:counter_clockwise),
          right_face: cube.right_face |> rotate_face(:clockwise)
        }

      :down ->
        %{
          front_face: cube.up_face,
          back_face: cube.down_face,
          up_face: cube.back_face,
          down_face: cube.front_face,
          left_face: cube.left_face |> rotate_face(:clockwise),
          right_face: cube.right_face |> rotate_face(:counter_clockwise)
        }

      :right ->
        %{
          front_face: cube.left_face,
          back_face: cube.right_face,
          up_face: cube.up_face |> rotate_face(:counter_clockwise),
          down_face: cube.down_face |> rotate_face(:clockwise),
          left_face: cube.back_face,
          right_face: cube.front_face
        }

      :left ->
        %{
          front_face: cube.right_face,
          back_face: cube.left_face,
          up_face: cube.up_face |> rotate_face(:clockwise),
          down_face: cube.down_face |> rotate_face(:counter_clockwise),
          left_face: cube.front_face,
          right_face: cube.back_face
        }

      :clockwise ->
        %{
          front_face: cube.front_face |> rotate_face(:clockwise),
          back_face: cube.back_face |> rotate_face(:counter_clockwise),
          up_face: cube.left_face |> rotate_face(:clockwise),
          down_face: cube.right_face |> rotate_face(:clockwise),
          left_face: cube.down_face |> rotate_face(:clockwise),
          right_face: cube.up_face |> rotate_face(:clockwise)
        }

      :counter_clockwise ->
        %{
          front_face: cube.front_face |> rotate_face(:counter_clockwise),
          back_face: cube.back_face |> rotate_face(:clockwise),
          up_face: cube.right_face |> rotate_face(:counter_clockwise),
          down_face: cube.left_face |> rotate_face(:counter_clockwise),
          left_face: cube.up_face |> rotate_face(:counter_clockwise),
          right_face: cube.down_face |> rotate_face(:counter_clockwise)
        }
    end
  end

  @doc false
  defp p_rotate_col(cube, col, direction) do
    case col do
      0 ->
        case direction do
          :up ->
            cube
            |> rotate_cube(:clockwise)
            |> p_rotate_row(0, :right)
            |> rotate_cube(:counter_clockwise)

          :down ->
            cube
            |> rotate_cube(:clockwise)
            |> p_rotate_row(0, :left)
            |> rotate_cube(:counter_clockwise)
        end

      1 ->
        case direction do
          :up ->
            cube
            |> rotate_cube(:clockwise)
            |> p_rotate_row(1, :right)
            |> rotate_cube(:counter_clockwise)

          :down ->
            cube
            |> rotate_cube(:clockwise)
            |> p_rotate_row(1, :left)
            |> rotate_cube(:counter_clockwise)
        end

      2 ->
        case direction do
          :up ->
            cube
            |> rotate_cube(:clockwise)
            |> p_rotate_row(2, :right)
            |> rotate_cube(:counter_clockwise)

          :down ->
            cube
            |> rotate_cube(:clockwise)
            |> p_rotate_row(2, :left)
            |> rotate_cube(:counter_clockwise)
        end
    end
  end

  @doc false
  def rotate_col(col, direction) do
    GenServer.call(__MODULE__, {:rotate_col, col, direction})
  end

  @impl true
  def handle_call({:rotate_col, col, direction}, _from, cube) do
    state = p_rotate_col(cube, col, direction)
    {:reply, state, state}
  end

  def same_color?(face) do
    flatten = List.flatten(face)
    MapSet.size(MapSet.new(flatten)) == 1
  end

  defp p_solved?(cube) do
    cube
    |> Enum.reduce(true, fn {_face_name, face_val}, acc ->
      acc && same_color?(face_val)
    end)
  end

  def solved?() do
    GenServer.call(__MODULE__, :solved?)
  end

  @impl true
  def handle_call(:solved?, _from, cube) do
    {:reply, p_solved?(cube), cube}
  end

  def save(filename) do
    GenServer.call(__MODULE__, {:save, filename})
  end

  @impl true
  def handle_call({:save, filename}, _from, cube) do
    a = File.write(filename, :erlang.term_to_binary(cube))
    IO.inspect(a)
    {:reply, cube, cube}
  end

  def load(filename) do
    GenServer.call(__MODULE__, {:load, filename})
  end

  @impl true
  def handle_call({:load, filename}, _from, _cube) do
    {:ok, data} = File.read(filename)
    cube = data |> :erlang.binary_to_term()

    {:reply, cube, cube}
  end
end
