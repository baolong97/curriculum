defmodule Games.Wordle do
  @moduledoc """
   Documentation for `Games.Wordle`.
  """
  @doc """
  feedback.

  ## Examples

      iex> Games.Wordle.feedback("AAA","AAA")
      [:green,:green,:green]
      iex> Games.Wordle.feedback("AAA","BBB")
      [:grey, :grey, :grey]
  """
  @spec feedback(String.t(), String.t()) :: [atom()]
  def feedback(answer, guess) do
    answer_list = String.to_charlist(answer)
    guess_list = String.to_charlist(guess)

    {used_index, result} =
      Enum.reduce(
        Enum.with_index(Enum.zip(answer_list, guess_list)),
        {[], []},
        fn {{ch1, ch2}, index}, {used_index, result} ->
          if ch1 == ch2 do
            {[index | used_index], result ++ [:green]}
          else
            {used_index, result ++ [ch2]}
          end
        end
      )

    {_, result} =
      Enum.reduce(result, {used_index, []}, fn ch, {used_index, result} ->
        if is_atom(ch) do
          {used_index, result ++ [ch]}
        else
          index =
            Enum.find(Enum.with_index(answer_list), fn {c, index} ->
              c == ch && !Enum.member?(used_index, index)
            end)

          if index do
            {_, i} = index
            {[i | used_index], result ++ [:yellow]}
          else
            {used_index, result ++ [:grey]}
          end
        end
      end)

    result
  end

  @spec play(String.t(), integer()) :: String.t()
  defp play(answer, attempts \\ 0) do
    guess = IO.gets("Enter a give letter word: ") |> String.trim()

    if guess == answer do
      "You win!"
    else
      if attempts == 5 do
        "You lose! the answer was #{answer}"
      else
        IO.puts(
          Enum.zip(String.split(guess, "", trim: true), feedback(answer, guess))
          |> Enum.map(fn {char, color} ->
            case color do
              :green -> IO.ANSI.green() <> char
              :yellow -> IO.ANSI.yellow() <> char
              :grey -> IO.ANSI.light_black() <> char
            end
          end)
          |> List.to_string()
        )

        IO.puts("" <> IO.ANSI.reset())
        play(answer, attempts + 1)
      end
    end
  end

  @spec play() :: String.t()
  def play() do
    answer = Enum.random(["toast", "tarts", "hello", "beats"])
    play(answer)
  end
end
