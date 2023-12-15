defmodule FileSearch do
  @moduledoc """
  Documentation for FileSearch
  """

  @doc """
  Find all nested files.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
    /sub2
      file2.txt
    /sub3
      file3.txt
    file4.txt

  It would return:

  ["file1.txt", "file2.txt", "file3.txt", "file4.txt"]
  """
  def all(folder) do
    File.ls!(folder)
    |> Enum.reduce([], fn path, acc ->
      if File.dir?(Path.join(folder, path)) do
        acc ++ all(Path.join(folder, path))
      else
        acc ++ [path]
      end
    end)
  end

  @doc """
  Find all nested files and categorize them by their extension.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
      file1.png
    /sub2
      file2.txt
      file2.png
    /sub3
      file3.txt
      file3.jpg
    file4.txt

  The exact order and return value are up to you as long as it finds all files
  and categorizes them by file extension.

  For example, it might return the following:

  %{
    ".txt" => ["file1.txt", "file2.txt", "file3.txt", "file4.txt"],
    ".png" => ["file1.png", "file2.png"],
    ".jpg" => ["file3.jpg"]
  }
  """
  def by_extension(folder) do
    all(folder)
    |> Enum.group_by(fn val ->
      [_, ex] = String.split(val, ".")
      ".#{ex}"
    end)
  end

  def to_string_list(list) do
    "[#{Enum.join(list, ", ")}]"
  end

  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [type: :string, path: :string])
    path = opts[:path]

    if opts[:type] do
      files = by_extension(path)
      IO.puts(files[opts[:type]] |> to_string_list())
    else
      IO.puts(all(path) |> to_string_list())
    end
  end
end
