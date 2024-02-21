defmodule RubixCubeTest do
  use ExUnit.Case
  doctest RubixCube

  test "rotate_row/3 left" do
    {:ok, cube} = RubixCube.start_link([])

    assert %{
             front_face: [
               [:green, :green, :green],
               [:red, :red, :red],
               [:red, :red, :red]
             ],
             back_face: [
               [:blue, :blue, :blue],
               [:orange, :orange, :orange],
               [:orange, :orange, :orange]
             ],
             up_face: [
               [:yellow, :yellow, :yellow],
               [:yellow, :yellow, :yellow],
               [:yellow, :yellow, :yellow]
             ],
             down_face: [
               [:white, :white, :white],
               [:white, :white, :white],
               [:white, :white, :white]
             ],
             left_face: [
               [:red, :red, :red],
               [:blue, :blue, :blue],
               [:blue, :blue, :blue]
             ],
             right_face: [
               [:orange, :orange, :orange],
               [:green, :green, :green],
               [:green, :green, :green]
             ]
           } == RubixCube.rotate_row(0, :left)
  end

  test "rotate_row/3 right" do
    {:ok, cube} = RubixCube.start_link([])

    assert %{
             front_face: [
               [:blue, :blue, :blue],
               [:red, :red, :red],
               [:red, :red, :red]
             ],
             back_face: [
               [:green, :green, :green],
               [:orange, :orange, :orange],
               [:orange, :orange, :orange]
             ],
             up_face: [
               [:yellow, :yellow, :yellow],
               [:yellow, :yellow, :yellow],
               [:yellow, :yellow, :yellow]
             ],
             down_face: [
               [:white, :white, :white],
               [:white, :white, :white],
               [:white, :white, :white]
             ],
             left_face: [
               [:orange, :orange, :orange],
               [:blue, :blue, :blue],
               [:blue, :blue, :blue]
             ],
             right_face: [
               [:red, :red, :red],
               [:green, :green, :green],
               [:green, :green, :green]
             ]
           } == RubixCube.rotate_row(0, :right)
  end

  test "rotate_col/3 up" do
    {:ok, cube} = RubixCube.start_link([])

    assert %{
             front_face: [[:white, :red, :red], [:white, :red, :red], [:white, :red, :red]],
             back_face: [
               [:orange, :orange, :yellow],
               [:orange, :orange, :yellow],
               [:orange, :orange, :yellow]
             ],
             up_face: [
               [:red, :yellow, :yellow],
               [:red, :yellow, :yellow],
               [:red, :yellow, :yellow]
             ],
             down_face: [
               [:orange, :white, :white],
               [:orange, :white, :white],
               [:orange, :white, :white]
             ],
             left_face: [[:blue, :blue, :blue], [:blue, :blue, :blue], [:blue, :blue, :blue]],
             right_face: [
               [:green, :green, :green],
               [:green, :green, :green],
               [:green, :green, :green]
             ]
           } == RubixCube.rotate_col(0, :up)
  end

  test "rotate_col/3 down" do
    {:ok, cube} = RubixCube.start_link([])

    assert %{
             front_face: [[:yellow, :red, :red], [:yellow, :red, :red], [:yellow, :red, :red]],
             back_face: [
               [:orange, :orange, :white],
               [:orange, :orange, :white],
               [:orange, :orange, :white]
             ],
             up_face: [
               [:orange, :yellow, :yellow],
               [:orange, :yellow, :yellow],
               [:orange, :yellow, :yellow]
             ],
             down_face: [
               [:red, :white, :white],
               [:red, :white, :white],
               [:red, :white, :white]
             ],
             left_face: [[:blue, :blue, :blue], [:blue, :blue, :blue], [:blue, :blue, :blue]],
             right_face: [
               [:green, :green, :green],
               [:green, :green, :green],
               [:green, :green, :green]
             ]
           } == RubixCube.rotate_col(0, :down)
  end

  test "mixed rotate" do
    {:ok, cube} = RubixCube.start_link([])

    RubixCube.rotate_row(0, :right)
    RubixCube.rotate_col(0, :up)
    RubixCube.rotate_row(2, :left)
    RubixCube.rotate_col(2, :down)
    RubixCube.rotate_col(2, :up)
    RubixCube.rotate_row(2, :right)
    RubixCube.rotate_col(0, :down)
    cube = RubixCube.rotate_row(0, :left)
    new_cube = RubixCube.new()

    assert new_cube == cube
  end

  test "solved?/1" do
    {:ok, cube} = RubixCube.start_link([])
    assert RubixCube.solved?() == true
    RubixCube.rotate_row(0, :right)
    assert RubixCube.solved?() == false
  end
end
